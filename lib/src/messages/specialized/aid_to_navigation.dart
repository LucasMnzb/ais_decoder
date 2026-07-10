import 'package:ais_decoder/ais_decoder.dart';
import 'package:ais_decoder/src/utils/coordinate_utils.dart';
import '../../utils/binary_conversion.dart';
import '../../utils/getInt.dart';

class AidToNavigationReport extends AISMessage {
  final int spare;
  final String? aidType;
  final int aidTypeInt;
  final String? name;
  final int positionAccuracy;
  final double? longitude;
  final double? latitude;
  final int dimensionBow;
  final int dimensionStern;
  final int dimensionPort;
  final int dimensionStarboard;
  final String? epfdFixType;
  final int second;
  final int offPosition;
  final int regional;
  final int raimFlag;
  final int virtualAid;
  final int assignedMode;
  final String? nameExtension;


  AidToNavigationReport({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.aidType,
    required this.aidTypeInt,
    required this.name,
    required this.positionAccuracy,
    required this.longitude,
    required this.latitude,
    required this.dimensionBow,
    required this.dimensionStern,
    required this.dimensionPort,
    required this.dimensionStarboard,
    required this.epfdFixType,
    required this.second,
    required this.offPosition,
    required this.regional,
    required this.raimFlag,
    required this.virtualAid,
    required this.assignedMode,
    required this.nameExtension,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AidToNavigationReport &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        spare == other.spare &&
        aidType == other.aidType &&
        aidTypeInt == other.aidTypeInt &&
        name == other.name &&
        positionAccuracy == other.positionAccuracy &&
        longitude == other.longitude &&
        latitude == other.latitude &&
        dimensionBow == other.dimensionBow &&
        dimensionStern == other.dimensionStern &&
        dimensionPort == other.dimensionPort &&
        dimensionStarboard == other.dimensionStarboard &&
        epfdFixType == other.epfdFixType &&
        second == other.second &&
        offPosition == other.offPosition &&
        regional == other.regional &&
        raimFlag == other.raimFlag &&
        virtualAid == other.virtualAid &&
        assignedMode == other.assignedMode &&
        nameExtension == other.nameExtension;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    spare,
    aidType,
    aidTypeInt,
    name,
    positionAccuracy,
    longitude,
    latitude,
    dimensionBow,
    dimensionStern,
    dimensionPort,
    dimensionStarboard,
    epfdFixType,
    second,
    offPosition,
    regional,
    raimFlag,
    virtualAid,
    assignedMode,
    nameExtension,
  ]);

  @override
  String toString() =>
      'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, '
          'Spare: $spare, Aid Type: $aidType ($aidTypeInt), Name: $name, '
          'Position Accuracy: $positionAccuracy, Lat: $latitude, Lon: $longitude, '
          'Dimensions: ${dimensionBow}m bow/${dimensionStern}m stern/${dimensionPort}m port/${dimensionStarboard}m starboard, '
          'EPFD Fix Type: $epfdFixType, Second: $second, Off Position: $offPosition, '
          'Regional: $regional, RAIM: $raimFlag, Virtual Aid: $virtualAid, Assigned Mode: $assignedMode, Name Extension: $nameExtension)';
//endregion

  factory AidToNavigationReport.fromEncoded(String encoded) {
    String binary = encoded.padRight(360, '0');

    // common  
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type AidToNavigationReport specific  
    int spare = getUintDirect(binary, 271, 272);
    int aidTypeInt = getUintDirect(binary, 38, 43);
    String? aidType = BinaryConverter().navigationAidInfoDirect(aidTypeInt);
    String? vesselName = BinaryConverter().getVesselNameDirect(binary, 43, 163);
    int positionAccuracy = getUintDirect(binary, 163, 164);
    int longitudeBin = getSignedIntDirect(binary, 164, 192);
    int latitudeBin = getSignedIntDirect(binary, 192, 219);
    int dimensionBow = getUintDirect(binary, 219, 228);
    int dimensionStern = getUintDirect(binary, 228, 237);
    int dimensionPort = getUintDirect(binary, 237, 243);
    int dimensionStarboard = getUintDirect(binary, 243, 249);
    String? epfdFixType = BinaryConverter().getEPFDFixTypeDirect(getUintDirect(binary, 249, 253));
    int seconds = getUintDirect(binary, 253, 259);
    int offPosition = getUintDirect(binary, 259, 260);
    int regional = getUintDirect(binary, 260, 268);
    int raimFlag = getUintDirect(binary, 268, 269);
    int virtualAid = getUintDirect(binary, 269, 270);
    int assignedMode = getUintDirect(binary, 270, 271);
    String? nameExtension = BinaryConverter().getVesselNameDirect(binary, 271, 360);

    return AidToNavigationReport(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare,
      aidTypeInt: aidTypeInt,
      positionAccuracy: positionAccuracy,
      dimensionBow: dimensionBow,
      dimensionStern: dimensionStern,
      dimensionPort: dimensionPort,
      dimensionStarboard: dimensionStarboard,
      second: seconds,
      offPosition: offPosition,
      regional: regional,
      raimFlag: raimFlag,
      virtualAid: virtualAid,
      assignedMode: assignedMode,
      nameExtension: nameExtension,
      aidType: aidType,
      name: vesselName,
      longitude: CoordinateUtils().calculateLongitudeDirect(longitudeBin, 28),
      latitude: CoordinateUtils().calculateLatitudeDirect(latitudeBin, 27),
      epfdFixType: epfdFixType,
    );
  }
}