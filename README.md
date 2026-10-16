# SolidSim Native — Vigor 2142 / 2136 / 2128

Windows masaüstü simülasyonu. C++ ve Qt Quick 3D ile çalışır; tarayıcı gerekmez.

## Vigor ölçüsü seçimi

Üstteki Vigor menüsünden 2142 (4200 × 2100), 2136 (3660 × 2100) veya
2128 (2800 × 2100 mm) seçilir. Seçim `vigor-settings.ini` dosyasında korunur.
Şase ve tabla uzunluğu değişir; kafa, köprü, pano ve sabit plaka köşesi korunur.
Yalnızca seçili şasenin ağı belleğe yüklenir. Dişli raylar boyuna sıkıştırılmaz;
gereken uzunlukta bırakılır. Seçilen boyu aşan PCNI plaka/yol koordinatları reddedilir.

Makine değişimi canlı okumayı ve önceki önizlemeyi kapatır. Her seçeneğin data
klasörü ayrı kaydedilir; yeni seçenek için kendi Dati/User klasörünü içeren
makine klasörünü seçmeden CNI canlı bağlantısı başlatılmaz. Mevcut kurulumun
data klasörü ilk 2142 seçeneğinde korunmuştur. CNI eksen referansları, orijinler
ve takımlar seçili data klasöründen okunur; CNC/PLC dosyaları değiştirilmez.

Doğrulama: 32 profil/sınır/kalıcılık kontrolü, 42 işleme kontrolü ve mevcut
1085 stok yüzeyi karşılaştırması geçti. 12 sabit sıfır noktası/sahne kontrolü
art arda üç çalıştırmada geçti. Üç ölçünün sahne görüntüleri, menüden geçiş
ve yeniden açılışta seçimin korunması ayrıca kontrol edildi.
Gerçek kontrol bilgisayarındaki akıcılık ayrıca ölçülmelidir.

## İlk çalıştırma

ZIP dosyasını tamamen çıkartın ve `app` ile `assets` klasörlerini birlikte tutun.
Kontrol bilgisayarında önce `Kontrol-Testi.cmd` çalıştırın. Test makineye veya CNC'ye
komut göndermez. Program mantığını, PRF/Z/ZI derinliklerini, matkap çevrimlerini,
tanımsız takım hatasını, kısmi/tam derinlik kesim yüzeylerini ve tam boy
plakanın güncelleme maliyetini denetler. Ardından Direct3D ve OpenGL ile hareketi
ve kesim sırasında hareketi ayrı ayrı ölçer. Her ölçüm 3 saniye hazırlık ve
10 saniye kayıt içerir. Her iki yükte yeterli çalışan sürücüler arasında hız farkı %5'ten
azsa kare süreleri daha dengeli olanı seçer. Seçimi `render-backend.txt` dosyasına
kaydeder ve `Baslat.cmd` sonraki açılışlarda onu otomatik kullanır. Sonuç `UYUMLU`
olursa programı açın.

## CNI canlı izleme ve program Start

CNI kuruluysa uygulama normal açılışta otomatik olarak salt okunur bağlanır.
NcOne Start durumunda çalışan PCNI dosyasını okur; LX, LY ve LZ ölçülerinden
plakayı oluşturur. Program adı, Start durumu, eksenler, aktif iş sıfırı ve takım
referansı CNI servislerinden okunur. Uygulama CNC veya PLC'ye komut göndermez.
Bağlantıyı kapatmak için CNI bağlantı penceresindeki durdurma düğmesini kullanın.

Canlı Y=0 makine kenar sıfırıdır; 1050 mm eklenmez. İşleme sırasında plaka,
CNI'den okunan aktif iş sıfırı CAD tablasının plaka köşesine eşlenerek yerleştirilir.
Takım ucu için aktif toplam eksen düzeltmesi ve PRIMO'nun GENERAL/CSag alt tabla payı
canlı okunur. Bu bilgiler alınamazsa malzeme hesabı bekler. Ölçülen yol programla eşleşmezse
malzeme kaldırılmaz ve eşleşme bekleniyor mesajı gösterilir. Veri kesildiğinde
malzeme hesabı durur. Uygulama fiziksel makineyi durdurmaz.

Havada geçen takım, sonraki bir rampanın XY izdüşümünden geçse bile kesim
sırasını ilerletmez. Önce doğrulanmış matkap geri çekilmesi tamamlanır;
malzeme üstündeki ölçülmüş derinlikte yol araması yapılmaz. Bu, sonraki
kanalların ve son ebatlamanın atlanmasını önler. Delikli_S01'in 7018 örnekli
tam çevrim kaydıyla 255 delik ve son konturlar tekrar doğrulandı; farklı
örnekleme zamanlarını temsil eden üç ara kayıt da kesimleri korudu.

## PCNI malzeme işleme

PCNI programları / etiketler ekranından programı okuyup plakayı yükleyin.
Bu ekranın 2D plaka görünümünde X sağa, Y aşağı doğru artar; etiketler ve kesim
yolu aynı yönü kullanır. Bu görünüm ayarı makinenin 3D eksenlerini değiştirmez.
İşlemeyi başlat düğmesi çevrimdışı önizlemeyi oynatır. Freze girişleri PON,
çıkışları PUP/POFF, doğrusal ilerleme G1 ve hızlı geçiş G0 olarak uygulanır.
PRF plaka üstünden aşağı pozitif derinliktir; negatif PRF havadadır. ZI mevcut
derinliği artırır/azaltır; mutlak Z için derinlik LZ+Z'dir. Bu nedenle PRF=-10,
ardından ZI=28, 18 mm plakada tam derinliğe giriş verir. QVF/QVD/F ilerlemeleri
m/dak biriminden okunur; hız sürgüsü yalnızca önizleme hızını değiştirir.

Dikey G99 delikleri FAM grubuyla, T seçimi, takım çapı ve PRF derinliğiyle
oluşturulur. Çoklu T seçiminin delikleri datmand_01_dat.ini ofsetlerine göre
hesaplanır. Takım adları/çapları datpunt_dat.ini'den; matkap eşlemesi
protmand_dat.ini ve datconf_01_dat.ini'den okunur. Programdaki çap açıklaması
takımı kütüphaneye kaydetmez. Tanımsız takım varsa Start sonrası simülasyon
sayfasında örneğin “6MMZ3 takımı takım kütüphanesinde tanımlı değil” hatası
çıkar ve o programda malzeme işleme başlamaz. CNI takım kütüphanesi değiştirilmez.

Malzeme hesabı 2 mm hücreli, dikey freze/delik için 2,5 boyutlu geometrik
önizlemedir. Kör delik, tam geçiş, değişken derinlik ve rampalar hesaplanır.
CAD modelinin görünür şekli ve ekran çözünürlüğü korunur. Arcs G2/G3, yatay/açılı
delik, özel makrolar, takım yarıçap telafisi, kesme fiziği ve çarpışma doğrulaması
bu sürümde uygulanmaz; desteklenmeyen komut veya sayısal ifade açık hata verir.
Bu görünüm bir üretim veya çarpışma onayı değildir.

## Donanım profili

Sahne kontrol bilgisayarı için sadeleştirilmiştir. Gölgeler, parçacık efektleri ve
çoklu örneklemeli kenar yumuşatma kapalıdır. CAD parçaları az sayıda çizim grubuna
birleştirilmiş, küçük yüzey ayrıntıları azaltılmıştır. Tabla, köprü, kapaklar,
freze-matkap grubu ve eksen hareketleri korunur. Pencere küçültülünce simülasyon
duraklar. Gerçek bilgisayardaki karar `Kontrol-Testi-Sonucu.txt` içindeki hareket ve
kesim sonuçlarına göre verilmelidir. `UYUMLU` için iki yükte de en az 24 FPS,
en fazla 75 ms p95 kare süresi ve 100 ms üzerindeki karelerin en fazla %2 olması
gerekir. `SINIRDA` veya `YETERSIZ` sonucu akıcılık hedefinin karşılanmadığını belirtir.
Yerel bilgisayarın sonucu kontrol ünitesinin sonucunun yerine geçmez.

Kesim hesabındaki 2 mm hücreler korunur. Aynı yükseklikteki hücreler tam olarak
aynı yüzeyi veren düz dikdörtgenlere birleştirilir. Kesimde yalnızca değişen
64 × 64 hücrelik bölgelerin geometrisi yeniden hesaplanır; diğer bölgeler
önbellekten alınır. CAD sahnesi açıkken kullanılmayan demo sahnesi oluşturulmaz.
Eksen ve durum bildirimleri yalnızca ilgili değer değiştiğinde gönderilir; sabit
değerler için sahne ve arayüz yeniden değerlendirilmez. Uzun çapraz kesimlerde
yalnızca takımın ulaşabileceği hücreler kontrol edilir; kesim kararı ve 2 mm
hassasiyet aynıdır. Geometri güncellemelerinde sabit vertex düzeni korunur.
Kapalı tabla içinde kalan destek ve bağlantı parçaları temizlenmiştir. Görünen
parçaların dış şekli, renkleri, yüzey normalleri ve görüntü çözünürlüğü korunur.

Kontrol bilgisayarı profilinde bütün kablo taşıma zincirleri, esnek toz emiş
hortumları ve Clamp sistemi modelden çıkarılmıştır. Bunlar yalnızca görsel CAD
parçalarıdır; eksen konumu veya PCNI kesim hesabında kullanılmaz. Kablo
kanallarının yanındaki açık siyah elektrik panosu, aynı dış ölçülerde kapalı beyaz
bir kutu olarak yenilenmiştir ve X/Y kafa hareketini birlikte izler. Spindle motoru
HSD ES929-A görünümüne uygun alüminyum-gümüş renkte; FAM matkap grubu ise beyaz
kapak, alüminyum gövde, gri kılavuz/pnömatik elemanlar ve siyah matkap uçlarıyla
renklendirilmiştir. Kapalı tabla altında dışarıdan
görünmeyen iç şase yüzleri azaltılmış; dış kapaklar, çevre profilleri ve ayaklar
korunmuştur. Alt şasedeki üç ayrıntılı vakum giriş bileziği kaldırılmış ve çıkış
yüzeyi çerçeve arkasına bindirilen sabit, düz ve şase rengindeki bir gövde
kapağıyla tamamen kapatılmıştır.
Pano ve kafa bölgesinde pano, servo motorlar ve freze/matkap kafa gövdesi
dışındaki kablo kanalı yan plakaları, pimler, borular ve bağlantı kalıntıları da
modelden temizlenmiştir.
Köprünün ön ve arka ucundaki iki Yaskawa servo motor gövdesi kontrol bilgisayarı
profilinden çıkarılmıştır; Z ekseni kaideleri, bağlantı plakaları, spindle ve FAM
kafa motorları korunmuştur.

Start sırasında CAD modeli makine koordinatından parça koordinatına geçmez.
Görsel makine referansı başlangıçta kayıtlı ORIG_SX, T1 ve TP1 kurulum verilerinden
oluşturulur; canlı model yalnızca ölçülen fiziksel X/Y/Z hareketini izler.
Start, Stop, iş sıfırı değişimi ve plaka ölçüsü değişimi makineyi yerinden oynatmaz.
Veri kesilirse son fiziksel konum korunur. Çevrimdışı Sıfırla işleminde Y=0 olur.
Plakanın X/Y sıfırı her ölçüde giriş tablasının aynı köşesindedir
(CAD X=-1.017 m, Z=-1.2046434 m); boyut değişince yalnızca karşı kenarlar büyür.
Kurulum verileri uygulama açılışında okunur; kurulum değişirse uygulama yeniden açılmalıdır.

Giriş tablasındaki açık iç bölüm ince, düz bir kapakla ve ana tabla altındaki
dikey açıklık bir kenar kapağıyla kapatılmıştır. Çıkış yüzeyi kapağı üstteki siyah
tabla kenarına kadar yükseltilmiş ve çevre çerçevesinin arkasına bindirilmiştir.
Ön/arka redüktörler ve yalnızca onlara ait yüz plakaları, miller ve vidalar
çıkarılmıştır. Köprü iç duvarındaki dalgalı görünen ince panel, çerçevesi korunarak
düz bir yüzeyle yenilenmiştir. Yeni kapaklar toplam üç basit kutu geometrisidir;
görüntü çözünürlüğü ve kesim hesabının ayrıntısı azaltılmamıştır.
