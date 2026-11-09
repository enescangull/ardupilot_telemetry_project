import 'package:flutter/material.dart';

enum FlightMode {
  stabilize(0, 'STABILIZE'),
  altHold(2, 'ALT_HOLD'),
  auto(3, 'AUTO'),
  guided(4, 'GUIDED'),
  loiter(5, 'LOITER'),
  rtl(6, 'RTL'),
  circle(7, 'CIRCLE'),
  land(9, 'LAND');

  final int id;
  final String label;
  const FlightMode(this.id, this.label);
  static FlightMode? fromId(int id) =>
      values.where((m) => m.id == id).firstOrNull;
}

enum GpsFix {
  noGps(0, 'NO GPS'),
  noFix(1, 'NO FIX'),
  twoD(2, '2D'),
  threeD(3, '3D'),
  dgps(4, 'DGPS'),
  rtkFloat(5, 'RTK FLOAT'),
  rtk(6, 'RTK');

  final int id;
  final String label;
  const GpsFix(this.id, this.label);
  Color get color {
    if (id >= 3) return const Color(0xFF34D399); // 3D ve üstü: yeşil
    if (id == 2) return const Color(0xFFFBBF24); // 2D: sarı
    return Colors.red; // fix yok
  }

  static GpsFix? fromId(int id) => values.where((g) => g.id == id).firstOrNull;
}

enum Severity {
  emergency(0, 'EMERGENCY'),
  alert(1, 'ALERT'),
  critical(2, 'CRITICAL'),
  error(3, 'ERROR'),
  warning(4, 'WARNING'),
  notice(5, 'NOTICE'),
  info(6, 'INFO'),
  debug(7, 'DEBUG');

  final int id;
  final String label;
  const Severity(this.id, this.label);

  static Severity? fromId(int id) =>
      values.where((s) => s.id == id).firstOrNull;
}
