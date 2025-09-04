import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/coordinate_utils.dart';


// ToDo: Implement missing 9 possibly sent data points!
class StandardClassBCSPositionReport extends AISMessage {

  final double? latitude;
  final double? longitude;
  final double speedOverGround;
  final double courseOverGround;
  final double heading;
  final int timestamp;
  final int positionAccuracy;
  final int raimFlag;

  StandardClassBCSPositionReport({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.heading,
    required this.positionAccuracy,
    required this.longitude,
    required this.latitude,
    required this.courseOverGround,
    required this.raimFlag,
    required this.speedOverGround,
    required this.timestamp,
  });

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Heading: $heading, Accuracy: $positionAccuracy, Lat: $latitude, Lon: $longitude, COG: $courseOverGround, RAIM: $raimFlag, SOG: $speedOverGround, Timestamp: $timestamp)';

  factory StandardClassBCSPositionReport.fromBinary(String binary) {
    // common
    int messageType = int.parse(binary.substring(0, 6), radix: 2);
    int repeatIndicator = int.parse(binary.substring(6, 8), radix: 2);
    int mmsi = int.parse(binary.substring(8, 38), radix: 2);

    // binary ranges specific for type 18 Class B Position Report
    String headingBin = binary.substring(124, 133);
    String positionAccuracyBin = binary.substring(56, 57);
    String longitudeBin = binary.substring(57, 85);
    String latitudeBin = binary.substring(85, 112);
    String courseBin = binary.substring(112, 124);
    String raimFlagBin = binary.substring(147, 148);
    String speedBin = binary.substring(46, 56);
    String timestampBin = binary.substring(133, 139);

    // conversion to actually readable data
    double heading = int.parse(headingBin, radix: 2).toDouble();
    int positionAccuracy = int.parse(positionAccuracyBin, radix: 2);
    int raimFlag = int.parse(raimFlagBin, radix: 2);
    double? longitude = CoordinateUtils().calculateLongitude(longitudeBin);
    double? latitude = CoordinateUtils().calculateLatitude(latitudeBin);
    double speed = int.parse(speedBin, radix: 2) / 10.0;
    double course = int.parse(courseBin, radix: 2) / 10.0;
    int timestamp = int.parse(timestampBin, radix: 2);

    return StandardClassBCSPositionReport(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      heading: heading,
      positionAccuracy: positionAccuracy,
      longitude: longitude,
      latitude: latitude,
      courseOverGround: course,
      raimFlag: raimFlag,
      speedOverGround: speed,
      timestamp: timestamp,
    );
  }
}