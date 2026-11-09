# ArduPilot Telemetry

A Flutter ground control app that receives MAVLink telemetry from an ArduPilot vehicle (or SITL simulator) over UDP, shows it on a live map dashboard, and sends basic commands back.

## Features

- **Live map**: vehicle position and heading on OpenStreetMap, with a follow-vehicle toggle
- **Top bar**: connection status (heartbeat within 5 s), flight mode, armed state, battery voltage/percentage, GPS fix and satellite count
- **Stat tiles**: relative altitude, ground speed, heading, climb rate, throttle and battery current
- **Commands**: ARM / DISARM via `MAV_CMD_COMPONENT_ARM_DISARM`
- **Message log**: timestamped flight mode changes, `COMMAND_ACK` results and `STATUSTEXT` messages (latest 20 kept)

## Architecture

Data flows one way through four layers, each depending only on the layer below it:

```
UDPLink  →  MavlinkCodec  →  Vehicle  →  UI
(bytes)     (frames)         (Telemetry)  (widgets)
```

| Layer | File | Responsibility |
|---|---|---|
| Link | `lib/link/udp_link.dart` | Binds a UDP socket, streams raw bytes, replies to the last sender |
| Codec | `lib/mavlink/mavlink_codec.dart` | Parses bytes into MAVLink frames (ArduPilotMega dialect), serializes outgoing messages as MAVLink v2 |
| Vehicle | `lib/vehicle/` | Turns frames into an immutable `Telemetry` snapshot exposed as a `ValueNotifier`; sends commands |
| UI | `lib/ui/` | Rebuilds from `Vehicle.telemetry` with `ValueListenableBuilder` |

Handled MAVLink messages: `HEARTBEAT`, `GLOBAL_POSITION_INT`, `ATTITUDE`, `SYS_STATUS`, `VFR_HUD`, `GPS_RAW_INT`, `STATUSTEXT`, `COMMAND_ACK`. Only frames from system 1 / component 1 are processed. Outgoing frames use system ID 255, component ID 190.

## Requirements

- Flutter SDK (Dart `^3.13.3`)
- macOS 14.0 or later (the only platform currently configured)
- An ArduPilot vehicle or [SITL](https://ardupilot.org/dev/docs/sitl-simulator-software-in-the-loop.html) sending MAVLink to UDP port **14550**

## Getting Started

```bash
flutter pub get
flutter run -d macos
```

Start SITL and forward MAVLink to the app:

```bash
sim_vehicle.py -v ArduCopter --console --map --out=udp:127.0.0.1:14550
```

The top bar switches to **CONNECTED** once heartbeats arrive. The map appears after the first GPS position.

## Project Structure

```
lib/
├── main.dart              # Wires link → codec → vehicle and starts the app
├── link/udp_link.dart
├── mavlink/mavlink_codec.dart
├── vehicle/
│   ├── vehicle.dart       # Frame handling and commands
│   ├── telemetry.dart     # Immutable telemetry state
│   └── enums.dart         # FlightMode, GpsFix, Severity
└── ui/
    ├── home_screen.dart
    ├── map_view.dart
    ├── message_log.dart
    ├── control_panel.dart # WIP
    └── widgets/           # TopBar, StatTile, FlightHorizon (WIP)
```

## Roadmap

- Control panel and flight horizon widgets (scaffolded, not wired in yet)
- Flight mode switching and takeoff/land commands
- Distance-to-home tile
