import 'package:ais_decoder/ais_decoder.dart';
import 'package:ais_decoder/src/utils/binary_conversion.dart';
import 'package:ais_decoder/src/utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

class GroupAssignmentCommand extends AISMessage {
  final int spare;
  final double? neLongitude;
  final double? neLatitude;
  final double? swLongitude;
  final double? swLatitude;
  final int stationTypeInt;
  final String? stationType;
  final int shipTypeInt;
  final String? shipType;
  final int txrxModeInt;
  final String? txrxMode;
  final int interval;
  final String? intervalInfo;
  final int quietTime;

  GroupAssignmentCommand({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.neLongitude,
    required this.neLatitude,
    required this.swLongitude,
    required this.swLatitude,
    required this.stationTypeInt,
    required this.shipTypeInt,
    required this.txrxModeInt,
    required this.interval,
    required this.quietTime,
    required this.stationType,
    required this.shipType,
    required this.txrxMode,
    required this.intervalInfo,
  });

  //region Overrides  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroupAssignmentCommand &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        spare == other.spare &&
        neLongitude == other.neLongitude &&
        neLatitude == other.neLatitude &&
        swLongitude == other.swLongitude &&
        swLatitude == other.swLatitude &&
        stationTypeInt == other.stationTypeInt &&
        shipTypeInt == other.shipTypeInt &&
        txrxModeInt == other.txrxModeInt &&
        interval == other.interval &&
        quietTime == other.quietTime &&
        stationType == other.stationType &&
        shipType == other.shipType &&
        txrxMode == other.txrxMode &&
        intervalInfo == other.intervalInfo;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    spare,
    neLongitude,
    neLatitude,
    swLongitude,
    swLatitude,
    stationTypeInt,
    shipTypeInt,
    txrxModeInt,
    interval,
    quietTime,
    stationType,
    shipType,
    txrxMode,
    intervalInfo,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Spare: $spare, NE Longitude: $neLongitude, NE Latitude: $neLatitude, SW Longitude: $swLongitude, SW Latitude: $swLatitude, Station Type Int: $stationTypeInt, Ship Type Int: $shipTypeInt, TX/RX Mode Int: $txrxModeInt, Interval: $interval, Quiet Time: $quietTime, Station Type: $stationType, Ship Type: $shipType, TX/RX Mode: $txrxMode, Interval Info: $intervalInfo)';
  //endregion  

  factory GroupAssignmentCommand.fromEncoded(String encoded) {
    String binary = encoded.padRight(160, '0');

    // common  
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type GroupAssignmentCommand specific  
    int spare = getUintDirect(binary, 38, 40);
    int neLongitudeBin = getSignedIntDirect(binary, 40, 58);
    int neLatitudeBin = getSignedIntDirect(binary, 58, 75);
    int swLongitudeBin = getSignedIntDirect(binary, 75, 93);
    int swLatitudeBin = getSignedIntDirect(binary, 93, 110);
    int stationType = getUintDirect(binary, 110, 114);
    int shipType = getUintDirect(binary, 114, 121);
    int txrxMode = getUintDirect(binary, 144, 146);
    int interval = getUintDirect(binary, 146, 150);
    int quietTime = getUintDirect(binary, 150, 154);

    return GroupAssignmentCommand(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare,
      neLongitude: CoordinateUtils().calculateLongitudeDirect(neLongitudeBin, 18),
      neLatitude: CoordinateUtils().calculateLatitudeDirect(neLatitudeBin, 17),
      swLongitude: CoordinateUtils().calculateLongitudeDirect(swLongitudeBin, 18),
      swLatitude: CoordinateUtils().calculateLatitudeDirect(swLatitudeBin, 17),
      stationTypeInt: stationType,
      shipTypeInt: shipType,
      txrxModeInt: txrxMode,
      interval: interval,
      quietTime: quietTime,
      stationType: BinaryConverter().stationTypeInfoDirect(stationType),
      shipType: BinaryConverter().getVesselTypeDirect(shipType),
      txrxMode: BinaryConverter().transmitModeInfoDirect(txrxMode),
      intervalInfo: BinaryConverter().stationIntervalInfo(interval),
    );
  }
}