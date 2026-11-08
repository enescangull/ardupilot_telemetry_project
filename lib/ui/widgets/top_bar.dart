import 'package:ardupilot_telemetry_project/vehicle/flight_mode.dart';
import 'package:ardupilot_telemetry_project/vehicle/telemetry.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final Telemetry t;
  const TopBar({super.key, required this.t});

  Widget _chip(
    String label,
    Color textColor,
    Color backgroundColor,
    Color borderColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF161B22),
        border: Border(bottom: BorderSide(color: Color(0xFF262C36), width: 1)),
      ),
      child: Row(
        children: [
          Icon(Icons.flight, color: Colors.white),

          SizedBox(width: 10),
          Text(
            'GCS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10),
          Text(
            'ArduPilot · SITL',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          Spacer(),
          _chip(
            t.connected ? 'CONNECTED' : 'DISCONNECTED',
            t.connected ? Color(0xFF34D399) : Color(0xFFF87171),
            t.connected ? Color(0xFF0F2A22) : Color(0xFF2A1215),
            t.connected ? Color(0xFF1F5C47) : Color(0xFF5C1F24),
          ),
          SizedBox(width: 10),
          _chip(
            flightModeName(t.customMode),
            Color(0xFF7DD3FC),
            Color(0xFF0C2433),
            Color(0xFF1E4A66),
          ),
          SizedBox(width: 10),
          _chip(
            t.armed ? 'ARMED' : 'DISARMED',
            t.armed ? Color(0xFFFBBF24) : Color(0xFF9BA7B4),
            t.armed ? Color(0xFF3A2410) : Color(0xFF1C2129),
            t.armed ? Color(0xFF7A4A14) : Color(0xFF262C36),
          ),
          SizedBox(width: 10),
          _chip(
            t.batteryV == null
                ? 'N/A'
                : '${t.batteryV!.toStringAsFixed(2)} V (${t.batteryPct ?? 'N/A'}%)',
            Color(0xFF7DD3FC),
            Color(0xFF0C2433),
            Color(0xFF1E4A66),
          ),
        ],
      ),
    );
  }
}
