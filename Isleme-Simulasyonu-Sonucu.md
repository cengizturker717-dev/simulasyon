# İşleme simülasyonu — 10 Ekim 2026

Start konum düzeltmesi: canlı CAD artık program başlangıcında makine koordinatından
parça koordinatına geçmez. Makine çerçevesi açılışta kayıtlı ORIG_SX, T1 ve TP1
kurulumundan oluşturulur. Değişmeyen fiziksel eksenlerle bağlanma, Start, Stop,
parça sıfırı değişimi ve bağlantı kaybı konumu değiştirmez; Sıfırla artık Y=0'dır.
Plaka sıfırı her ölçüde giriş tablasının aynı köşesidir (X=-1.017, Z=-1.2046434 m).
12 sahne kontrolü geçti. 2800 × 2100 ve 3660 × 1830 mm programlarda aynı köşe
korundu. Gerçek Delikli_S01 kaydındaki 460 kesim örneğinde FAM/freze ucu ile
malzeme noktası arasındaki en büyük hata XY'de 0.000072 mm, Z'de 0.000308 mm oldu
(sayısal model karşılaştırmasıdır; fiziksel makine ölçüm hassasiyeti değildir).

Start durumunda çalışan PCNI dosyasından LX / LY / LZ okunur ve plaka CAD tablasına yerleştirilir.
CNI iş sıfırı, CAD tablasının plaka köşesine eşlenir. Canlı X / Y / Z verisi program yolu ile
uyuştuğunda ölçülen derinlikte malzeme kaldırılır. Uyuşmayan veya belirsiz çevrimlerde
malzeme hesabı bekler. Veri kesilirse hesap durur; bu uygulama CNC/PLC'ye komut göndermez.

Çevrimdışı program oynatmada PRF, mutlak Z, artımlı ZI, PON/PUP, G0/G1 ve dikey G99
uygulanır. Freze rampaları, kör/tam delikler ve çoklu matkap ofsetleri hesaplanır.
Takım değiştirmek veya derinlik değiştirmek daha önce işlenen malzemeyi sıfırlamaz.

Takım kütüphanesinde tanımsız ad varsa programın işleme simülasyonu başlamaz. Start sonrası
ekranda takım adı ve satırıyla açık hata gösterilir. Programdaki DIAMETER açıklaması,
kütüphanede bulunmayan takımı tanımlanmış saymaz. Kontrolde 6MMZ3, HAVSA ve 6MMNP
adlarının eksik olduğu görüldü. Bu takımlar CNI kütüphanesine eklenmedi.

Doğrulama:
- Dağıtılan uygulamada 40 işlem kontrolü geçti: plaka ölçüsü, negatif PRF, Z/ZI rampası,
  havada ve G0 geçişinde kesmeme, 3/5 mm kör delikler, çoklu matkap, tam geçiş,
  Start/Stop, bağlantı kaybı, tanımsız takım/matkap, program yolu doğrulaması,
  takım düzeltmesi ve alt tabla payı okunamadığında malzeme hesabının durması.
- Önceki malzeme hesabıyla 1.085 geometri karşılaştırması aynı sonucu verdi.
- Gerçek Test366_S01.pcni ve ayrı freze/matkap kontrol programı görüntülendi;
  hesaplanan freze/FAM uç noktası ile plaka işleme noktası hizalı bulundu.
- CAD mesh referansları, model sayısı ve malzeme ayarları önceki sürümle aynı kaldı.
- Kendi kontrol bilgisayarınızda Kontrol-Testi.cmd artık bu işlem kontrollerini de çalıştırır.

Malzeme görünümü 2 mm hücreli 2,5 boyutlu bir önizlemedir; görünür CAD geometrisi ve ekran
çözünürlüğü değiştirilmedi. G2/G3, yatay/açılı delik, özel makrolar, yarıçap telafisi,
çarpışma ve kesme fiziği desteklenmez. Desteklenmeyen komutlar hata verir.

Kullanıcının NcOne simülatöründe verdiği gerçek Start algılandı. Test366_S01.pcni için
3660 × 1830 × 18 mm plaka yüklendi. İlk canlı denemede yalnızca orijin çıkarmanın
yetersiz kaldığı bulundu: takım/mandren düzeltmeleri SharedAx CorrTotale üzerinden,
PRIMO makrosunun ZO=-CSag alt tabla payı da GENERAL/CSag üzerinden canlı okunacak şekilde düzeltildi.
Bu değer okunamadığında kesim hesabı bekler; sabit bir ofset tahmin edilmez.
CSag değerinin 99 mm ve 18 mm olduğu canlı kayıtlarda aynı 18 mm kesim derinliği doğrulandı.
Düzeltilmiş uygulamanın canlı görüntü kontrolünde N153, 8MM-MDF, 18,00 mm derinlik,
145,876 cm³ kaldırılmış malzeme, güncel CNI verisi ve doğru CAD takım hizası görüldü.
Görüntüleyici çevrim devam ederken yeniden bağlandığından bu hacim tüm çevrimin sonucu değildir.
Test366 programı freze içerir. Kullanıcının başlattığı Delikli_S01.pcni programında
2800 × 2100 × 18 mm plaka ve FAM çevrimleri canlı olarak gözlendi. Program toplam
255 delik içerir (Ø8 / 18 mm, Ø15 / 15 mm ve üçlü Ø5 / 13 mm çevrimleri).
100 ms okuma aralığının bazı kısa delme hareketlerinde dip noktasını kaçırdığı bulundu.
Canlı hedef koordinatı da okunur: doğru G99 hedefi gözlenmiş, takım dibe yaklaşmış ve
aynı konumda yukarı hareket başlamışsa önizleme programdaki delik derinliğine tamamlanır.
Bu tamamlanan derinlik bir fiziksel ölçüm değildir. Stop, veri kaybı, konum atlaması ve
dipten uzakta erken geri çekilme delik tamamlamaz; bu durumlar işlem kontrollerine eklendi.
Düzeltilmiş hesapla 4.440 gerçek kayıt satırı tekrar işlendi. Kayıt bölümündeki 87 delik
program derinliğine ulaştı, kısmi derinlikte delik kalmadı. Hedef kaydı çevrimin ortasında
başladığından bu sonuç 255 deliğin tamamının canlı doğrulaması değildir.
Kontrol ünitesindeki akıcılık ve
kesintisiz tam çevrim ayrıca doğrulanmalıdır. Gizli görüntü kontrolündeki FPS=0 değeri
performans ölçümü olarak kullanılmaz.
