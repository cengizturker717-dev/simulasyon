# Super Vigor 2136 makine referansı

Bu profil, 1 Ekim 2026 tarihinde paylaşılan gerçek makine fotoğrafları ve kontrol ünitesi bilgilerine göre hazırlanmıştır.

## Fiziksel yapı

- Model: Poyraz Makina Super Vigor 2136.
- Çalışma tablası: 2100 mm en; örnek iş listesinde 2800 × 2100 × 18 mm plaka.
- Köprü mekanik sıfırda makinenin sol tarafında bulunur.
- Köprü ön yüzü açık gri, siyah yan kapaklar ve turuncu dikey/yatay şeritlerden oluşur.
- Sol servis kapısında yeşil dikey durum ışığı vardır.
- Köprü üstünde siyah kablo taşıyıcı ve çoklu talaş emiş hortumları bulunur.
- Bu kurulumda asansör ve çıkış konveyörü yoktur.
- Simülasyonda atölye ortamı, sabit emiş tesisatı ve ayrıntılı hortum geometrisi performans için çizilmez.

## Kontrol ünitesi

- İşletim sistemi: Windows 10 Enterprise LTSC 64 bit, build 17763.
- Ortam: innotek GmbH VirtualBox sanal makinesi.
- İşlemci: Intel 300, 2 sanal işlemci, yaklaşık 3.9 GHz.
- Bellek: 4096 MB RAM.
- Grafik: VirtualBox Graphics Adapter (WDDM), WDDM 1.3.
- Ayrılmış VRAM: 0 MB; paylaşımlı grafik belleği yaklaşık 2039 MB.
- Direct3D hızlandırması etkin, DirectX 12 ve D3D feature level 12_1 raporlanıyor.
- Ses donanımı bulunmuyor.

## Render profili

- Qt Quick 3D yerel HMI kullanılır.
- Gölgeler ve ağır çevre efektleri kullanılmaz.
- MSAA düşük kalite (2x) tutulur.
- Asansör, konveyör ve atölye çevresi modele eklenmez.
- CNI bağlantısı yalnızca okuma yapar; makine kontrolüne komut göndermez.
