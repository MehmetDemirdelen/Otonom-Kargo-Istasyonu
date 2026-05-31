# Otonom-Kargo-Istasyonu

Bu depo, projenin hem gömülü sistem (ESP32) hem de arayüz yazılımlarının kaynak kodlarını içermektedir.

## 1. Gömülü Sistem ve IoT Haberleşmesi (ESP32)
Bu klasördeki kodlar; MQTT protokolü üzerinden dolap eşleştirme, Peltier modüllerinin kapalı çevrim PID kontrolü ve olası internet kesintilerinde veri kaybını önleyen hata tolerans (fail-safe) algoritmalarını içermektedir.

## 2. Mobil Uygulama (UI/UX)
Bu klasörde kurye ve müşteri girişlerini yöneten, Çoklu Rol Tabanlı Erişim Kontrolü (RBAC) ile izole edilmiş ve dinamik karekod okuyuculu mobil uygulamanın kaynak kodları bulunmaktadır.