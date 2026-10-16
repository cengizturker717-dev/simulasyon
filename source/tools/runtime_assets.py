"""Resolve only the deployed scene and its three supported chassis variants."""
from pathlib import Path
import re

def runtime_assets(scene: Path, project_root: Path):
    text=scene.read_text(encoding="utf-8")
    files={scene}
    for reference in re.findall(r'\bsource:\s*"([^"\n]+)"',text):
        if reference.startswith('#') or reference in {'variants/','merged/static_'}:
            continue
        files.add((scene.parent/reference).resolve())
    if 'merged/static_' in text:
        suffix='_nomag' if '"_nomag.mesh"' in text else ''
        files.update(scene.parent/'merged'/f'static_{profile}{suffix}.mesh' for profile in ('2142','2136','2128'))
    else:
        files.add(scene.parent/'cleanedstatic/meshes/l_o_altma1_009_mesh.mesh')
        files.update(scene.parent/'variants'/profile/'static.mesh' for profile in ('2136','2128'))
    for file in files:
        if not file.resolve().is_relative_to(project_root.resolve()) or not file.is_file():
            raise RuntimeError(f'Missing or external runtime asset: {file}')
    return sorted(files)
