import 'package:ardupilot_telemetry_project/link/udp_link.dart';
import 'package:ardupilot_telemetry_project/mavlink/mavlink_codec.dart';
import 'package:ardupilot_telemetry_project/ui/home_screen.dart';
import 'package:ardupilot_telemetry_project/vehicle/vehicle.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Katmanlar build() içinde değil, bir kez burada kurulur.
  final udpLink = UDPLink(port: 14550);
  final codec = MavlinkCodec(udpLink);
  final vehicle = Vehicle(codec);
  codec.start(); // link.bytes -> parser bağlantısı
  await udpLink.open();

  runApp(MyApp(vehicle: vehicle));
}

class MyApp extends StatelessWidget {
  final Vehicle vehicle;
  const MyApp({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UDP Listener',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(vehicle: vehicle),
    );
  }
}
