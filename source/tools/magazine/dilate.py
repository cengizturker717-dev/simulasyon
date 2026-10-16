"""Grow a per-triangle mask by whole rings of triangles sharing a vertex position."""
import numpy as np


def flat(subsets):
    return np.concatenate([a for _, a in subsets])


def vertex_keys(tris):
    q = np.round(tris[:, :, :3].reshape(-1, 3) / 2e-5).astype(np.int64)
    _, inv = np.unique(q, axis=0, return_inverse=True)
    return inv.reshape(-1, 3)


def dilate(mask, keys, rings):
    mask = mask.astype(bool).copy()
    nv = keys.max() + 1
    for _ in range(rings):
        touched = np.zeros(nv, bool)
        touched[keys[mask].ravel()] = True
        mask |= touched[keys].any(1)
    return mask


def area(tris):
    p = tris[:, :, :3]
    return 0.5 * np.linalg.norm(np.cross(p[:, 1] - p[:, 0], p[:, 2] - p[:, 0]), axis=1)
