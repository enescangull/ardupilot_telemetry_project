import 'package:ardupilot_telemetry_project/ui/map_view.dart';
import 'package:ardupilot_telemetry_project/ui/widgets/stat_tile.dart';
import 'package:ardupilot_telemetry_project/ui/widgets/top_bar.dart';
import 'package:ardupilot_telemetry_project/vehicle/vehicle.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Vehicle vehicle;
  const HomeScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: vehicle.telemetry,
        builder: (context, telemetry, _) {
          return Column(
            children: [
              TopBar(t: telemetry),
              Expanded(
                child: Stack(
                  children: [
                    telemetry.lat == null
                        ? Center(
                            child: Container(
                              color: Color(0xFF0B1F1A),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.gps_fixed, size: 240),
                                    Text(
                                      'GPS Bekleniyor',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : MapView(
                            latitude: telemetry.lat ?? 0,
                            longitude: telemetry.lon ?? 0,
                            heading: telemetry.headingDeg ?? 0,
                          ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Wrap(
                        children: [
                          StatTile(
                            label: 'İrtifa',
                            value: telemetry.relAltM?.toStringAsFixed(1) ?? '-',
                            unit: 'm',
                          ),

                          SizedBox(width: 10),
                          StatTile(label: 'Yer Hızı', value: '-', unit: 'km/h'),

                          SizedBox(width: 10),
                          StatTile(
                            label: 'Yön',
                            value:
                                telemetry.headingDeg?.toStringAsFixed(0) ?? '-',
                            unit: '°',
                          ),

                          SizedBox(width: 10),
                          StatTile(label: 'Eve Uzaklık', value: "-", unit: 'm'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
