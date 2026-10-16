"""Export the original spindle and holder while omitting its bellows assembly.

Only the named bellows assembly (including its lower base plates and brush)
is removed. Retained triangles and normals come directly from the source CAD;
no simplification or change to the spindle origin is performed.
"""
from pathlib import Path
import json
import struct
import sys
import numpy as np

source, output = map(Path, sys.argv[1:3])
blob = source.read_bytes()
json_size = struct.unpack_from("<I", blob, 12)[0]
original = json.loads(blob[20:20 + json_size])
binary = blob[28 + json_size:]
root_index = next(i for i, n in enumerate(original["nodes"]) if n.get("name") == "9KW.001")
removed_name = "2100_FREZE MOT_HSD 2_KÖRÜK_MONTAJLI"
positions, normals, triangles = [], [], []
retained_nodes, removed_nodes = [], []
vertex_count = 0

def accessor(index):
    a = original["accessors"][index]
    v = original["bufferViews"][a["bufferView"]]
    dtype = {5126: "<f4", 5125: "<u4", 5123: "<u2"}[a["componentType"]]
    width = {"VEC3": 3, "SCALAR": 1}[a["type"]]
    if v.get("byteStride", width * np.dtype(dtype).itemsize) != width * np.dtype(dtype).itemsize:
        raise ValueError("Unexpected interleaved source CAD accessor")
    return np.frombuffer(binary, dtype=dtype, offset=v.get("byteOffset", 0)+a.get("byteOffset", 0), count=a["count"]*width).reshape(a["count"], width)

def matrix(node):
    if "matrix" in node:
        return np.asarray(node["matrix"], dtype=np.float64).reshape(4, 4).T
    x, y, z, w = node.get("rotation", [0, 0, 0, 1])
    result = np.eye(4)
    result[:3, :3] = np.array([
        [1-2*y*y-2*z*z, 2*x*y-2*z*w, 2*x*z+2*y*w],
        [2*x*y+2*z*w, 1-2*x*x-2*z*z, 2*y*z-2*x*w],
        [2*x*z-2*y*w, 2*y*z+2*x*w, 1-2*x*x-2*y*y],
    ]) @ np.diag(node.get("scale", [1, 1, 1]))
    result[:3, 3] = node.get("translation", [0, 0, 0])
    return result

def walk(index, parent):
    global vertex_count
    node = original["nodes"][index]
    if node.get("name") == removed_name:
        removed_nodes.append(index)
        return
    transform = parent @ matrix(node)
    if "mesh" in node:
        retained_nodes.append(index)
        for primitive in original["meshes"][node["mesh"]]["primitives"]:
            assert primitive.get("mode", 4) == 4
            p = accessor(primitive["attributes"]["POSITION"])
            n = accessor(primitive["attributes"]["NORMAL"])
            p = (transform @ np.column_stack((p, np.ones(len(p)))).T).T[:, :3]
            n = (np.linalg.inv(transform[:3, :3]).T @ n.T).T
            n /= np.maximum(np.linalg.norm(n, axis=1, keepdims=True), 1e-12)
            ids = accessor(primitive["indices"]).reshape(-1, 3).astype(np.uint32)
            if np.linalg.det(transform[:3, :3]) < 0:
                ids = ids[:, [0, 2, 1]]
            positions.append(p.astype("<f4"))
            normals.append(n.astype("<f4"))
            triangles.append(ids + vertex_count)
            vertex_count += len(p)
    for child in node.get("children", []):
        walk(child, transform)

# Preserve the root translation in QML instead of baking it a second time.
for child in original["nodes"][root_index]["children"]:
    walk(child, np.eye(4))
assert len(removed_nodes) == 1 and retained_nodes
p, n, idx = np.concatenate(positions), np.concatenate(normals), np.concatenate(triangles)
data = bytearray()
views, accessors = [], []
def add(values, kind, component, target):
    while len(data) % 4:
        data.append(0)
    raw = values.tobytes()
    views.append({"buffer": 0, "byteOffset": len(data), "byteLength": len(raw), "target": target})
    data.extend(raw)
    a = {"bufferView": len(views)-1, "componentType": component, "count": len(values), "type": kind}
    if kind == "VEC3":
        a.update(min=values.min(0).astype(float).tolist(), max=values.max(0).astype(float).tolist())
    accessors.append(a)
    return len(accessors)-1

primitive = {"attributes": {"POSITION": add(p,"VEC3",5126,34962), "NORMAL": add(n,"VEC3",5126,34962)}, "indices": add(idx.reshape(-1).astype("<u4"),"SCALAR",5125,34963), "material": 0}
gltf = {"asset": {"version": "2.0"}, "scene": 0, "scenes": [{"nodes": [0]}],
        "nodes": [{"name": "9KW.001", "mesh": 0, "translation": original["nodes"][root_index]["translation"]}],
        "meshes": [{"name": "router_without_bellows", "primitives": [primitive]}],
        "materials": [{"name": "HSD_aluminum", "pbrMetallicRoughness": {"baseColorFactor": [.62,.64,.66,1], "roughnessFactor": .35}, "doubleSided": True}],
        "bufferViews": views, "accessors": accessors, "buffers": [{"byteLength": len(data)}]}
encoded = json.dumps(gltf, separators=(",", ":")).encode()
encoded += b" " * (-len(encoded) % 4)
data += b"\0" * (-len(data) % 4)
output.parent.mkdir(parents=True, exist_ok=True)
output.write_bytes(struct.pack("<III",0x46546c67,2,28+len(encoded)+len(data))+struct.pack("<II",len(encoded),0x4e4f534a)+encoded+struct.pack("<II",len(data),0x004e4942)+data)
report = {"removed_assembly": removed_name, "removed_source_node": removed_nodes[0], "retained_mesh_nodes": retained_nodes,
          "vertices": len(p), "triangles": len(idx), "bounds_min": p.min(0).tolist(), "bounds_max": p.max(0).tolist(), "root_translation": gltf["nodes"][0]["translation"], "source_triangles_not_simplified": True}
output.with_suffix(".json").write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding="utf-8")
print(json.dumps(report, ensure_ascii=False))
