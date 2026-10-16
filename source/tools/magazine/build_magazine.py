"""Split the two CAD magazines into a fixed body plus one pocket-fork template,
so the scene can draw exactly the pockets that Dati defines.
  python build_magazine.py <catalog dir> <MeshIO.exe>
Writes meshes/{fixedmag_body,fixedmag_fork,rotarymag_body,rotarymag_fork}.mesh and
prints the placement constants used by VigorLite.qml."""
import math
import subprocess
import sys
from pathlib import Path
import numpy as np
sys.path.insert(0, str(Path(__file__).parent))
import tri
from dilate import vertex_keys
from scipy.sparse import coo_matrix
from scipy.sparse.csgraph import connected_components

cat, meshio = Path(sys.argv[1]), sys.argv[2]
work = Path(__file__).parent.parent / 'tmp'


def comps(a):
    k = vertex_keys(a); n = len(a)
    g = coo_matrix((np.ones(n * 3), (np.repeat(np.arange(n), 3), k.ravel())), shape=(n, k.max() + 1)).tocsr()
    return connected_components(g @ g.T, directed=False)[1]


def box(a):
    p = a[:, :, :3].reshape(-1, 3)
    return p.min(0), p.max(0)


def save(name, subsets):
    t = work / f'{name}.tri'
    tri.save(t, subsets)
    subprocess.run([meshio, 'pack', str(t), str(cat / 'meshes' / f'{name}.mesh')], check=True, capture_output=True)


def dump(name):
    t = work / f'src_{name}.tri'
    subprocess.run([meshio, 'dump', str(cat / 'meshes' / f'{name}.mesh'), str(t)], check=True, capture_output=True)
    return tri.load(t)


def tkey(t, shift):
    return tuple(sorted(tuple(round(float(v[i] + shift[i]), 4) for i in range(3)) for v in t))


def keep_current(subsets, scene_tri, shift):
    """Drop magazine triangles the user had removed from the scene (e.g. the bent rod):
    keep only triangles that still exist in the edited, uncut scene mesh."""
    scene = set(tkey(t, (0, 0, 0)) for _, a in tri.load(scene_tri) for t in a[:, :, :3])
    out = []
    for name, a in subsets:
        keep = np.array([tkey(t, shift) in scene for t in a[:, :, :3]], bool)
        print(f'  {name}: kept {int(keep.sum())}/{len(a)}')
        out.append((name, a[keep]))
    return out


# ---- fixed magazine (CAD placed at .391593, .491951, 0): rail body + 10 forks (white), 10 holders (black)
FIXED_AT = np.array([.391593, .491951, 0])
here = Path(__file__).parent.parent
print('fixed magazine vs edited chassis:')
fixed_cad = keep_current(dump('node10LUMAG_014_mesh'), here / 'tri' / 'static_2142_open.tri', FIXED_AT)
save('fixedmag_cad', fixed_cad)
(wn, white), (bn, black) = fixed_cad
lab = comps(white); sizes = np.bincount(lab)
forks = [c for c in range(len(sizes)) if 350 < sizes[c] < 500]
assert len(forks) == 10, sizes
fork_boxes = sorted((box(white[lab == c]) for c in forks), key=lambda b: b[0][2])
fork_centres = [(lo + hi) / 2 for lo, hi in fork_boxes]
blab = comps(black)
holder_centres = sorted(((lambda lo, hi: (lo + hi) / 2)(*box(black[blab == c])) for c in range(blab.max() + 1)), key=lambda c: c[2])
first_fork = forks[int(np.argmin([box(white[lab == c])[0][2] for c in forks]))]
template = white[lab == first_fork].copy()
fc = fork_centres[0]
template[:, :, 0] -= fc[0]; template[:, :, 2] -= fc[2]
save('fixedmag_body', [(wn, white[~np.isin(lab, forks)])])
save('fixedmag_fork', [(wn, template)])
print('fixed: first fork centre world x=%.6f z=%.6f, pitch(CAD)=%.4f' % (fc[0] + FIXED_AT[0], fc[2], np.mean(np.diff([c[2] for c in fork_centres]))))
off = np.mean([h - f for h, f in zip(holder_centres, fork_centres)], 0)
hb = min(box(black[blab == c])[0][1] for c in range(blab.max() + 1)) + FIXED_AT[1]
print('fixed: holder offset from fork dx=%.5f dz=%.5f, holder base world y=%.6f' % (off[0], off[2], hb))

# ---- rotary magazine (CAD placed at axisX, .704551, 0): disc/hub (dark) + 12 forks (dark) + frame (grey)
print('rotary magazine vs edited bridge:')
rotary_cad = keep_current(dump('rotarymag_mesh'), here / 'tri' / 'bridge_open.tri', (0, .704551, 0))
save('rotarymag_cad', rotary_cad)
(dn, dark), (gn, grey) = rotary_cad
lab = comps(dark); sizes = np.bincount(lab)
disc = int(np.argmax(np.where(sizes < 2700, sizes, 0)))
lo, hi = box(dark[lab == disc]); centre = (lo + hi) / 2
fork_ids = []
for c in range(len(sizes)):
    clo, chi = box(dark[lab == c]); m = (clo + chi) / 2
    r = math.hypot(m[0] - centre[0], m[2] - centre[2])
    if c != disc and r > 0.12:
        fork_ids.append(c)
# A clean single fork: the 412-triangle style, with a mid-range angle.
singles = [c for c in fork_ids if 350 < sizes[c] < 500]
pick = singles[0]
plo, phi = box(dark[lab == pick]); pm = (plo + phi) / 2
phi0 = math.degrees(math.atan2(pm[0] - centre[0], pm[2] - centre[2]))
fork = dark[lab == pick].copy()
fork[:, :, 0] -= centre[0]; fork[:, :, 2] -= centre[2]
# Radial extent of the fork along its own axis gives the pocket (opening) radius.
d = np.array([math.sin(math.radians(phi0)), math.cos(math.radians(phi0))])
radial = fork[:, :, 0] * d[0] + fork[:, :, 2] * d[1]
save('rotarymag_body', [(dn, dark[~np.isin(lab, fork_ids)]), (gn, grey)])
save('rotarymag_fork', [(dn, fork)])
print('rotary: centre local x=%.5f y=%.5f z=%.5f, template angle=%.2f, fork radial %.4f..%.4f, fork top y=%.4f, forks found %d'
      % (centre[0], centre[1], centre[2], phi0, radial.min(), radial.max(), fork[:, :, 1].max(), len(fork_ids)))
