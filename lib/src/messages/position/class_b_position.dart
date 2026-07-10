import '../../../ais_decoder.dart';
import '../../utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

class StandardClassBCSPositionReport extends AISMessage {

  final double? latitude;
  final double? longitude;
  final double? speedOverGround;
  final double? courseOverGround;
  final double? heading;
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

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StandardClassBCSPositionReport &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        heading == other.heading &&
        positionAccuracy == other.positionAccuracy &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        speedOverGround == other.speedOverGround &&
        courseOverGround == other.courseOverGround &&
        raimFlag == other.raimFlag &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    heading,
    positionAccuracy,
    latitude,
    longitude,
    speedOverGround,
    courseOverGround,
    raimFlag,
    timestamp
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Heading: $heading, Accuracy: $positionAccuracy, Lat: $latitude, Lon: $longitude, COG: $courseOverGround, RAIM: $raimFlag, SOG: $speedOverGround, Timestamp: $timestamp)';
  //endregion

  @Deprecated("Legacy Code use .fromEncoded instead for performance reasons")
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
    int headingDecoded = int.parse(headingBin, radix: 2);
    double? heading = 0 <= headingDecoded && headingDecoded < 360 ? headingDecoded.toDouble() : null;
    int positionAccuracy = int.parse(positionAccuracyBin, radix: 2);
    int raimFlag = int.parse(raimFlagBin, radix: 2);
    double? longitude = CoordinateUtils().calculateLongitude(longitudeBin);
    double? latitude = CoordinateUtils().calculateLatitude(latitudeBin);
    int speedDecoded = int.parse(speedBin, radix: 2);
    double? speed = 0 <= speedDecoded && speedDecoded <= 1022 ? speedDecoded / 10.0 : null;
    int courseDecoded = int.parse(courseBin, radix: 2);
    double? course = 0 <= courseDecoded && courseDecoded < 3600 ? courseDecoded / 10.0 : null;
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

  //ToDo (medium priority): Needs to be actually finished for full 100% completion - currently most important values
  factory StandardClassBCSPositionReport.fromEncoded(String encoded) {
    String binary = encoded.padRight(168, '0');

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // binary ranges specific for type 18 Class B Position Report
    int headingBin = getUintDirect(binary, 124, 133);
    int positionAccuracy = getUintDirect(binary, 56, 57);
    int longitudeBin = getSignedIntDirect(binary, 57, 85);
    int latitudeBin = getSignedIntDirect(binary, 85, 112);
    int courseBin = getUintDirect(binary, 112, 124);
    int raimFlag = getUintDirect(binary, 147, 148);
    int speedBin = getUintDirect(binary, 46, 56);
    int timestamp = getUintDirect(binary, 133, 139);

    // conversion to actually readable data
    double? heading = 0 <= headingBin && headingBin < 360 ? headingBin.toDouble() : null;
    double? longitude = CoordinateUtils().calculateLongitudeDirect(longitudeBin, 28);
    double? latitude = CoordinateUtils().calculateLatitudeDirect(latitudeBin, 27);
    double? speed = 0 <= speedBin && speedBin <= 1022 ? speedBin / 10.0 : null;
    double? course = 0 <= courseBin && courseBin < 3600 ? courseBin / 10.0 : null;

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