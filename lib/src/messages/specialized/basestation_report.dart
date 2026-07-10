import '../../../ais_decoder.dart';
import '../../utils/binary_conversion.dart';
import '../../utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 4 — Base Station Report.
///
/// Broadcast by a fixed base station to distribute UTC time and date, and to
/// report the station's own position. Receivers use this message to
/// synchronise their TDMA timing. Also serves as Message Type 11
/// (UTC/Date Response) when sent in reply to a UTC/Date Inquiry (Type 10).
///
/// The position coordinates are `null` when the encoded value is the standard
/// "not available" sentinel.
class BaseStationReport extends AISMessage {
  /// UTC year of the position fix (e.g. 2024). `0` = not available.
  final int year;

  /// UTC month of the position fix (1–12). `0` = not available.
  final int month;

  /// UTC day of the position fix (1–31). `0` = not available.
  final int day;

  /// UTC hour of the position fix (0–23). `24` = not available.
  final int hour;

  /// UTC minute of the position fix (0–59). `60` = not available.
  final int minute;

  /// UTC second of the position fix (0–59). `60` = not available.
  final int second;

  /// Position accuracy flag. `1` = high accuracy (< 10 m, DGPS-quality);
  /// `0` = low accuracy (> 10 m).
  final int accuracy;

  /// Longitude of the base station in decimal degrees (positive east), or
  /// `null` when not available (encoded as 181° × 10⁴).
  final double? longitude;

  /// Latitude of the base station in decimal degrees (positive north), or
  /// `null` when not available (encoded as 91° × 10⁴).
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

  /// Creates a [BaseStationReport] with all fields supplied explicitly.
  ///
  /// Prefer [BaseStationReport.fromEncoded] for decoding a real AIS payload.
  BaseStationReport({
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
    return other is BaseStationReport &&
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

  /// Decodes a pre-converted binary string into a [BaseStationReport].
  ///
  /// **Deprecated.** Use [BaseStationReport.fromEncoded] instead. This factory
  /// operates on a fully expanded binary string (one character per bit) which
  /// is significantly slower than the direct bit-extraction path used by
  /// [fromEncoded].
  @Deprecated("Legacy Code use .fromEncoded instead for performance reasons")
  factory BaseStationReport.fromBinary(String binary) {
    // common
    int messageType = int.parse(binary.substring(0, 6), radix: 2);
    int repeatIndicator = int.parse(binary.substring(6, 8), radix: 2);
    int mmsi = int.parse(binary.substring(8, 38), radix: 2);

    // binary ranges specific to type 4
    String yearBin = binary.substring(38, 52);
    String monthBin = binary.substring(52, 56);
    String dayBin = binary.substring(56, 61);
    String hourBin = binary.substring(61, 66);
    String minuteBin = binary.substring(66, 72);
    String secondBin = binary.substring(72, 78);
    String accuracyBin = binary.substring(78, 79);
    String longitudeBin = binary.substring(79, 107); // Type 4 position
    String latitudeBin = binary.substring(107, 134); // Type 4 position
    String epfdBin = binary.substring(134, 138);
    String spareBin = binary.substring(138, 148);
    String raimBin = binary.substring(148, 149);
    String radioBin = binary.substring(149, 168);

    // conversion to actually readable data
    int year = int.parse(yearBin, radix: 2);
    int month = int.parse(monthBin, radix: 2);
    int day = int.parse(dayBin, radix: 2);
    int hour = int.parse(hourBin, radix: 2);
    int minute = int.parse(minuteBin, radix: 2);
    int second = int.parse(secondBin, radix: 2);
    int accuracy = int.parse(accuracyBin, radix: 2); // as bool
    double? longitude = CoordinateUtils().calculateLongitude(longitudeBin);
    double? latitude = CoordinateUtils().calculateLatitude(latitudeBin);
    String positionFixType = BinaryConverter().getEPFDFixType(epfdBin);
    int spare = int.parse(spareBin, radix: 2);
    int raimFlag = int.parse(raimBin, radix: 2);
    int sotdmaState = int.parse(radioBin, radix: 2);

    return BaseStationReport(
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

  /// Decodes a six-bit-armored AIS payload string into a [BaseStationReport].
  ///
  /// [encoded] must be the payload field of a Type 4 (or Type 11) NMEA
  /// sentence. The string is zero-padded to 168 bits before parsing. The EPFD
  /// fix type string is resolved via [BinaryConverter].
  factory BaseStationReport.fromEncoded(String encoded) {
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
    int longitudeBin = getSignedIntDirect(binary, 79, 107); // Type 4 position
    int latitudeBin = getSignedIntDirect(binary, 107, 134); // Type 4 position
    int epfdBin = getUintDirect(binary, 134, 138);
    int spare = getUintDirect(binary, 138, 148);
    int raimFlag = getUintDirect(binary, 148, 149);
    int sotdmaState = getUintDirect(binary, 149, 168);

    //Conversion
    double? longitude = CoordinateUtils().calculateLongitudeDirect(longitudeBin, 28);
    double? latitude = CoordinateUtils().calculateLatitudeDirect(latitudeBin, 27);
    String positionFixType = BinaryConverter().getEPFDFixTypeDirect(epfdBin);


    return BaseStationReport(
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