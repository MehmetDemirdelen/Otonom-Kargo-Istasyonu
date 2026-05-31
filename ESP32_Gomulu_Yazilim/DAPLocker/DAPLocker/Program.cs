using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;
using DAPLocker; 

namespace DAPLocker
{
    class Program
    {
        static async Task Main(string[] args)
        {
            Console.WriteLine("--- AKILLI KARGO OTOMATI TEST SİMÜLASYONU ---\n");

            var mockMqtt = new MockMqttService();
            var mockSms = new MockNotificationService();
            var dbContext = new AppDbContext();

            // 1. SİSTEME SAHTE VERİ (SEED DATA) YÜKLÜYORUZ
            SeedDatabase(dbContext);
            Console.WriteLine("[SİSTEM] Veritabanına 4 adet dolap ve bekleyen kargo bilgileri yüklendi.\n");

            var qrManager = new QrSessionManager(mockMqtt, dbContext);
            var assignmentService = new LockerAssignmentService(dbContext, mockMqtt);
            var confirmationService = new DeliveryConfirmationService(dbContext, qrManager, mockSms);

            // --- TEST SENARYOSU ---
            Console.WriteLine("SENARYO 1: Kurye barkodu okuttu ve 1 adet Sıcak, 1 adet Soğuk paket bırakmak istiyor.");

            var packages = new List<PackageInfo>
        {
            new PackageInfo { TrackingNumber = "TR-SICAK-01", RequiredClimate = ClimateType.Hot, RequiredSize = LockerSize.Small },
            new PackageInfo { TrackingNumber = "TR-SOGUK-02", RequiredClimate = ClimateType.Cold, RequiredSize = LockerSize.Small }
        };

            try
            {
                // Kurye için uygun dolapları bul
                var assignedLockers = await assignmentService.ProcessCourierDropoffAsync(1, packages);

                Console.WriteLine("\nSENARYO 2: Kurye paketleri koydu, kapıları kapattı ve kilitledi.");

                // Sensör verisi simülasyonu (Örn: 1 Numaralı Sıcak Dolap kapatıldı)
                var sensorData1 = new SensorUpdatePayload
                {
                    LockerId = 1,
                    IsDoorClosed = true,
                    IsDoorLocked = true,
                    IsWeightDetected = true,
                    CurrentTemperature = 59.0
                };
                await confirmationService.ProcessSensorDataAsync(sensorData1);

                // Sensör verisi simülasyonu (Örn: 3 Numaralı Soğuk Dolap kapatıldı)
                var sensorData2 = new SensorUpdatePayload
                {
                    LockerId = 3,
                    IsDoorClosed = true,
                    IsDoorLocked = true,
                    IsWeightDetected = true,
                    CurrentTemperature = 4.2
                };
                await confirmationService.ProcessSensorDataAsync(sensorData2);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"\n[HATA YAKALANDI]: {ex.Message}");
            }

            Console.WriteLine("\nTest bitti. Çıkmak için bir tuşa basın.");
            Console.ReadKey();
        }

        // Sahte verileri oluşturan yardımcı fonksiyon
        static void SeedDatabase(AppDbContext db)
        {
            db.Stations.Add(new Station { Id = 1, CurrentSessionId = "İLK_QR_KODU" });

            // İstasyona farklı özelliklerde dolaplar ekliyoruz
            db.Lockers.AddRange(new List<Locker>
        {
            new Locker { Id = 1, StationId = 1, Climate = ClimateType.Hot, Size = LockerSize.Small, IsEmpty = true },
            new Locker { Id = 2, StationId = 1, Climate = ClimateType.Hot, Size = LockerSize.Medium, IsEmpty = true },
            new Locker { Id = 3, StationId = 1, Climate = ClimateType.Cold, Size = LockerSize.Small, IsEmpty = true },
            new Locker { Id = 4, StationId = 1, Climate = ClimateType.Ambient, Size = LockerSize.Large, IsEmpty = true }
        });

            // Bekleyen paketlerin müşteri bilgilerini ekliyoruz (SMS atmak için)
            db.Packages.AddRange(new List<Package>
        {
            new Package { TrackingNumber = "TR-SICAK-01", CustomerId = "Ahmet Y.", PickupCode = "123456", Status = PackageStatus.Pending },
            new Package { TrackingNumber = "TR-SOGUK-02", CustomerId = "Ayşe K.", PickupCode = "987654", Status = PackageStatus.Pending }
        });
        }
    }


    #region 1. VERİ MODELLERİ (ENUMS & ENTITIES)
    public enum ClimateType { Ambient, Cold, Hot }
        public enum LockerSize { Small, Medium, Large }
        public enum PackageStatus { Pending, InLocker, ReadyForPickup, PickedUp }

        public class PackageInfo
        {
            public string TrackingNumber { get; set; }
            public LockerSize RequiredSize { get; set; }
            public ClimateType RequiredClimate { get; set; }
        }

        public class Package
        {
            public string TrackingNumber { get; set; }
            public string CustomerId { get; set; }
            public string PickupCode { get; set; }
            public PackageStatus Status { get; set; }
            public DateTime? DeliveredAt { get; set; }
        }

        public class Locker
        {
            public int Id { get; set; }
            public int StationId { get; set; }
            public LockerSize Size { get; set; }
            public ClimateType Climate { get; set; }
            public double CurrentTemperature { get; set; }
            public double TargetTemperature { get; set; }
            public bool IsEmpty { get; set; }
            public string CurrentTrackingNumber { get; set; }
        }

        public class Station
        {
            public int Id { get; set; }
            public string CurrentSessionId { get; set; }
            public DateTime QrExpiryTime { get; set; }
        }

        public class SensorUpdatePayload
        {
            public int LockerId { get; set; }
            public bool IsDoorClosed { get; set; }
            public bool IsDoorLocked { get; set; }
            public bool IsWeightDetected { get; set; }
            public double CurrentTemperature { get; set; }
        }
        #endregion

        #region 2. DIŞ SERVİS ARAYÜZLERİ (INTERFACES)
        // Gerçek projede bunların içini doldurulacak (MQTT, SMS ve DB bağlantıları)
        public interface IMqttService
        {
            Task SendOpenDoorsCommandAsync(int stationId, List<int> doorIds);
            Task SendNewQrToScreenAsync(int stationId, string newQrCode);
        }

        public interface INotificationService
        {
            Task SendDeliverySmsAsync(string customerId, string message);
            Task SendAlertToAdminAsync(string message);
        }

    // Entity Framework DbContext simülasyonu
    public class AppDbContext
    {
        //İçinde veri tutulabilen listeler.
        public List<Locker> Lockers { get; set; } = new List<Locker>();
        public List<Package> Packages { get; set; } = new List<Package>();
        public List<Station> Stations { get; set; } = new List<Station>();

        public Task SaveChangesAsync() => Task.CompletedTask;

        public async Task<Locker> FindLockerAsync(int id) => Lockers.FirstOrDefault(l => l.Id == id);
        public async Task<Package> FindPackageAsync(string trackingNumber) => Packages.FirstOrDefault(p => p.TrackingNumber == trackingNumber);
        public async Task<Station> FindStationAsync(int id) => Stations.FirstOrDefault(s => s.Id == id);
    }
    #endregion

    #region 3. İŞ MANTIK SERVİSLERİ (SERVICES)

    // A) İklimlendirme Kontrol Servisi
    public class ClimateService
        {
            public void CheckAndAdjust(Locker locker)
            {
                double tolerance = 1.0;
                if (locker.CurrentTemperature < locker.TargetTemperature - tolerance)
                    Console.WriteLine($"Locker {locker.Id}: Isıtma devrede.");
                else if (locker.CurrentTemperature > locker.TargetTemperature + tolerance)
                    Console.WriteLine($"Locker {locker.Id}: Soğutma devrede.");
            }
        }

        // B) Dinamik QR Üretim Servisi
        public class QrSessionManager
        {
            private readonly IMqttService _mqttService;
            private readonly AppDbContext _dbContext;

            public QrSessionManager(IMqttService mqttService, AppDbContext dbContext)
            {
                _mqttService = mqttService;
                _dbContext = dbContext;
            }

            public async Task<string> GenerateAndPublishNewQrAsync(int stationId)
            {
                string newSessionId = Guid.NewGuid().ToString("N");
                var station = await _dbContext.FindStationAsync(stationId);

                station.CurrentSessionId = newSessionId;
                station.QrExpiryTime = DateTime.UtcNow.AddMinutes(5);
                await _dbContext.SaveChangesAsync();

                await _mqttService.SendNewQrToScreenAsync(stationId, newSessionId);
                return newSessionId;
            }
        }

        // C) Kurye Eşleştirme ve Kapı Açma Servisi
        public class LockerAssignmentService
        {
            private readonly AppDbContext _dbContext;
            private readonly IMqttService _mqttService;

            public LockerAssignmentService(AppDbContext dbContext, IMqttService mqttService)
            {
                _dbContext = dbContext;
                _mqttService = mqttService;
            }

            public async Task<List<Locker>> ProcessCourierDropoffAsync(int stationId, List<PackageInfo> packages)
            {
                var assignedLockers = new List<Locker>();
                var availableLockers = _dbContext.Lockers.Where(l => l.StationId == stationId && l.IsEmpty).ToList();

                foreach (var package in packages)
                {
                    var suitableLocker = availableLockers.FirstOrDefault(l =>
                        l.Climate == package.RequiredClimate &&
                        l.Size >= package.RequiredSize &&
                        !assignedLockers.Contains(l));

                    if (suitableLocker == null)
                        throw new Exception($"Kargo {package.TrackingNumber} için uygun dolap bulunamadı!");

                    suitableLocker.IsEmpty = false;
                    suitableLocker.CurrentTrackingNumber = package.TrackingNumber;
                    assignedLockers.Add(suitableLocker);
                }

                await _dbContext.SaveChangesAsync();

                var doorsToOpen = assignedLockers.Select(l => l.Id).ToList();
                await _mqttService.SendOpenDoorsCommandAsync(stationId, doorsToOpen);

                return assignedLockers;
            }
        }

        // D) Sensör Verisi Okuma, Teslimat Onayı ve QR Yenileme Servisi
        public class DeliveryConfirmationService
        {
            private readonly AppDbContext _dbContext;
            private readonly QrSessionManager _qrManager;
            private readonly INotificationService _notificationService;

            public DeliveryConfirmationService(AppDbContext dbContext, QrSessionManager qrManager, INotificationService notificationService)
            {
                _dbContext = dbContext;
                _qrManager = qrManager;
                _notificationService = notificationService;
            }

            public async Task ProcessSensorDataAsync(SensorUpdatePayload payload)
            {
                var locker = await _dbContext.FindLockerAsync(payload.LockerId);
                if (locker == null) return;

                locker.CurrentTemperature = payload.CurrentTemperature;

                // KAPALI, KİLİTLİ VE İÇİNDE YÜK VAR KONTROLÜ
                if (payload.IsDoorClosed && payload.IsDoorLocked && payload.IsWeightDetected)
                {
                    var package = await _dbContext.FindPackageAsync(locker.CurrentTrackingNumber);
                    if (package != null && package.Status != PackageStatus.ReadyForPickup)
                    {
                        package.Status = PackageStatus.ReadyForPickup;
                        package.DeliveredAt = DateTime.UtcNow;

                        await _notificationService.SendDeliverySmsAsync(package.CustomerId,
                            $"Kargonuz {locker.Id} nolu dolapta. Şifreniz: {package.PickupCode}");

                        await _dbContext.SaveChangesAsync();

                        // İŞLEM BİTTİ -> YENİ QR ÜRET
                        await _qrManager.GenerateAndPublishNewQrAsync(locker.StationId);
                        Console.WriteLine("Kargo kilitlendi. Güvenlik için QR kod anında yenilendi.");
                    }
                }
                else if (payload.IsDoorClosed && !payload.IsDoorLocked)
                {
                    await _notificationService.SendAlertToAdminAsync($"Uyarı: {locker.Id} nolu kapı kapandı ancak KİLİTLENEMEDİ!");
                }
            }
        }
        #endregion

        #region 4. ARKA PLAN İŞÇİSİ (BACKGROUND SERVICE)
        // 5 Dakikada bir otomatik QR yenileyen motor
        public class QrRefreshWorker : BackgroundService
        {
            private readonly QrSessionManager _qrManager;

            public QrRefreshWorker(QrSessionManager qrManager)
            {
                _qrManager = qrManager;
            }

            protected override async Task ExecuteAsync(CancellationToken stoppingToken)
            {
                while (!stoppingToken.IsCancellationRequested)
                {
                    int stationId = 1; // Örnek İstasyon
                    await _qrManager.GenerateAndPublishNewQrAsync(stationId);
                    Console.WriteLine("5 dakika doldu. QR kod otomatik yenilendi.");

                    await Task.Delay(TimeSpan.FromMinutes(5), stoppingToken);
                }
            }
        }
    
    public class MockMqttService : IMqttService
    {
        public Task SendOpenDoorsCommandAsync(int stationId, List<int> doorIds)
        {
            Console.WriteLine($"[DONANIM] İstasyon {stationId} için kapılar açılıyor: {string.Join(", ", doorIds)}");
            return Task.CompletedTask;
        }

        public Task SendNewQrToScreenAsync(int stationId, string newQrCode)
        {
            Console.WriteLine($"[EKRAN] İstasyon {stationId} ekranındaki QR güncellendi: {newQrCode}");
            return Task.CompletedTask;
        }
    }

    public class MockNotificationService : INotificationService
    {
        public Task SendDeliverySmsAsync(string customerId, string message)
        {
            Console.WriteLine($"[SMS GÖNDERİLDİ] Müşteri {customerId}: {message}");
            return Task.CompletedTask;
        }

        public Task SendAlertToAdminAsync(string message)
        {
            Console.WriteLine($"[ALARM - YÖNETİCİ] {message}");
            return Task.CompletedTask;
        }
    }
    #endregion
}

