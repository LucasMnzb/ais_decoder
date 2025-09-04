import '/ais_decoder.dart';
import '/src/utils/binary_conversion.dart';
import '/src/utils/coordinate_utils.dart';

class PositionMessage extends AISMessage {
  final String navigationStatus;
  final double? latitude;
  final double? longitude;
  final double speedOverGround;
  final double courseOverGround;
  final String maneuverIndicator;
  final double rateOfTurn;
  final double heading;
  final int timestamp;
  final int raimEnabled;

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

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Status: $navigationStatus, Lat: $latitude, Lon: $longitude, SOG: $speedOverGround, COG: $courseOverGround, Maneuver: $maneuverIndicator, ROT: $rateOfTurn, Heading: $heading, Timestamp: $timestamp, RAIM: $raimEnabled)';


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
    double speed = int.parse(speedBin, radix: 2) / 10.0;
    double course = int.parse(courseBin, radix: 2) / 10.0;
    double rateOfTurn = BinaryConverter().getRateOfTurn(rateOfTurnBin);
    double heading = int.parse(headingBin, radix: 2).toDouble();
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
}