import '../../../ais_decoder.dart';
import '../../utils/binary_conversion.dart';
import '../../utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 11 — UTC/Date Response.
///
/// Sent by a base station in direct reply to a [UtcDateInquiry] (Type 10).
/// The layout and field semantics are identical to [BaseStationReport]
/// (Type 4); the only difference is the message type number, which signals
/// that this is a solicited response rather than an autonomous broadcast.
///
/// Position coordinates are `null` when the encoded value is the standard
/// "not available" sentinel.
class UtcDateResponse extends AISMessage {
  /// UTC year of the fix (e.g. 2024). `0` = not available.
  final int year;

  /// UTC month of the fix (1–12). `0` = not available.
  final int month;

  /// UTC day of the fix (1–31). `0` = not available.
  final int day;

  /// UTC hour of the fix (0–23). `24` = not available.
  final int hour;

  /// UTC minute of the fix (0–59). `60` = not available.
  final int minute;

  /// UTC second of the fix (0–59). `60` = not available.
  final int second;

  /// Position accuracy flag. `1` = high accuracy (< 10 m, DGPS-quality);
  /// `0` = low accuracy (> 10 m).
  final int accuracy;

  /// Longitude of the responding base station in decimal degrees (positive
  /// east), or `null` when not available (encoded as 181° × 10⁴).
  final double? longitude;

  /// Latitude of the responding base station in decimal degrees (positive
  /// north), or `null` when not available (encoded as 91° × 10⁴).
  final double? latitude;

  /// Human-readable Electronic Position-Fixing Device (EPFD) fix type string
  /// (e.g. "GPS", "GLONASS", "Combined GPS/GLONASS").
  final String epfdFixType;

  /// Reserved spare bits (bits 138–147). Should be zero.
  final int spare;

  /// Receiver Autonomous Integrity Monitoring (RAIM) flag.
  /// `1` = RAIM in use, `0` = RAIM not in use.
  final int raim;

  /// 19-bit SOTDMA communication state word (bits 149–167), used for TDMA
  /// slot synchronisation by receiving stations.
  final int sotdmaState;

  /// Creates a [UtcDateResponse] with all fields supplied explicitly.
  ///
  /// Prefer [UtcDateResponse.fromEncoded] for decoding a real AIS payload.
  UtcDateResponse({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    required this.accuracy,
    required this.longitude,
    required this.latitude,
    required this.epfdFixType,
    required this.spare,
    required this.raim,
    required this.sotdmaState,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UtcDateResponse &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        year == other.year &&
        month == other.month &&
        day == other.day &&
        hour == other.hour &&
        minute == other.minute &&
        second == other.second &&
        accuracy == other.accuracy &&
        longitude == other.longitude &&
        latitude == other.latitude &&
        epfdFixType == other.epfdFixType &&
        spare == other.spare &&
        raim == other.raim &&
        sotdmaState == other.sotdmaState;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    year,
    month,
    day,
    hour,
    minute,
    second,
    accuracy,
    longitude,
    latitude,
    epfdFixType,
    spare,
    raim,
    sotdmaState,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Year: $year, Month: $month, Day: $day, Hour: $hour, Minute: $minute, Second: $second, Accuracy: $accuracy, Lat: $latitude, Lon: $longitude, EPFD: $epfdFixType, RAIM: $raim, SOTDMA: $sotdmaState)';
  //endregion


  /// Decodes a six-bit-armored AIS payload string into a [UtcDateResponse].
  ///
  /// [encoded] must be the payload field of a Type 11 NMEA sentence. The
  /// string is zero-padded to 168 bits before parsing. The EPFD fix type
  /// string is resolved via [BinaryConverter].
  factory UtcDateResponse.fromEncoded(String encoded) {
    String binary = encoded.padRight(168, '0');

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // binary ranges specific to type 4
    int year = getUintDirect(binary, 38, 52);
    int month = getUintDirect(binary, 52, 56);
    int day = getUintDirect(binary, 56, 61);
    int hour = getUintDirect(binary, 61, 66);
    int minute = getUintDirect(binary, 66, 72);
    int second = getUintDirect(binary, 72, 78);
    int accuracy = getUintDirect(binary, 78, 79);
    int longitudeBin = getSignedIntDirect(binary, 79, 107); // Type 11 position
    int latitudeBin = getSignedIntDirect(binary, 107, 134); // Type 11 position
    int epfdBin = getUintDirect(binary, 134, 138);
    int spare = getUintDirect(binary, 138, 148);
    int raimFlag = getUintDirect(binary, 148, 149);
    int sotdmaState = getUintDirect(binary, 149, 168);

    //Conversion
    double? longitude = CoordinateUtils().calculateLongitudeDirect(longitudeBin, 28);
    double? latitude = CoordinateUtils().calculateLatitudeDirect(latitudeBin, 27);
    String positionFixType = BinaryConverter().getEPFDFixTypeDirect(epfdBin);


    return UtcDateResponse(
        messageType: messageType,
        mmsi: mmsi,
        repeatIndicator: repeatIndicator,
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
        accuracy: accuracy,
        longitude: longitude,
        latitude: latitude,
        epfdFixType: positionFixType,
        spare: spare,
        raim: raimFlag,
        sotdmaState: sotdmaState
    );
  }
}