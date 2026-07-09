import '../../../ais_decoder.dart';
import '../../utils/binary_conversion.dart';
import '../../utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

class LongRangeAISBroadcastMessage extends AISMessage {
  final int raimEnabled;
  final String navigationStatus;
  final double? longitude;
  final double? latitude;
  final double speedOverGround;
  final double courseOverGround;
  final int gnssPositionStatus;
  final int spare;


  LongRangeAISBroadcastMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.raimEnabled,
    required this.navigationStatus,
    required this.latitude,
    required this.longitude,
    required this.speedOverGround,
    required this.courseOverGround,
    required this.gnssPositionStatus,
    required this.spare,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LongRangeAISBroadcastMessage &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        raimEnabled == other.raimEnabled &&
        navigationStatus == other.navigationStatus &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        speedOverGround == other.speedOverGround &&
        courseOverGround == other.courseOverGround &&
        gnssPositionStatus == other.gnssPositionStatus &&
        spare == other.spare;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    raimEnabled,
    navigationStatus,
    latitude,
    longitude,
    speedOverGround,
    courseOverGround,
    gnssPositionStatus,
    spare,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, RAIM: $raimEnabled, Status: $navigationStatus, Lat: $latitude, Lon: $longitude, SOG: $speedOverGround, COG: $courseOverGround, GNSS: $gnssPositionStatus, Spare: $spare)';
  //endregion

  @Deprecated("Legacy Code use .fromEncoded instead for performance reasons")
  factory LongRangeAISBroadcastMessage.fromBinary(String binary) {
    // common
    int messageType = int.parse(binary.substring(0, 6), radix: 2);
    int repeatIndicator = int.parse(binary.substring(6, 8), radix: 2);
    int mmsi = int.parse(binary.substring(8, 38), radix: 2);

    // binary ranges specific to type 27
    String raimEnabledBin = binary.substring(39, 40);
    String navigationStatusBin = binary.substring(40, 44);
    String longitudeBin = binary.substring(44, 62); // Type 27 position
    String latitudeBin = binary.substring(62, 79); // Type 27 position
    String speedBin = binary.substring(79, 85);
    String courseBin = binary.substring(85, 94);
    String gnssBin = binary.substring(94, 95);
    String spareBin = binary.substring(95, 96);

    // conversion to actually readable data
    int raimEnabled = int.parse(raimEnabledBin, radix: 2);
    String? navigationStatus = BinaryConverter().navigationStatusInfo(navigationStatusBin);
    double? longitude = CoordinateUtils().calculateLongitude(longitudeBin);
    double? latitude = CoordinateUtils().calculateLatitude(latitudeBin);
    double speed = int.parse(speedBin, radix: 2) / 10.0;
    double course = int.parse(courseBin, radix: 2) / 10.0;
    int gnssStatus = int.parse(gnssBin, radix: 2);
    int spare = int.parse(spareBin, radix: 2);


    return LongRangeAISBroadcastMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      navigationStatus: navigationStatus ?? '',
      latitude: latitude,
      longitude: longitude,
      speedOverGround: speed,
      courseOverGround: course,
      raimEnabled: raimEnabled,
      gnssPositionStatus: gnssStatus,
      spare: spare,
    );
  }

  factory LongRangeAISBroadcastMessage.fromEncoded(String encoded) {
    String binary = encoded.padRight(96, '0');

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // binary ranges specific to type 27
    int raimEnabled = getUintDirect(binary, 39, 40);
    int navigationStatusBin = getUintDirect(binary, 40, 44);
    int longitudeBin = getSignedIntDirect(binary, 44, 62); // Type 27 position
    int latitudeBin = getSignedIntDirect(binary, 62, 79); // Type 27 position
    double speed = getUintDirect(binary, 79, 85) / 10.0;
    double course = getUintDirect(binary, 85, 94) / 10.0;
    int gnss = getUintDirect(binary, 94, 95);
    int spare = getUintDirect(binary, 95, 96);

    // conversion to actually readable data
    String? navigationStatus = BinaryConverter().navigationStatusInfoDirect(navigationStatusBin);
    double? longitude = CoordinateUtils().calculateLongitudeDirect(longitudeBin, 18);
    double? latitude = CoordinateUtils().calculateLatitudeDirect(latitudeBin, 17);

    return LongRangeAISBroadcastMessage(
        messageType: messageType,
        mmsi: mmsi,
        repeatIndicator: repeatIndicator,
        raimEnabled: raimEnabled,
        navigationStatus: navigationStatus ?? navigationStatusBin.toString(),
        latitude: latitude,
        longitude: longitude,
        speedOverGround: speed,
        courseOverGround: course,
        gnssPositionStatus: gnss,
        spare: spare
    );
  }
}