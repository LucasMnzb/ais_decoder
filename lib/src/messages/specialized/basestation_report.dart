import '/ais_decoder.dart';
import '/src/utils/binary_conversion.dart';
import '/src/utils/coordinate_utils.dart';

class BaseStationReport extends AISMessage {
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

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Year: $year, Month: $month, Day: $day, Hour: $hour, Minute: $minute, Second: $second, Accuracy: $accuracy, Lat: $latitude, Lon: $longitude, EPFD: $epfdFixType, RAIM: $raim, SOTDMA: $sotdmaState)';


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
}