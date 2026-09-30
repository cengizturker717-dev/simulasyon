# SolidSim Native — Vigor 2136

Windows masaüstü simülasyonu. C++ ve Qt Quick 3D ile çalışır; tarayıcı gerekmez.

## Çalıştırma

`Baslat.cmd` dosyasını çalıştırın. `app` ve `assets` klasörlerini birlikte tutun.

## NcOne / CNI canlı eksen bağlantısı

Önce NcOne veya SimPoyraz'ı açın. SolidSim Native içinde `CNI simülatörüne bağlan` düğmesine basıp `CNI verisini oku` seçin. Pencereyi kapatsanız da bağlantı devam eder; bağlantıyı durdurmak için aynı penceredeki `Bağlantıyı kes` düğmesini kullanın.

Uygulama `SharedAx` üzerinden ilk üç kartezyen eksenin gerçek konumunu 100 ms aralıkla **salt okunur** alır. CNC, PLC veya eksenlere komut göndermez. Canlı mod açıkken elle eksen, demo ve sıfırlama kontrolleri kilitlenir. Test: NcOne çalışırken `app/SolidSimNative.exe --cni-probe` sıfır koduyla bitmelidir.

Görüntü eşlemesi, mevcut Vigor makine datasındaki limitleri (X -34…5235, Y -240…2310, Z -295…46) modelin görsel hareket aralığına ölçekler. Ham değerlerin doğru okunduğu simülatörle doğrulandı. Fiziksel makinede yön, sıfır noktası ve strok eşlemesi kuru çalıştırmada ayrıca doğrulanmalıdır.

## PCNI ve etiket önizlemesi

`PCNI programları / etiketler` düğmesiyle makine datasındaki `User/Prog/*.pcni` dosyalarını seçin. `Programı oku` plaka üzerindeki X/Y yolunu ve etiket konumlarını gösterir. Etiketler `User/Import/<program>_<numara>.bmp` (veya png/jpg) adından eşleştirilir. Başka bilgisayarda `Klasör seç` ile `User` klasörünün üstündeki makine data klasörünü seçin; üretim dosyaları bu repoya kopyalanmaz.

`Plakayı makine tablasına yükle` plaka boyutlarını LX/LY/LZ'den yükler ve plakayı mevcut Vigor tablasına yerleştirir. Takım çapı DIAMETER açıklamasından alınır (bulunmazsa 8 mm); çapı ve kesim derinliğini panelden kontrol edip `Hareketi başlat` seçin. Başlangıç derinliği plaka kalınlığıdır. Derinliği azaltarak kısmi kanallar açabilirsiniz. Ayar değiştirme veya sıfırlama malzemeyi yeniler; duraklatıp devam etmek kaldırılan malzemeyi korur.

Makine tablasındaki malzeme, 2 mm hücrelerle düz frezenin süpürdüğü hacmi kaldıran 2.5D bir modeldir. Tam kesim boşlukları, kanal tabanları, yan duvarlar ve yaklaşık kaldırılan hacim gösterilir. PON ile başlayan yeni kontura geçişlerde kesim yapılmaz. Takım çapı ve derinlik bu sürümde program boyunca sabittir; negatif PRF, ZI rampaları, otomatik takım değişimi, telafi ve gerçek işlem süreleri yorumlanmaz. Derinlik **makineden doğrulanmış bir değer değildir**, kullanıcı ayarıdır. Plaka, kesim izi ve freze ucu aynı model koordinatlarına bağlıdır. Freze yüksekliği, seçilen sabit derinliğe ve kesim/geçiş durumuna göre değişir. Bu geometrik hizalama CAD üzerindedir; gerçek makine sıfır kalibrasyonu değildir. Çarpışma kontrolü veya fiziksel makine komutu içermez.

Malzeme testleri: `app/SolidSimNative.exe --stock-test` (boş geçiş, kısmi kanal, tam kesim, aynı yerden tekrar geçiş ve sıfırlama).

Test: `app/SolidSimNative.exe --pcni-test` mevcut klasördeki programları denetler; `--machine-data <klasör>` ile farklı makine datası verilebilir. Ayrıştırıcı hata testleri `source/tools/test_pcni.ps1` içindedir.

## İçerik

- Vigor 2136 katalog renkleriyle sadeleştirilmiş 3D model
- X/Y/Z eksen simülasyonu ve kamera kontrolü
- Asansör, yükleme konveyörü, tel çit ve havada kalan çevre parçaları sade görünümden çıkarılmıştır
- Tam model ve orijinal GLB `assets` klasöründe korunur
- Ayrıntılı kullanım ve yeniden üretim bilgisi için [OKU.md](OKU.md)

## GitHub Desktop

Bu klasör Git deposu olarak hazırlanmıştır. Büyük GLB, MESH, DLL, EXE ve PNG dosyaları Git LFS ile izlenir.


## Küçük taşınabilir paket

`python source/tools/package_portable.py <çıktı.zip>` yalnızca uygulama ve VigorLite sahnesinin kullandığı varlıkları paketler. Orijinal GLB, alternatif sahneler, kaynaklar ve Git geçmişi taşınabilir pakete girmez. Kaynak projesindeki orijinaller korunur. ZIP dosyasını çıkarıp `simulasyon/Baslat.cmd` çalıştırın.

## Kontrol bilgisayarı için görünüm

Köprü logosu köprüyle hareket eder; ön koruma kapağı kapalıdır. Kamera sınırı 1200–10000 sahne birimidir. Kanalların koyu iç yüzeyleri hesaplanan kesim çapını veya kaldırılan hacmi değiştirmez. Parçacık efekti yoktur. Hareket 33 ms, değişen malzeme en sık 200 ms aralıkla güncellenir. Pencere küçültülünce simülasyon duraklar. Kontrol bilgisayarındaki performans ayrıca ölçülmelidir.
