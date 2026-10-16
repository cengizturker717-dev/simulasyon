"""Merge high-part-count moving assemblies for the controller GPU.

The source CAD exports hundreds of child meshes.  Their transforms are baked
inside each mechanical motion group and primitives are joined by material, so
the existing QML axis bindings remain unchanged while draw calls fall sharply.
"""
from pathlib import Path
import copy
import json
import math
import struct
import sys

import numpy as np


source = Path(sys.argv[1])
target = Path(sys.argv[2]) if len(sys.argv) > 2 else source
reduction = float(sys.argv[3]) if len(sys.argv) > 3 else 0.0
preserve_border = (len(sys.argv) < 5 or sys.argv[4].lower() not in ("0", "false", "no"))
if reduction:
    try:
        import fast_simplification
    except ImportError as error:
        raise SystemExit("fast-simplification is required when reduction is used") from error
blob = source.read_bytes()
json_size = struct.unpack_from("<I", blob, 12)[0]
gltf = json.loads(blob[20:20 + json_size])
binary = bytearray(blob[28 + json_size:])

COMPONENT = {5126: "<f4", 5125: "<u4", 5123: "<u2", 5121: "u1"}
WIDTH = {"SCALAR": 1, "VEC2": 2, "VEC3": 3, "VEC4": 4}


def accessor(index):
    item = gltf["accessors"][index]
    view = gltf["bufferViews"][item["bufferView"]]
    offset = view.get("byteOffset", 0) + item.get("byteOffset", 0)
    count = item["count"] * WIDTH[item["type"]]
    return np.frombuffer(binary, dtype=COMPONENT[item["componentType"]],
                         offset=offset, count=count).reshape(item["count"], -1).copy()


def node_matrix(node):
    if "matrix" in node:
        return np.asarray(node["matrix"], dtype=np.float64).reshape(4, 4).T
    t = np.asarray(node.get("translation", [0, 0, 0]), dtype=np.float64)
    s = np.asarray(node.get("scale", [1, 1, 1]), dtype=np.float64)
    x, y, z, w = node.get("rotation", [0, 0, 0, 1])
    r = np.array([
        [1 - 2*y*y - 2*z*z, 2*x*y - 2*z*w, 2*x*z + 2*y*w],
        [2*x*y + 2*z*w, 1 - 2*x*x - 2*z*z, 2*y*z - 2*x*w],
        [2*x*z - 2*y*w, 2*y*z + 2*x*w, 1 - 2*x*x - 2*y*y],
    ], dtype=np.float64)
    m = np.eye(4)
    m[:3, :3] = r @ np.diag(s)
    m[:3, 3] = t
    return m


def add_view(raw, target_code):
    while len(binary) % 4:
        binary.append(0)
    offset = len(binary)
    binary.extend(raw)
    index = len(gltf["bufferViews"])
    gltf["bufferViews"].append({"buffer": 0, "byteOffset": offset,
                                "byteLength": len(raw), "target": target_code})
    return index


def add_accessor(values, kind, component, target_code):
    values = np.ascontiguousarray(values)
    view = add_view(values.tobytes(), target_code)
    result = {"bufferView": view, "componentType": component,
              "count": len(values), "type": kind}
    if kind == "VEC3":
        result["min"] = values.min(axis=0).astype(float).tolist()
        result["max"] = values.max(axis=0).astype(float).tolist()
    gltf["accessors"].append(result)
    return len(gltf["accessors"]) - 1


def find_scene_root(name):
    for index in gltf["scenes"][gltf.get("scene", 0)]["nodes"]:
        node_name = gltf["nodes"][index].get("name", "")
        if node_name == name or (name == "BASE" and node_name.endswith("FT_2136")
                                 and not node_name.endswith(".001")):
            return index
    raise KeyError(name)


def simplify(positions, indices):
    if not reduction or len(indices) < 1000:
        return positions.astype("<f4"), indices.astype("<u4")
    vertices, faces = fast_simplification.simplify(
        positions.astype(np.float64), indices.astype(np.int32),
        target_reduction=reduction, agg=5.0, preserve_border=preserve_border)
    return vertices.astype("<f4"), faces.astype("<u4")


def vertex_normals(positions, indices):
    normals = np.zeros_like(positions, dtype=np.float64)
    triangles = positions[indices]
    face_normals = np.cross(triangles[:, 1] - triangles[:, 0],
                            triangles[:, 2] - triangles[:, 0])
    for corner in range(3):
        np.add.at(normals, indices[:, corner], face_normals)
    lengths = np.linalg.norm(normals, axis=1)
    return (normals / np.maximum(lengths[:, None], 1e-12)).astype("<f4")


def merge_root(name):
    root_index = find_scene_root(name)
    root = gltf["nodes"][root_index]
    groups = {}
    source_models = 0

    def walk(index, parent_transform):
        nonlocal source_models
        node = gltf["nodes"][index]
        node_name = node.get("name", "")
        # The router bellows, their base plates and brush are visual-only.
        # They were moving with Z as a rigid assembly. Keep the HSD motor,
        # mounting bracket and ISO holder, and omit this exact named assembly.
        if name == "9KW.001" and node_name == "2100_FREZE MOT_HSD 2_KÖRÜK_MONTAJLI":
            return
        # Flexible dust hoses are visual-only and expensive corrugated meshes.
        # They are omitted from the merged controller model at the user's
        # request; rigid spindle/motor geometry remains in the same group.
        if ((node_name.startswith("makine3-par") and node_name.endswith(".005"))
                or ("TOZ EM" in node_name and "BORU" in node_name)):
            return
        # The root transform stays on the output node because QML replaces or
        # animates its translation. Descendants are baked into root-local space.
        transform = parent_transform if index == root_index else parent_transform @ node_matrix(node)
        if "mesh" in node:
            source_models += 1
            for primitive in gltf["meshes"][node["mesh"]]["primitives"]:
                if primitive.get("mode", 4) != 4:
                    continue
                positions = accessor(primitive["attributes"]["POSITION"])
                indices = accessor(primitive["indices"]).reshape(-1).astype(np.uint32)
                p4 = np.column_stack((positions, np.ones(len(positions))))
                positions = (transform @ p4.T).T[:, :3].astype("<f4")
                if "NORMAL" in primitive["attributes"]:
                    normals = accessor(primitive["attributes"]["NORMAL"])
                    normal_matrix = np.linalg.inv(transform[:3, :3]).T
                    normals = (normal_matrix @ normals.T).T
                    lengths = np.linalg.norm(normals, axis=1)
                    normals = (normals / np.maximum(lengths[:, None], 1e-12)).astype("<f4")
                else:
                    normals = np.zeros_like(positions, dtype="<f4")
                groups.setdefault(primitive.get("material", -1), []).append((positions, normals, indices))
        for child in node.get("children", []):
            walk(child, transform)

    walk(root_index, np.eye(4))
    merged_primitives = []
    for material, parts in sorted(groups.items()):
        position_chunks, normal_chunks, index_chunks = [], [], []
        vertex_offset = 0
        for positions, normals, indices in parts:
            position_chunks.append(positions)
            normal_chunks.append(normals)
            index_chunks.append(indices + vertex_offset)
            vertex_offset += len(positions)
        positions = np.concatenate(position_chunks)
        indices = np.concatenate(index_chunks).astype("<u4").reshape(-1, 3)
        positions, indices = simplify(positions, indices)
        normals = vertex_normals(positions, indices)
        primitive = {
            "attributes": {
                "POSITION": add_accessor(positions, "VEC3", 5126, 34962),
                "NORMAL": add_accessor(normals, "VEC3", 5126, 34962),
            },
            "indices": add_accessor(indices.reshape(-1), "SCALAR", 5125, 34963),
        }
        if material >= 0:
            primitive["material"] = material
        merged_primitives.append(primitive)

    mesh_index = len(gltf["meshes"])
    gltf["meshes"].append({"name": name + "_CONTROLLER", "primitives": merged_primitives})
    root["mesh"] = mesh_index
    root.pop("children", None)
    return source_models, len(merged_primitives)


results = {}
for group_name in ("ROTARYMAG", "BASKIRULOSU", "9KW.001",
                   "10LUMAG.014", "Plane.001", "2136", "SIM_BRIDGE",
                   "SIM_CARRIAGE", "SIM_FAM_YELLOW", "SIM_GUARD"):
    results[group_name] = merge_root(group_name)

gltf["buffers"][0]["byteLength"] = len(binary)
encoded = json.dumps(gltf, separators=(",", ":"), ensure_ascii=True).encode()
encoded += b" " * ((-len(encoded)) % 4)
binary += b"\0" * ((-len(binary)) % 4)
length = 12 + 8 + len(encoded) + 8 + len(binary)
output = (struct.pack("<III", 0x46546C67, 2, length)
          + struct.pack("<II", len(encoded), 0x4E4F534A) + encoded
          + struct.pack("<II", len(binary), 0x004E4942) + binary)
target.write_bytes(output)
print(json.dumps(results, ensure_ascii=True))
