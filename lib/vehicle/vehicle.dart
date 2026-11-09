// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:ardupilot_telemetry_project/mavlink/mavlink_codec.dart';
import 'package:ardupilot_telemetry_project/vehicle/telemetry.dart';
import 'package:dart_mavlink/dialects/ardupilotmega.dart';
import 'package:dart_mavlink/mavlink_frame.dart';
import 'package:flutter/material.dart';

class Vehicle {
  final MavlinkCodec codec;

  final telemetry = ValueNotifier<Telemetry>(const Telemetry());

  StreamSubscription? _sub;
  Vehicle(this.codec) {
    _sub = codec.frames.listen(_onFrame);
  }

  void arm() {
    final msg = CommandLong(
      param1: 1,
      param2: 0,
      param3: 0,
      param4: 0,
      param5: 0,
      param6: 0,
      param7: 0,
      command: mavCmdComponentArmDisarm,
      targetSystem: 1,
      targetComponent: 1,
      confirmation: 0,
    );
    codec.send(msg);
  }

  void disarm() {
    final msg = CommandLong(
      param1: 0,
      param2: 0,
      param3: 0,
      param4: 0,
      param5: 0,
      param6: 0,
      param7: 0,
      command: mavCmdComponentArmDisarm,
      targetSystem: 1,
      targetComponent: 1,
      confirmation: 0,
    );
    codec.send(msg);
  }

  void _onFrame(MavlinkFrame frame) {
    if (frame.systemId != 1 || frame.componentId != 1) return;
    final t = telemetry.value;
    final msg = frame.message;

    switch (msg) {
      case Heartbeat m:
        telemetry.value = t.copyWith(
          armed: m.baseMode & mavModeFlagSafetyArmed != 0,
          customMode: m.customMode,
          lastHeartbeat: DateTime.now(),
        );
      case GlobalPositionInt m:
        telemetry.value = t.copyWith(
          lat: m.lat / 1e7,
          lon: m.lon / 1e7,

          relAltM: m.relativeAlt / 1000,
          headingDeg: m.hdg == 65535
              ? null
              : (m.hdg > 35999 ? null : m.hdg / 100),
        );
      case Attitude m:
        telemetry.value = t.copyWith(
          rollDeg: m.roll * 180 / pi,
          pitchDeg: m.pitch * 180 / pi,
        );
      case SysStatus m:
        telemetry.value = t.copyWith(
          batteryV: (m.voltageBattery / 1000),
          batteryPct: m.batteryRemaining > 100 || m.batteryRemaining < 0
              ? null
              : m.batteryRemaining,
        );
      case VfrHud m:
        telemetry.value = t.copyWith(
          groundSpeed: m.groundspeed > 100 || m.groundspeed < 0
              ? null
              : m.groundspeed,
          throttle: m.throttle > 100 ? null : m.throttle,
          climb: m.climb,
        );
      default:
        break;
    }
  }

  void dispose() {
    _sub?.cancel();
    telemetry.dispose();
  }
}
