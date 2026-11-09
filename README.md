# ArduPilot Telemetry

ArduPilot aracından (veya SITL simülatöründen) UDP üzerinden MAVLink telemetrisi alan, bunu canlı harita ekranında gösteren ve araca temel komutlar gönderen bir Flutter yer kontrol uygulaması.

## Özellikler

- **Canlı harita**: OpenStreetMap üzerinde aracın konumu ve yönü, aracı takip etme düğmesi
- **Üst bar**: bağlantı durumu (son 5 sn içinde heartbeat), uçuş modu, arm durumu, batarya voltajı/yüzdesi, GPS fix tipi ve uydu sayısı
- **Gösterge kutuları**: göreli irtifa, yer hızı, yön, tırmanma hızı, gaz ve batarya akımı
- **Komutlar**: `MAV_CMD_COMPONENT_ARM_DISARM` ile ARM / DISARM
- **Mesaj kaydı**: zaman damgalı uçuş modu değişiklikleri, `COMMAND_ACK` sonuçları ve `STATUSTEXT` mesajları (son 20 mesaj tutulur)

## Mimari

Veri dört katmandan tek yönde akar; her katman yalnızca altındaki katmana bağlıdır:

```
UDPLink  →  MavlinkCodec  →  Vehicle  →  UI
(byte)      (frame)          (Telemetry)  (widget)
```

| Katman | Dosya | Görevi |
|---|---|---|
| Link | `lib/link/udp_link.dart` | UDP soketini açar, ham byte'ları yayınlar, son gönderene cevap yollar |
| Codec | `lib/mavlink/mavlink_codec.dart` | Byte'ları MAVLink frame'lerine çevirir (ArduPilotMega dialect), giden mesajları MAVLink v2 olarak paketler |
| Vehicle | `lib/vehicle/` | Frame'leri değiştirilemez bir `Telemetry` nesnesine dönüştürüp `ValueNotifier` olarak sunar; komut gönderir |
| UI | `lib/ui/` | `ValueListenableBuilder` ile `Vehicle.telemetry` değiştikçe yeniden çizilir |

İşlenen MAVLink mesajları: `HEARTBEAT`, `GLOBAL_POSITION_INT`, `ATTITUDE`, `SYS_STATUS`, `VFR_HUD`, `GPS_RAW_INT`, `STATUSTEXT`, `COMMAND_ACK`. Yalnızca sistem 1 / bileşen 1'den gelen frame'ler işlenir. Giden frame'ler sistem ID 255, bileşen ID 190 kullanır.

## Gereksinimler

- Flutter SDK (Dart `^3.13.3`)
- macOS 14.0 veya üzeri (şu an yapılandırılmış tek platform)
- UDP **14550** portuna MAVLink gönderen bir ArduPilot aracı veya [SITL](https://ardupilot.org/dev/docs/sitl-simulator-software-in-the-loop.html)

## Başlarken

```bash
flutter pub get
flutter run -d macos
```

SITL'i başlatıp MAVLink'i uygulamaya yönlendirin:

```bash
sim_vehicle.py -v ArduCopter --console --map --out=udp:127.0.0.1:14550
```

Heartbeat gelmeye başlayınca üst bar **CONNECTED** olur. Harita, ilk GPS konumu geldikten sonra görünür.

## Proje Yapısı

```
lib/
├── main.dart              # link → codec → vehicle bağlantısını kurar ve uygulamayı başlatır
├── link/udp_link.dart
├── mavlink/mavlink_codec.dart
├── vehicle/
│   ├── vehicle.dart       # Frame işleme ve komutlar
│   ├── telemetry.dart     # Değiştirilemez telemetri durumu
│   └── enums.dart         # FlightMode, GpsFix, Severity
└── ui/
    ├── home_screen.dart
    ├── map_view.dart
    ├── message_log.dart
    ├── control_panel.dart # Geliştiriliyor
    └── widgets/           # TopBar, StatTile, FlightHorizon (geliştiriliyor)
```

## Yol Haritası

- Kontrol paneli ve uçuş ufku widget'ları (iskeleti hazır, henüz ekrana bağlı değil)
- Uçuş modu değiştirme ve kalkış/iniş komutları
- Eve uzaklık göstergesi
