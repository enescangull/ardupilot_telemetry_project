// =====================================================================
// 2_mavlink_codec.dart  —  İKİNCİ KATMAN: "Tercüman"
// Bu dosyanın tek işi: Link'ten gelen anlamsız byte'ları alıp
// anlamlı MAVLink mesajlarına (frame) çevirmek.
// UDP mi, BLE mi bilmez. Drone'un irtifasıyla da ilgilenmez.
// Benzetme: posta kutusundan gelen mektubu açıp hangi dilde ve kimden olduğunu söyleyen kişi.
// =====================================================================

import 'dart:async'; // StreamSubscription için

import 'package:dart_mavlink/dialects/ardupilotmega.dart'; // ArduPilot'un mesaj sözlüğü
// dart_mavlink paketinin parçaları:
import 'package:dart_mavlink/mavlink.dart'; // MavlinkParser, MavlinkFrame

// Bir önceki katmanı tanıyoruz (sadece onu!). "../" = bir üst klasör.
import '../link/udp_link.dart';

class MavlinkCodec {
  // Byte'ları alacağımız kaynak. Link sözleşmesi; UdpLink da olabilir başka şey de.
  final Link link;

  // MavlinkParser = paketin hazır tercümanı.
  // İçine "dialect" (sözlük) veriyoruz: ArduPilot'un mesajlarını tanısın diye.
  // Dialect = hangi mesaj numarası hangi mesaj demek, onun listesi.
  // Örn: numara 0 = HEARTBEAT, numara 33 = GLOBAL_POSITION_INT.
  final MavlinkParser _parser = MavlinkParser(MavlinkDialectArdupilotmega());

  // StreamSubscription = "bir yayına abone olduğumun makbuzu".
  // İleride aboneliği iptal etmek (cancel) için saklıyoruz.
  StreamSubscription? _sub;

  // Constructor: MavlinkCodec(link) diye oluşturulur.
  MavlinkCodec(this.link);

  // Dışarıya verdiğimiz şey: çözülmüş MAVLink frame'lerinin yayını.
  // Parser her tam mesajı çözdüğünde buraya bir MavlinkFrame düşer.
  // DİKKAT: Bu stream'i sadece BİR kişi dinleyebilir (Vehicle).
  Stream<MavlinkFrame> get frames => _parser.stream;

  void start() {
    // Link'in byte yayınına abone ol.
    // Her byte paketi geldiğinde _parser.parse(paket) çağrılsın.
    // "_parser.parse" yazıp parantez koymamak = "fonksiyonun kendisini ver,
    // çağırmayı stream yapsın" demek. (b) => _parser.parse(b) ile aynı.
    _sub = link.bytes.listen(_parser.parse);

    // Parser byte'ları biriktirir. Bir MAVLink mesajı tamamlanınca
    // (başlık + içerik + kontrol toplamı doğruysa) frames yayınına koyar.
    // Bir UDP paketi yarım mesaj da getirebilir, iki mesaj da. Parser bunu halleder.
  }

  void stop() => _sub?.cancel(); // aboneliği iptal et

  // 2. haftada buraya send(...) eklenecek: mesajı byte'a çevirip link.send ile yollayacak.
}

// ÖZET: byte (Uint8List) -> parser -> MavlinkFrame.
// MavlinkFrame içinde: kimden geldi (systemId, componentId) + mesajın kendisi (message).
