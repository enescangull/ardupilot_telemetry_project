// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:ardupilot_telemetry_project/mavlink/mavlink_codec.dart';
import 'package:ardupilot_telemetry_project/vehicle/enums.dart';
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

  void _log(String txt) {
    DateTime now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    final String time = '$hour:$minute:$second';

    final String log = '$time  $txt';
    final t = telemetry.value;

    final messages = [log, ...t.messages].take(20).toList();
    telemetry.value = t.copyWith(messages: messages);
  }

  void _onFrame(MavlinkFrame frame) {
    if (frame.systemId != 1 || frame.componentId != 1) return;
    final t = telemetry.value;
    final msg = frame.message;

    switch (msg) {
      case Heartbeat m:
        if (t.customMode != m.customMode) {
          final String modeName = FlightMode.fromId(m.customMode).toString();
          _log('Mod Changed: $modeName');
        }
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
          currentBattery: m.currentBattery == -1 || m.currentBattery < 0
              ? null
              : (m.currentBattery / 100).toInt(),
        );
      case VfrHud m:
        telemetry.value = t.copyWith(
          groundSpeed: m.groundspeed > 100 || m.groundspeed < 0
              ? null
              : m.groundspeed,
          throttle: m.throttle > 100 ? null : m.throttle,
          climb: m.climb,
        );
      case GpsRawInt m:
        telemetry.value = t.copyWith(
          fixType: m.fixType > 8 ? null : m.fixType,
          satellitesVisible:
              m.satellitesVisible == 255 || m.satellitesVisible > 50
              ? null
              : m.satellitesVisible,
        );
      case Statustext m:
        final text = String.fromCharCodes(m.text.takeWhile((c) => c != 0));
        final severity = m.severity;
        _log(
          '${Severity.fromId(severity) != null ? Severity.fromId(severity)!.label : 'UNKNOWN'} : $text',
        );

      case CommandAck m:
        final result = switch (m.result) {
          0 => 'MAV_RESULT_ACCEPTED',
          1 => 'MAV_RESULT_TEMPORARILY_REJECTED',
          2 => 'MAV_RESULT_DENIED',
          3 => 'MAV_RESULT_UNSUPPORTED',
          4 => 'MAV_RESULT_FAILED',
          5 => 'MAV_RESULT_IN_PROGRESS',
          6 => 'MAV_RESULT_CANCELLED',
          7 => 'MAV_RESULT_COMMAND_LONG_ONLY',
          8 => 'MAV_RESULT_COMMAND_INT_ONLY',
          9 => 'MAV_RESULT_COMMAND_UNSUPPORTED_MAV_FRAME',
          _ => 'kod: ${m.result}',
        };
        final command = m.command == 400 ? 'ARM/DISARM' : '${m.command}';
        _log('$command : $result');
      default:
        break;
    }
  }

  void dispose() {
    _sub?.cancel();
    telemetry.dispose();
  }
}
