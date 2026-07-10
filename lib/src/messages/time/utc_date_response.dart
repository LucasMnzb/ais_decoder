import '../../../ais_decoder.dart';
import '../../utils/binary_conversion.dart';
import '../../utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

class UtcDateResponse extends AISMessage {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;
  final int accuracy;
  final double? longitude;
  final double? latitude;
  final String epfdFixType;
  final int spare;
  final int raim;
  final int sotdmaState;

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