# Kontrol ünitesi için son sürüm — 6 Ekim 2026

Son kontrolde mevcut CAD modeli değiştirilmeden çalışma zamanı iyileştirildi.
Sahne QML dosyası ve referans verilen 11 mesh dosyası bu tur öncesiyle SHA-256
olarak birebir aynı. Çözünürlük, renkler, yüzeyler ve hareket aralığı korunuyor.

Eksen ve durum bildirimleri ayrıldı: yalnızca değişen özelliğe ait arayüz ve
sahne bağlantıları güncelleniyor. Kesim hesabında her satırdaki olası takım
alanı daraltıldı; önceki uzaklık hesabı aynen korundu. Geometri düzeni her
güncellemede yeniden oluşturulmuyor ve komşu bölgeler yalnızca sınırda işaretleniyor.

| Bu turdaki doğrulama | Sonuç |
|---|---|
| Önceki kesim algoritmasıyla karşılaştırma | 1.085 durumda bütün vertex, normal, renk verileri ve kaldırılan hacim birebir aynı |
| Önceki model görüntüsüyle karşılaştırma | 16 sabit görünümde makine alanında 0 farklı piksel; alt kamera yönergesi ve görünüm düğmesi yazıları dışarıda |
| Eksen/durum bildirimleri | Değişmeyen değerler için bildirim çıkmıyor; hareket ve canlı konum kontrolleri geçti |
| X/Y/Z hareketi ve kamera yakınlaştırma/sıfırlama | Geçti |
| 3660 × 2100 mm uzun çapraz kesimin yalnızca hesap süresi | 13,1082 → 0,23425 ms; yaklaşık 56 kat daha kısa |

Bu 56 kat kazanç bütün programın FPS kazancı değildir. Hareket güncelleme aralığı
33 ms olarak korunuyor. Yerel test iki mantıksal işlemciyle sınırlandı; program,
kesim modeli ve tam boy plaka yük kontrolleri geçti. 100 kısa kesimde geometri
güncellemesi ortanca 0,68 ms, p95 1,19 ms, en yüksek 1,48 ms ölçüldü.

| Son yerel ölçüm | Hareket FPS | Kesim FPS | İki yükün en yüksek p95 değeri | 100 ms üzerindeki kareler |
|---|---:|---:|---:|---:|
| Direct3D 11 | 30,97 | 37,02 | 65,43 ms | 0 |
| OpenGL | 30,69 | 37,75 | 34,69 ms | 0 |

Sonuç **UYUMLU**; daha dengeli kare süreleri nedeniyle OpenGL seçildi. Genel FPS
önceki sürümle benzer; ek kazanç kesim hesabındaki işlem yükünü ve gereksiz
arayüz güncellemelerini azaltıyor. Gerçek kontrol ünitesindeki akıcılık bu yerel
testle doğrulanmış sayılmaz: yeni pakette `Kontrol-Testi.cmd` orada çalıştırılmalı.
Yedek ve model imzaları `work/runtime-optimization-baseline`, karşılaştırma ve
kamera sonuçları `work/runtime-final-check`, kesim algoritması sonuçları
`work/runtime-checks.txt` altında tutuluyor.

## Önceki model temizliği ve karşılaştırma kaydı

Giriş tablasındaki açık iç bölüm ve yükseltilmiş tabla altındaki dikey açıklık kapatıldı. Çıkış kapağı siyah tabla kenarına kadar yükseltildi ve çevre çerçevesinin arkasına bindirildi. İki açıklık normal ve eğik açılardan uygulamada kontrol edildi. Arka iç duvardaki dalgalı görünen ince panel düz bir yüzeyle yenilendi; çevresindeki çerçeve korundu. Ön/arka redüktörler ve yalnızca bunlara ait yüz plakaları, miller ve vidalar temizlendi.

Pano, kafa grubu, Z kaideleri, görünen şase profilleri ve ayaklar korundu. Pano X/Y kafa hareketini, yeni iç duvar paneli köprünün X hareketini izler. Çözünürlük ve 2 mm kesim hücreleri azaltılmadı. Yeni kapaklar üç basit kutu geometrisidir; mevcut çıkış kapağının ölçüleri genişletildi.

| Son temizlik öncesi / sonrası | Sonuç |
|---|---|
| Referans verilen 11 mesh dosyasının boyutu | 13.666.064 → 13.463.544 bayt; 202.520 bayt (%1,48) azalma |
| Mesh dosyalarındaki üçgenler | 351.095 → 343.347; 7.748 daha az üçgen |
| Yeni basit kapakların ilave üçgenleri | 36 |
| Taşınabilir ZIP | 44,1 MiB; 1.439 dosya |
| ZIP dosyaları | 11 mesh, sahne, EXE ve test betiği kaynak paketle birebir doğrulandı |
| ZIP'ten çıkarılan kopyada X/Y/Z hareket testi | Geçti; boşluk içeren klasörden çalıştırıldı |

İki mantıksal işlemciyle sınırlı son yerel testte program, kısmi/tam derinlik kesimi ve tam boy plaka yük testi geçti. 100 kısa kesimde geometri güncellemesinin ortancası 0,71 ms, p95 değeri 1,07 ms, en yüksek süre 1,26 ms idi. Son güncellemede yalnızca 2 bölge yeniden hesaplandı.

| Grafik sürücüsü | Hareket FPS | Kesim sırasında FPS | İki yükün en yüksek p95 değeri | 100 ms üzerindeki kareler |
|---|---:|---:|---:|---:|
| Direct3D 11 | 31,10 | 38,14 | 51,58 ms | 0 |
| OpenGL | 31,00 | 37,11 | 35,27 ms | 0 |

Sonuç **UYUMLU**. İki sürücü de yeterli olduğundan ve hız farkı %5'in altında kaldığından daha dengeli kare süreleri veren OpenGL seçildi. Test betiği artık bu seçimi otomatik yapar. Kontrol ünitesinde sürücü yeniden ölçülür; geliştirme bilgisayarının seçimi ZIP'e taşınmaz.

Önceki optimizasyondaki 64 × 64 hücrelik geometri önbelleği, yalnızca değişen bölgelerin hesaplanması ve eş yükseklikteki yüzeylerin birebir aynı alanı veren dikdörtgenlere birleştirilmesi korunuyor. 3660 × 2100 mm düz plaka 15.720 yerine 2.156 üçgen kullanıyor (%86,3 azalma). Kullanılmayan demo sahnesi CAD sahnesiyle birlikte oluşturulmuyor. Hareket önizlemesi 33 ms aralıkla güncelleniyor; sabit görüntüde görünen 0–1 FPS değeri hareket performansı ölçümü değildir.

Bu son parça temizliği büyük bir FPS sıçraması getirmedi: önceki yerel hareket ölçümü yaklaşık 31 FPS idi, son ölçüm de aynı düzeydedir. Gerçek VirtualBox kontrol ünitesindeki eski 5–8 FPS ile bu bilgisayarın sonuçları doğrudan karşılaştırılamaz. Kontrol ünitesinde sorunsuz çalıştığı henüz doğrulanmadı.

Yeni ZIP tamamen çıkarıldıktan sonra kontrol ünitesinde `Kontrol-Testi.cmd` çalıştırılmalı. Karar yeni `Kontrol-Testi-Sonucu.txt` ile verilir. UYUMLU için hareket ve kesim yüklerinde en az 24 FPS, en fazla 75 ms p95 ve 100 ms üzerindeki kare oranının en fazla %2 olması gerekir.

Modeli kaynak CAD'den yeniden üretme: `source/tools/build_controller_assets.ps1`. Bu tur öncesindeki model ve işlem betikleri `work/bay-cleanup-baseline` altında; daha önceki optimizasyon öncesi sürüm `work/controller-optimization-baseline` altında korunmuştur.
