# SolidSim Native — Vigor 2136, sade görünüm

Baslat.cmd dosyasını açın. C++ / Qt Quick 3D masaüstü uygulamasıdır; tarayıcı gerekmez.

## Bu sürüm

Varsayılan sahne assets/catalog/VigorLite.qml dosyasıdır. Asansör, yükleme sistemi, çıkış konveyörü, tel çit ve ayrı çevre ekipmanları bu sahnede oluşturulmaz; gizlenmiş nesneler olarak bellekte tutulmazlar. Çizilen Model nesnesi sayısı 2575 yerine 598'dir. Ana gövde, tabla, köprü, kafa ve makine üzerindeki ekipmanlar korunur. Asansör sürgüsü kaldırılmıştır.

Orijinal vigor-2136.glb ve tam VigorCatalog.qml korunmuştur. meshes klasöründeki ortak dosyaları silmeyin. Tam sahne gerekirse --model ile VigorCatalog.qml mutlak yolu verilerek açılabilir.

## Kullanım

- Hareketi başlat/duraklat: X/Y/Z simülasyonu.
- X/Y/Z sürgüleri: ilgili parçayı hareket ettirir, otomatik demoyu durdurur.
- Sıfırla: başlangıç pozuna döner.
- Fareyle sürükleme: döndürme; tekerlek: yakınlaştırma; Ctrl+sürükleme: kaydırma.
- İzometrik, Üst, Ön: kamera görünümleri. Sade görünümün başlangıç kamera mesafesi 6000'dir.

Katalogdaki Vigor 2136 çalışma aralıkları X=3660, Y=2100, Z=120 mm'dir. Renkler orijinal GLB paletinden aktarılmıştır; baskıdan ölçülmüş RAL değerleri değildir. Birleşik CAD ağları bağlı yüzey bileşenleri ve konumlarına göre hareket gruplarına ayrılmıştır; eşleme görsel simülasyondur. Gerçek makine bağlantısı, NC yürütme, çarpışma hesabı ve talaş kaldırma yoktur.

## Doğrulama ve performans

Release derlendi. Gerçek sahne düğümlerinde köprü X=3 m, kafa Y=0.65 m ve Z=0.05 m ofset kontrolü geçti. Son hareket testi motion-test.txt dosyasındadır.

Aynı uygulama, kamera konumu (6000), görünüm boyutu ve otomatik hareket ile ayrı ayrı 10 saniyelik ölçüm:

| Sahne | Ortalama FPS | Medyan kare süresi | %95 kare süresi |
|---|---:|---:|---:|
| Tam model | 26.04 | 39.00 ms | 48.28 ms |
| Sade model | 62.51 | 15.95 ms | 19.36 ms |

Bu bilgisayardaki kısa karşılaştırmada yaklaşık 2.4 kat artış sağlandı. Yakınlaştırma, ekran boyutu ve bilgisayar yükü sonucu değiştirebilir. Duran sahnede düşük FPS normaldir; yalnızca değişiklikte çizilir. benchmark-full.txt ve benchmark-lite.txt ölçüm kayıtlarıdır. --benchmark rapor.txt ile tekrar ölçülebilir.

## Geliştirme

Qt 6.8.3, MSVC x64 ve CMake kullanılır. source/tools/simplify_vigor.py tam QML sahnesinden sade sahneyi yeniden oluşturur; proje çalışma kökünden çalıştırılır. source/tools/prepare_vigor.py ve bind_vigor.py tam model hazırlama araçlarıdır. app ve assets klasörlerini birlikte taşıyın. Qt/Assimp ve Microsoft çalışma zamanı lisansları geçerlidir.

Kullanıcının işaret ettiği arka beyaz magazin kutusu (ZINCIRMAG) ve ayrı kapak/bağlantı parçaları sade sahneden çıkarılmıştır. Tam model korunur. Yukarıdaki performans karşılaştırması kutu kaldırılmadan önceki 601 nesneli sade sürüm ölçümüdür.
`nAna gövde ağına birleşmiş iki havada kalan ince parça sade modelin cleanedstatic ağı üzerinden çıkarıldı (260 üçgen). Orijinal tam model ağı korunur. Yeniden üretim: clean_bracket.py, ardından balsam ile work/CleanStatic.glb dosyasını assets/catalog/cleanedstatic klasörüne dönüştürme ve simplify_vigor.py.
