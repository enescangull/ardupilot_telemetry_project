class Telemetry {
  final bool armed;
  final int customMode;
  final double? lat, lon;
  final double? relAltM;
  final double? headingDeg;
  final double? rollDeg, pitchDeg;
  final double? batteryV;
  final int? batteryPct;
  final DateTime? lastHeartbeat;
  final double? groundSpeed;
  final double? climb;
  final int? throttle;
  final int? fixType;
  final int? satellitesVisible;
  final double? currentBattery;
  final List<String> messages;

  const Telemetry({
    this.armed = false,
    this.customMode = 0,
    this.lat,
    this.lon,
    this.relAltM,
    this.headingDeg,
    this.rollDeg,
    this.pitchDeg,
    this.batteryV,
    this.batteryPct,
    this.lastHeartbeat,
    this.groundSpeed,
    this.climb,
    this.throttle,
    this.fixType,
    this.satellitesVisible,
    this.currentBattery,
    this.messages = const [],
  });

  bool get connected =>
      lastHeartbeat != null &&
      DateTime.now().difference(lastHeartbeat!).inSeconds < 5;

  Telemetry copyWith({
    bool? armed,
    int? customMode,
    double? lat,
    double? lon,
    double? relAltM,
    double? headingDeg,
    double? rollDeg,
    double? pitchDeg,
    double? batteryV,
    int? batteryPct,
    DateTime? lastHeartbeat,
    double? groundSpeed,
    double? climb,
    int? throttle,
    int? fixType,
    int? satellitesVisible,
    double? currentBattery,
    List<String>? messages,
  }) => Telemetry(
    armed: armed ?? this.armed,
    customMode: customMode ?? this.customMode,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    relAltM: relAltM ?? this.relAltM,
    headingDeg: headingDeg ?? this.headingDeg,
    rollDeg: rollDeg ?? this.rollDeg,
    pitchDeg: pitchDeg ?? this.pitchDeg,
    batteryV: batteryV ?? this.batteryV,
    batteryPct: batteryPct ?? this.batteryPct,
    lastHeartbeat: lastHeartbeat ?? this.lastHeartbeat,
    groundSpeed: groundSpeed ?? this.groundSpeed,
    climb: climb ?? this.climb,
    throttle: throttle ?? this.throttle,
    fixType: fixType ?? this.fixType,
    satellitesVisible: satellitesVisible ?? this.satellitesVisible,
    currentBattery: currentBattery ?? this.currentBattery,
    messages: messages ?? this.messages,
  );
}
