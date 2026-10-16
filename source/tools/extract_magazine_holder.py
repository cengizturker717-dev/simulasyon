"""Extract one fixed-magazine holder as a reusable instanced mesh."""
from collections import defaultdict
from pathlib import Path
import os
import struct
import subprocess
import sys
import tempfile


helper, source, output = map(Path, sys.argv[1:4])
with tempfile.TemporaryDirectory() as directory:
    dumped = Path(directory) / "fixed-magazine.tri"
    packed = Path(directory) / "holder.tri"
    subprocess.run([str(helper), "dump", str(source), str(dumped)], check=True)
    data = dumped.read_bytes()
    offset = 0

    def u32():
        nonlocal_offset = struct.unpack_from("<I", data, u32.offset)[0]
        u32.offset += 4
        return nonlocal_offset
    u32.offset = 0

    subsets = []
    for _ in range(u32()):
        name_size = u32()
        name = data[u32.offset:u32.offset + name_size].decode("utf-8")
        u32.offset += name_size
        triangles = []
        for _ in range(u32()):
            triangle = []
            for _ in range(3):
                triangle.append(struct.unpack_from("<6f", data, u32.offset))
                u32.offset += 24
            triangles.append(triangle)
        subsets.append((name, triangles))

    name, triangles = subsets[1]
    vertex_triangles = defaultdict(list)
    for index, triangle in enumerate(triangles):
        for vertex in triangle:
            vertex_triangles[vertex[:3]].append(index)
    unseen = set(range(len(triangles)))
    components = []
    while unseen:
        stack, component = [unseen.pop()], []
        while stack:
            index = stack.pop()
            component.append(index)
            for vertex in triangles[index]:
                for neighbour in vertex_triangles[vertex[:3]]:
                    if neighbour in unseen:
                        unseen.remove(neighbour)
                        stack.append(neighbour)
        components.append(component)
    selected = min(components, key=lambda ids: min(triangles[index][corner][2] for index in ids for corner in range(3)))
    points = [triangles[index][corner] for index in selected for corner in range(3)]
    center_x = (min(v[0] for v in points) + max(v[0] for v in points)) / 2
    base_y = min(v[1] for v in points)
    center_z = (min(v[2] for v in points) + max(v[2] for v in points)) / 2
    encoded = bytearray(struct.pack("<I", 1))
    subset_name = b"magazine_holder"
    encoded += struct.pack("<I", len(subset_name)) + subset_name + struct.pack("<I", len(selected))
    for index in selected:
        for vertex in triangles[index]:
            encoded += struct.pack("<6f", vertex[0] - center_x, vertex[1] - base_y, vertex[2] - center_z, *vertex[3:])
    packed.write_bytes(encoded)
    output.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run([str(helper), "pack", str(packed), str(output)], check=True, env=os.environ.copy())
    print(f"holder_triangles={len(selected)} output={output}")
