"""Remove one transformed source mesh from a packed scene without rebuilding it.

This preserves every optimization and manual deletion already present in the
scene. Only triangles that exactly match the transformed source are removed.
"""
from collections import Counter
from pathlib import Path
import os
import struct
import subprocess
import sys
import tempfile


mesh_io, scene_mesh, removable_mesh, output_mesh, tx, ty, tz = sys.argv[1:8]
mesh_io, scene_mesh, removable_mesh, output_mesh = map(Path, (mesh_io, scene_mesh, removable_mesh, output_mesh))
shift = tuple(map(float, (tx, ty, tz)))


def read_tri(path):
    data = Path(path).read_bytes()
    offset = 0

    def u32():
        nonlocal offset
        value = struct.unpack_from("<I", data, offset)[0]
        offset += 4
        return value

    subsets = []
    for _ in range(u32()):
        size = u32()
        name = data[offset:offset + size].decode("utf-8")
        offset += size
        triangles = []
        for _ in range(u32()):
            triangle = []
            for _ in range(3):
                triangle.append(struct.unpack_from("<6f", data, offset))
                offset += 24
            triangles.append(triangle)
        subsets.append((name, triangles))
    return subsets


def write_tri(path, subsets):
    encoded = bytearray(struct.pack("<I", len(subsets)))
    for name, triangles in subsets:
        name_bytes = name.encode("utf-8")
        encoded += struct.pack("<I", len(name_bytes)) + name_bytes
        encoded += struct.pack("<I", len(triangles))
        for triangle in triangles:
            for vertex in triangle:
                encoded += struct.pack("<6f", *vertex)
    Path(path).write_bytes(encoded)


def key(triangle, translation=(0.0, 0.0, 0.0)):
    return tuple(sorted(tuple(round(value + (translation[index] if index < 3 else 0.0), 4)
                              for index, value in enumerate(vertex)) for vertex in triangle))


with tempfile.TemporaryDirectory() as directory:
    directory = Path(directory)
    scene_tri, removable_tri, stripped_tri = directory / "scene.tri", directory / "remove.tri", directory / "stripped.tri"
    subprocess.run([str(mesh_io), "dump", str(scene_mesh), str(scene_tri)], check=True)
    subprocess.run([str(mesh_io), "dump", str(removable_mesh), str(removable_tri)], check=True)
    removable = Counter(key(triangle, shift) for _, triangles in read_tri(removable_tri) for triangle in triangles)
    total_target = sum(removable.values())
    removed = 0
    result = []
    for name, triangles in read_tri(scene_tri):
        kept = []
        for triangle in triangles:
            triangle_key = key(triangle)
            if removable[triangle_key] > 0:
                removable[triangle_key] -= 1
                removed += 1
            else:
                kept.append(triangle)
        result.append((name, kept))
    if total_target == 0 or removed / total_target < 0.70:
        raise RuntimeError(f"unsafe match ratio: {removed}/{total_target}")
    # MeshIO deliberately rejects empty subsets. Removing a magazine can empty
    # a material group completely, so omit that group and update the QML
    # material list for the stripped model accordingly.
    result = [(name, triangles) for name, triangles in result if triangles]
    write_tri(stripped_tri, result)
    output_mesh.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run([str(mesh_io), "pack", str(stripped_tri), str(output_mesh)], check=True, env=os.environ.copy())
    print(f"removed={removed}/{total_target} preserved={sum(len(t) for _, t in result)} output={output_mesh}")
