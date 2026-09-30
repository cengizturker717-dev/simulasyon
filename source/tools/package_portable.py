"""Build a small portable package using only the scene's referenced assets."""
from pathlib import Path
import re
import sys
import zipfile

root = Path(__file__).resolve().parents[2]
output = Path(sys.argv[1]).resolve()
scene = root / 'assets/catalog/VigorLite.qml'
files = [p for p in (root / 'app').rglob('*') if p.is_file()]
files += [scene, root / 'Baslat.cmd', root / 'README.md']
for reference in re.findall(r'\bsource:\s*"([^"]+)"', scene.read_text(encoding='utf8')):
    if reference.startswith('#'):
        continue
    path = (scene.parent / reference).resolve()
    if not path.is_relative_to(root) or not path.is_file():
        raise ValueError(f'Missing or external scene asset: {reference}')
    files.append(path)
files = sorted(set(files))
with zipfile.ZipFile(output, 'w', zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
    for path in files:
        archive.write(path, 'simulasyon/' + path.relative_to(root).as_posix())
with zipfile.ZipFile(output, 'r') as archive:
    if archive.testzip():
        raise RuntimeError('ZIP verification failed')
print(f'{len(files)} files; uncompressed {sum(p.stat().st_size for p in files)/1024**2:.1f} MiB; ZIP {output.stat().st_size/1024**2:.1f} MiB')
