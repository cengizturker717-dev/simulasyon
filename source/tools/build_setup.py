"""Package the reviewed executable and only the runtime CAD assets into Setup."""
from pathlib import Path
import datetime
import hashlib
import json
import re
import shutil
import subprocess
import sys
from runtime_assets import runtime_assets

root = Path(__file__).resolve().parents[2]
workspace = root.parent.parent
compiler = Path(sys.argv[1]).resolve()
if not compiler.is_file():
    raise SystemExit("Inno Setup ISCC.exe is required")
# A freshly compiled reader can be packaged while the developer viewer is
# connected. Never close the user's viewer or CNI just to replace a locked EXE.
reader = Path(sys.argv[2]).resolve() if len(sys.argv) > 2 else None
if reader and not reader.is_file():
    raise SystemExit("Compiled CNI reader is required")
application = Path(sys.argv[3]).resolve() if len(sys.argv) > 3 else None
if application and not application.is_file():
    raise SystemExit("Compiled Vigor application is required")
work = workspace / "work" / "vigor-setup"
stage = work / ("payload-" + datetime.datetime.now().strftime("%Y%m%d-%H%M%S"))
stage.mkdir(parents=True, exist_ok=False)
output = workspace / "outputs" / "VigorSetup"
output.mkdir(parents=True, exist_ok=True)

# Keep the existing Qt deployment intact. Test executables and development
# tooling are not needed on the controller. External model import stays usable.
for path in sorted((root / "app").rglob("*")):
    if not path.is_file():
        continue
    relative = path.relative_to(root)
    if "qmltooling" in relative.parts or path.name in {"SolidSimNative-test.exe", "SharedAx.dll", "SharedAxCs.dll"}:
        continue
    if path.suffix.lower() in {".pdb", ".log"}:
        continue
    destination = stage / relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(path, destination)

if reader:
    shutil.copy2(reader, stage / "app/CniTelemetry.exe")
if application:
    shutil.copy2(application, stage / "app/SolidSimNative.exe")

scene = root / "assets/catalog/VigorLite.qml"
for path in runtime_assets(scene, root):
    if not path.is_relative_to(root) or not path.is_file():
        raise RuntimeError(f"Missing/outside model dependency: {path}")
    destination = stage / path.relative_to(root)
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(path, destination)

# Each installed controller gets its own data choice. Never transfer developer
# machine paths, render benchmarks, or rewrite a user's settings during updates.
(stage / "vigor-settings.ini").write_text("[machine]\nmodel=2136\n", encoding="utf-8")
(stage / "Kurulum-Bilgisi.txt").write_text(
    "POYRAZ Vigor\n\n"
    "İlk açılışta üst menüden makinenizi seçin:\n"
    "Vigor 2142: 4200 × 2100 mm\n"
    "Vigor 2136: 3660 × 2100 mm\n"
    "Vigor 2128: 2800 × 2100 mm\n\n"
    "Makine datası / takımlar bölümünden kendi makinenizin Dati ve User "
    "klasörlerini içeren data klasörünü seçin.\n"
    "CNI canlı izleme için NcOne/CNI bilgisayarda kurulu ve açık olmalıdır. "
    "Kurulum CNI'yi veya makine datasını kurmaz ve değiştirmez.\n\n"
    "Canlı okuyucu kurulu CNI kütüphanelerini kullanır. NcRc.ini içindeki "
    "IpNc adresi tanımlıysa gerçek kontrolcüye ağ üzerinden salt okunur "
    "izleme bağlantısı kurar; adres boşsa yerel simülatör verisini okur. "
    "CNI ayarlarını, makine datasını ve PLC'yi değiştirmez. "
    "Bağlantı başarısız olursa CNI bağlantısı "
    "ekranında hata ayrıntısı gösterilir.\n\n"
    "Program tam ekranda açılır. Masaüstü veya Başlat menüsündeki POYRAZ Vigor "
    "kısayoluyla başlatabilirsiniz. 3D model her bilgisayarda ekranın doğal "
    "çözünürlüğünde çizilir; otomatik çözünürlük azaltma uygulanmaz. "
    "Güncellemelerde makine seçiminiz ve data "
    "klasörünüz korunur.\n"
    "Kaldırmak için Windows uygulamalar listesinden POYRAZ Vigor'u seçin. "
    "Makine ayarlarınız kaldırma işleminden sonra da korunur.\n",
    encoding="utf-8-sig",
)
manifest = {}
for path in sorted(stage.rglob("*")):
    if path.is_file():
        manifest[path.relative_to(stage).as_posix()] = {
            "bytes": path.stat().st_size,
            "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
        }
(work / "payload-manifest.json").write_text(json.dumps({
    "stage": str(stage), "files": manifest,
}, ensure_ascii=False, indent=2), encoding="utf-8")
print(f"Runtime: {len(manifest)} files, {sum(f['bytes'] for f in manifest.values()) / 1024**2:.1f} MiB", flush=True)
result = subprocess.run([
    str(compiler), f"/DPayload={stage}", f"/DOutputDirectory={output}",
    str(Path(__file__).with_name("vigor_setup.iss")),
], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
(work / "compiler.log").write_bytes(result.stdout)
if result.returncode:
    print(result.stdout.decode("utf-8", errors="replace")[-8000:])
    raise SystemExit(result.returncode)
setup_spec = Path(__file__).with_name("vigor_setup.iss").read_text(encoding="utf-8")
installer_name = re.search(r"^OutputBaseFilename=(.+)$", setup_spec, re.MULTILINE).group(1).strip()
installer = output / (installer_name + ".exe")
print(f"Setup: {installer} ({installer.stat().st_size / 1024**2:.1f} MiB)")
