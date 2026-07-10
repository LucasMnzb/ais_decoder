import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

class SarAircraftPositionReport extends AISMessage {
  final int spare;
  final int? altitude;
  final int? speedOverGround;
  final int positionAccuracy;
  final double? longitude;
  final double? latitude;
  final double? courseOverGround;
  final int timestamp;
  final int regionalReserved;
  final int dte;
  final int assignedMode;
  final int raimEnabled;
  final int radio;


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