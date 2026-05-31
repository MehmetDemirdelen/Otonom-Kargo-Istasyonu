# Kargo Sistemi

Akıllı kargo dolabı fikrine bakan bir arayüz denemesi. Kurye / müşteri akışı var, QR ekranı falan; ama arkada gerçek bir servis yok, kamera da yok — butonlarla simüle ediliyor.

Sadece **Android** hedefli; iOS / web / masaüstü klasörleri yok.

## Çalıştırmak için

`flutter pub get`, telefon veya emülatör bağlıyken `flutter run` (gerekirse `-d android`).

İkon / splash değişecekse `assets/brand_logo.png` güncelle; Android tarafındaki `mipmap-*` ve `drawable*` dosyalarını Android Studio veya elle senkronlaman gerekir (projede otomatik üreten paket yok).
