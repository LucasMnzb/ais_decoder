import '/ais_decoder.dart';
import '/src/utils/binary_conversion.dart';
import '../../utils/coordinate_utils.dart';


/// ## Extended Class B CS Position Report
///
/// Note: The information in the ship name and dimension fields is not reliable, as it has to be hand-entered by humans rather than gathered automatically from sensors.
class ExtendedClassBCSPositionReport extends AISMessage {

  final double speedOverGround;
  final int positionAccuracy;
  final double? longitude;
  final double? latitude;
  final double courseOverGround;
  final double heading;
  final int timestamp;
  final double regionalReserved;
  final String vesselName;
  final int vesselTypeInt;
  final String vesselType;
  final int dimensionBow;
  final int dimensionStern;
  final int dimensionPort;
  final int dimensionStarboard;
  final String epfdFixType;
  final int raimFlag;
  final int dte;
  final int assignedMode;
  final int spare;

  ExtendedClassBCSPositionReport({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.speedOverGround,
    required this.positionAccuracy,
    required this.longitude,
    required this.latitude,
    required this.courseOverGround,
    required this.heading,
    required this.timestamp,
    required this.regionalReserved,
    required this.vesselName,
    required this.vesselTypeInt,
    required this.vesselType,
    required this.dimensionBow,
    required this.dimensionStern,
    required this.dimensionPort,
    required this.dimensionStarboard,
    required this.epfdFixType,
    required this.raimFlag,
    required this.dte,
    required this.assignedMode,
    required this.spare,
  });

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, SOG: $speedOverGround, Accuracy: $positionAccuracy, Lat: $latitude, Lon: $longitude, COG: $courseOverGround, Heading: $heading, Timestamp: $timestamp, Regional: $regionalReserved, Name: $vesselName, VesselType: $vesselType, DimBow: $dimensionBow, DimStern: $dimensionStern, DimPort: $dimensionPort, DimStbd: $dimensionStarboard, EPFD: $epfdFixType, RAIM: $raimFlag, DTE: $dte, Assigned: $assignedMode, Spare: $spare)';

  factory ExtendedClassBCSPositionReport.fromBinary(String binary) {
    // common
    int messageType = int.parse(binary.substring(0, 6), radix: 2);
    int repeatIndicator = int.parse(binary.substring(6, 8), radix: 2);
    int mmsi = int.parse(binary.substring(8, 38), radix: 2);

    // binary ranges specific for type 19 Class B Position Report
    String speedBin = binary.substring(46, 56);
    String positionAccuracyBin = binary.substring(56, 57);
    String longitudeBin = binary.substring(57, 85);
    String latitudeBin = binary.substring(85, 112);
    String courseBin = binary.substring(112, 124);
    String headingBin = binary.substring(124, 133);
    String timestampBin = binary.substring(133, 139);
    String regionalReservedBin = binary.substring(139, 143);
    String nameBin = binary.substring(143, 263);
    String typeOfShipAndCargoBin = binary.substring(263, 271);
    String dimensionBowBin = binary.substring(271, 280);
    String dimensionSternBin = binary.substring(280, 289);
    String dimensionPortBin = binary.substring(289, 295);
    String dimensionStarboardBin = binary.substring(295, 301);
    String positionFixTypeBin = binary.substring(301, 305);
    String raimFlagBin = binary.substring(305, 306);
    String dteReadyBin = binary.substring(306, 307);
    String assignedModeBin = binary.substring(307, 308);
    String spareBin = binary.substring(308, 312);

    // conversion to actually readable data
    double speed = int.parse(speedBin, radix: 2) / 10.0;
    int positionAccuracy = int.parse(positionAccuracyBin, radix: 2);
    double? longitude = CoordinateUtils().calculateLongitude(longitudeBin);
    double? latitude = CoordinateUtils().calculateLatitude(latitudeBin);
    double course = int.parse(courseBin, radix: 2) / 10.0;
    double heading = int.parse(headingBin, radix: 2).toDouble();
    int timestamp = int.parse(timestampBin, radix: 2);
    double regionalReserved = int.parse(regionalReservedBin, radix: 2).toDouble(); // Uninterpreted
    String vesselName = BinaryConverter().getVesselName(nameBin);
    int vesselTypeInt = int.parse(typeOfShipAndCargoBin);
    String vesselType = BinaryConverter().getVesselType(typeOfShipAndCargoBin);
    int dimensionBow = int.parse(dimensionBowBin, radix: 2);
    int dimensionStern = int.parse(dimensionSternBin, radix: 2);
    int dimensionPort = int.parse(dimensionPortBin, radix: 2);
    int dimensionStarboard = int.parse(dimensionStarboardBin, radix: 2);
    String positionFixType = BinaryConverter().getEPFDFixType(positionFixTypeBin);
    int raimFlag = int.parse(raimFlagBin, radix: 2);
    int dteReady = int.parse(dteReadyBin, radix: 2); // 0 = ready, 1 = not ready (default)
    int assignedMode = int.parse(assignedModeBin, radix: 2); // See IALA for details.
    int spare = int.parse(spareBin, radix: 2); // unused and should be 0.

    return ExtendedClassBCSPositionReport(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      speedOverGround: speed,
      positionAccuracy: positionAccuracy,
      longitude: longitude,
      latitude: latitude,
      courseOverGround: course,
      heading: heading,
      timestamp: timestamp,
      regionalReserved: regionalReserved,
      vesselName: vesselName,
      vesselTypeInt: vesselTypeInt,
      vesselType: vesselType,
      dimensionBow: dimensionBow,
      dimensionStern: dimensionStern,
      dimensionPort: dimensionPort,
      dimensionStarboard: dimensionStarboard,
      epfdFixType: positionFixType,
      raimFlag: raimFlag,
      dte: dteReady,
      assignedMode: assignedMode,
      spare: spare,
    );
  }
}