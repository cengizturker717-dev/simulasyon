"""Read/write MeshIO .tri files as numpy arrays: list of (name, float32[n,3,6])."""
import numpy as np
import struct


def load(path):
    data = open(path, 'rb').read()
    at = 0
    def u32():
        nonlocal at
        v = struct.unpack_from('<I', data, at)[0]; at += 4; return v
    out = []
    for _ in range(u32()):
        n = u32(); name = data[at:at + n].decode('utf-8'); at += n
        t = u32()
        arr = np.frombuffer(data, '<f4', t * 18, at).reshape(t, 3, 6).copy(); at += t * 72
        out.append((name, arr))
    assert at == len(data)
    return out


def save(path, subsets):
    with open(path, 'wb') as f:
        f.write(struct.pack('<I', len(subsets)))
        for name, arr in subsets:
            b = name.encode('utf-8')
            f.write(struct.pack('<I', len(b))); f.write(b)
            f.write(struct.pack('<I', len(arr))); f.write(np.ascontiguousarray(arr, '<f4').tobytes())
