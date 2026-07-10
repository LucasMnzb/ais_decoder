import '../../../ais_decoder.dart';
import '../../utils/binary_conversion.dart';
import '../../utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Types 1, 2, and 3 — Class A Position Report.
///
/// The most common AIS message, transmitted by Class A transponders
/// (mandatory on SOLAS vessels). Types 1–3 share an identical field layout;
/// the type number only differs by the TDMA access scheme used (scheduled,
/// assigned, or special).
///
/// Position coordinates are `null` when the encoded value is the standard
/// "not available" sentinel. The same applies to [speedOverGround],
/// [courseOverGround], and [heading].
class PositionMessage extends AISMessage {
  /// Human-readable navigation status string (e.g. "Under way using engine",
  /// "At anchor"). Empty string if the raw value has no defined description.
  final String navigationStatus;

  /// Latitude in decimal degrees (positive north), or `null` when not
  /// available (encoded as 91° × 10⁴).
  final double? latitude;

  /// Longitude in decimal degrees (positive east), or `null` when not
  /// available (encoded as 181° × 10⁴).
  final double? longitude;

  /// Speed Over Ground in knots (0.0–102.2), or `null` when not available
  /// (encoded value ≥ 1023).
  final double? speedOverGround;

  /// Course Over Ground in degrees (0.0–359.9), or `null` when not available
  /// (encoded value ≥ 3600).
  final double? courseOverGround;

  /// Human-readable maneuver indicator string (e.g. "No special maneuver",
  /// "Special maneuver"). Empty string if the raw value is undefined.
  final String maneuverIndicator;

  /// Rate of Turn in degrees per minute. Positive = turning right,
  /// negative = turning left. Special sentinel values (−128.0, 0.0, 127.0)
  /// indicate no turn information or maximum turn rate.
  final double rateOfTurn;

  /// True heading in degrees (0–359), or `null` when not available
  /// (encoded value = 511).
  final double? heading;

  /// UTC second at which the position fix was taken (0–59). Values 60–63
  /// carry special meaning (e.g. 61 = manual input, 63 = positioning system
  /// inoperative).
  final int timestamp;

  /// Receiver Autonomous Integrity Monitoring (RAIM) flag.
  /// `1` = RAIM in use, `0` = RAIM not in use.
  final int raimEnabled;

  /// Creates a [PositionMessage] with all fields supplied explicitly.
  ///
  /// Prefer [PositionMessage.fromEncoded] for decoding a real AIS payload.
  PositionMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.navigationStatus,
    required this.latitude,
    required this.longitude,
    required this.speedOverGround,
    required this.courseOverGround,
    required this.maneuverIndicator,
    required this.rateOfTurn,
    required this.heading,
    required this.timestamp,
    required this.raimEnabled,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;   // cheap shortcut: same object, definitely equal
    return other is PositionMessage &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        navigationStatus == other.navigationStatus &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        speedOverGround == other.speedOverGround &&
        courseOverGround == other.courseOverGround &&
        maneuverIndicator == other.maneuverIndicator &&
        rateOfTurn == other.rateOfTurn &&
        heading == other.heading &&
        timestamp == other.timestamp &&
        raimEnabled == other.raimEnabled;
  }

  @override
  int get hashCode => Object.hash(
    messageType, mmsi, repeatIndicator, navigationStatus,
    latitude, longitude, speedOverGround, courseOverGround,
    maneuverIndicator, rateOfTurn, heading, timestamp, raimEnabled,
  );

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Status: $navigationStatus, Lat: $latitude, Lon: $longitude, SOG: $speedOverGround, COG: $courseOverGround, Maneuver: $maneuverIndicator, ROT: $rateOfTurn, Heading: $heading, Timestamp: $timestamp, RAIM: $raimEnabled)';
  //endregion

  /// Decodes a pre-converted binary string into a [PositionMessage].
  ///
  /// **Deprecated.** Use [PositionMessage.fromEncoded] instead. This factory
  /// operates on a fully expanded binary string (one character per bit) which
  /// is significantly slower than the direct bit-extraction path used by
  /// [fromEncoded].
  @Deprecated("Legacy Code use .fromEncoded instead for performance reasons")
  factory PositionMessage.fromBinary(String binary) {
    // common
    int messageType = int.parse(binary.substring(0, 6), radix: 2);
    int repeatIndicator = int.parse(binary.substring(6, 8), radix: 2);
    int mmsi = int.parse(binary.substring(8, 38), radix: 2);

    // binary ranges specific to type 1-3
    String navigationStatusBin = binary.substring(38, 42);
    String rateOfTurnBin = binary.substring(42, 50);
    String speedBin = binary.substring(50, 60);
    String longitudeBin = binary.substring(61, 89); // Type 1-3 position
    String latitudeBin = binary.substring(89, 116); // Type 1-3 position
    String courseBin = binary.substring(116, 128);
    String headingBin = binary.substring(128, 137);
    String maneuverIndicatorBin = binary.substring(143, 145);
    String timestampBin = binary.substring(137, 143);
    String raimEnabledBin = binary.substring(148, 149);

    // conversion to actually readable data
    String? navigationStatus = BinaryConverter().navigationStatusInfo(navigationStatusBin);
    double? longitude = CoordinateUtils().calculateLongitude(longitudeBin);
    double? latitude = CoordinateUtils().calculateLatitude(latitudeBin);
    String? maneuverIndicator = BinaryConverter().maneuverIndicatorInfo(maneuverIndicatorBin);
    int speedDecoded = int.parse(speedBin, radix: 2);
    double? speed = 0 <= speedDecoded && speedDecoded <= 1022 ? speedDecoded / 10.0 : null;
    int courseDecoded = int.parse(courseBin, radix: 2);
    double? course = 0 <= courseDecoded && courseDecoded < 3600 ? courseDecoded / 10.0 : null;
    double rateOfTurn = BinaryConverter().getRateOfTurn(rateOfTurnBin);
    int headingDecoded = int.parse(headingBin, radix: 2);
    double? heading = 0 <= headingDecoded && headingDecoded < 360 ? headingDecoded.toDouble() : null;
    int timestamp = int.parse(timestampBin, radix: 2);
    int raimEnabled = int.parse(raimEnabledBin, radix: 2);

    return PositionMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      navigationStatus: navigationStatus ?? '',
      latitude: latitude,
      longitude: longitude,
      speedOverGround: speed,
      courseOverGround: course,
      maneuverIndicator: maneuverIndicator ?? '',
      heading: heading,
      rateOfTurn: rateOfTurn,
      timestamp: timestamp,
      raimEnabled: raimEnabled,
    );
  }

  /// Decodes a six-bit-armored AIS payload string into a [PositionMessage].
  ///
  /// [encoded] must be the payload field of a Type 1, 2, or 3 NMEA sentence.
  /// Bit extraction is performed directly on the encoded characters without
  /// first expanding to a binary string, making this significantly faster than
  /// the deprecated [PositionMessage.fromBinary].
  factory PositionMessage.fromEncoded(String encoded) {
    int messageType = getUintDirect(encoded, 0, 6);
    int repeatIndicator = getUintDirect(encoded, 6, 8);
    int mmsi = getUintDirect(encoded, 8, 38);
    int navigationStatusRaw = getUintDirect(encoded, 38, 42);
    int rateOfTurnRaw = getUintDirect(encoded, 42, 50);
    int speedRaw = getUintDirect(encoded, 50, 60);
    int longitudeRaw = getSignedIntDirect(encoded, 61, 89);
    int latitudeRaw = getSignedIntDirect(encoded, 89, 116);
    int courseRaw = getUintDirect(encoded, 116, 128);
    int headingRaw = getUintDirect(encoded, 128, 137);
    int timestampRaw = getUintDirect(encoded, 137, 143);
    int maneuverIndicatorRaw = getUintDirect(encoded, 143, 145);
    int raimEnabledRaw = getUintDirect(encoded, 148, 149);
    
    return PositionMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      navigationStatus: BinaryConverter().navigationStatusInfoDirect(navigationStatusRaw) ?? '',
      latitude: CoordinateUtils().calculateLatitudeDirect(latitudeRaw, 27),
      longitude: CoordinateUtils().calculateLongitudeDirect(longitudeRaw, 28),
      speedOverGround: 0 <= speedRaw && speedRaw <= 1022 ? speedRaw / 10.0 : null,
      courseOverGround: 0 <= courseRaw && courseRaw < 3600 ? courseRaw / 10.0 : null,
      maneuverIndicator: BinaryConverter().maneuverIndicatorInfoDirect(maneuverIndicatorRaw) ?? '',
      heading: 0 <= headingRaw && headingRaw < 360 ? headingRaw.toDouble() : null,
      rateOfTurn: BinaryConverter().getRateOfTurnDirect(rateOfTurnRaw),
      timestamp: timestampRaw,
      raimEnabled: raimEnabledRaw,
    );
  }
}