import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 9 — SAR Aircraft Position Report.
///
/// Transmitted by Search and Rescue (SAR) aircraft equipped with an AIS
/// transponder. The layout mirrors the Class A position report but replaces
/// navigation status, rate of turn, and maneuver indicator with an [altitude]
/// field. Speed is reported as an integer in knots rather than tenths-of-knot.
///
/// Position coordinates are `null` when the encoded value is the standard
/// "not available" sentinel. [altitude] and [speedOverGround] are similarly
/// `null` when their encoded sentinel values are detected.
class SarAircraftPositionReport extends AISMessage {
  /// Reserved spare bits (bits 143–145). Should be zero.
  final int spare;

  /// Altitude in metres (0–4 094), or `null` when not available
  /// (encoded value = 4095). Altitude 4 094 means ≥ 4 094 m.
  final int? altitude;

  /// Speed Over Ground in knots (0–1 022), or `null` when not available
  /// (encoded value = 1023).
  final int? speedOverGround;

  /// Position accuracy flag. `1` = high accuracy (< 10 m, DGPS-quality);
  /// `0` = low accuracy (> 10 m).
  final int positionAccuracy;

  /// Longitude in decimal degrees (positive east), or `null` when not
  /// available (encoded as 181° × 10⁴).
  final double? longitude;

  /// Latitude in decimal degrees (positive north), or `null` when not
  /// available (encoded as 91° × 10⁴).
  final double? latitude;

  /// Course Over Ground in degrees (0.0–359.9), or `null` when not available
  /// (encoded value ≥ 3600).
  final double? courseOverGround;

  /// UTC second at which the position fix was taken (0–59). Values 60–63
  /// carry special meaning (e.g. 61 = manual input, 63 = inoperative).
  final int timestamp;

  /// Regional reserved field (bits 134–141). Interpretation is
  /// region-specific and is stored as a raw integer without further decoding.
  final int regionalReserved;

  /// Data Terminal Equipment (DTE) readiness flag.
  /// `0` = DTE available (ready), `1` = DTE not available (default).
  final int dte;

  /// Assigned mode flag. `0` = autonomous; `1` = assigned by a base station.
  final int assignedMode;

  /// Receiver Autonomous Integrity Monitoring (RAIM) flag.
  /// `1` = RAIM in use, `0` = RAIM not in use.
  final int raimEnabled;

  /// 20-bit radio status word (bits 148–167), encoding SOTDMA/ITDMA
  /// communication state.
  final int radio;

  /// Creates a [SarAircraftPositionReport] with all fields supplied explicitly.
  ///
  /// Prefer [SarAircraftPositionReport.fromEncoded] for decoding a real AIS payload.
  SarAircraftPositionReport({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.altitude,
    required this.speedOverGround,
    required this.positionAccuracy,
    required this.longitude,
    required this.latitude,
    required this.courseOverGround,
    required this.timestamp,
    required this.regionalReserved,
    required this.dte,
    required this.assignedMode,
    required this.raimEnabled,
    required this.radio,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SarAircraftPositionReport &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        spare == other.spare &&
        altitude == other.altitude &&
        speedOverGround == other.speedOverGround &&
        positionAccuracy == other.positionAccuracy &&
        longitude == other.longitude &&
        latitude == other.latitude &&
        courseOverGround == other.courseOverGround &&
        timestamp == other.timestamp &&
        regionalReserved == other.regionalReserved &&
        dte == other.dte &&
        assignedMode == other.assignedMode &&
        raimEnabled == other.raimEnabled &&
        radio == other.radio;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    spare,
    altitude,
    speedOverGround,
    positionAccuracy,
    longitude,
    latitude,
    courseOverGround,
    timestamp,
    regionalReserved,
    dte,
    assignedMode,
    raimEnabled,
    radio,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Spare: $spare, Altitude: $altitude, SOG: $speedOverGround, Accuracy: $positionAccuracy, Lon: $longitude, Lat: $latitude, COG: $courseOverGround, Timestamp: $timestamp, Regional: $regionalReserved, DTE: $dte, Mode: $assignedMode, RAIM: $raimEnabled, Radio: $radio)';
  //endregion

  /// Decodes a six-bit-armored AIS payload string into a
  /// [SarAircraftPositionReport].
  ///
  /// [encoded] must be the payload field of a Type 9 NMEA sentence. The
  /// string is zero-padded to 168 bits before parsing. [altitude] is set to
  /// `null` when the encoded value is 4095, and [speedOverGround] is set to
  /// `null` when the encoded value is 1023.
  factory SarAircraftPositionReport.fromEncoded(String encoded) {
    String binary = encoded.padRight(168, '0');

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type 9 specific
    int spare = getUintDirect(binary, 143, 146);
    int altitude = getUintDirect(binary, 38, 50); // in meters - 4095 indicates null
    int speed = getUintDirect(binary, 50, 60); // in knots - 1023 indicates null
    int positionAccuracy = getUintDirect(binary, 60, 61);
    int longitude = getSignedIntDirect(binary, 61, 89);
    int latitude = getSignedIntDirect(binary, 89, 116);
    int course = getUintDirect(binary, 116, 128);
    int timestamp = getUintDirect(binary, 128, 137);
    int regionalReserved = getUintDirect(binary, 134, 142);
    int dte = getUintDirect(binary, 142, 143);
    int assignedMode = getUintDirect(binary, 146, 147);
    int raimEnabled = getUintDirect(binary, 147, 148);
    int radio = getUintDirect(binary, 148, 168);



    return SarAircraftPositionReport(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare, 
      altitude: 0 <= altitude && altitude <= 4095 ? altitude : null, 
      speedOverGround: 0 <= speed && speed <= 1023 ? speed : null,
      positionAccuracy: positionAccuracy, 
      longitude: CoordinateUtils().calculateLongitudeDirect(longitude, 28), 
      latitude: CoordinateUtils().calculateLatitudeDirect(latitude, 27), 
      courseOverGround: 0 <= course && course < 3600 ? course / 10.0 : null, 
      timestamp: timestamp, 
      regionalReserved: regionalReserved, 
      dte: dte, 
      assignedMode: assignedMode, 
      raimEnabled: raimEnabled, 
      radio: radio,
    );
  }
}