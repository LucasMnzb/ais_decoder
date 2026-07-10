import 'package:ais_decoder/ais_decoder.dart';
import 'package:ais_decoder/src/utils/binary_conversion.dart';
import 'package:ais_decoder/src/utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 23 — Group Assignment Command.
///
/// Sent by a base station to modify the reporting behaviour of a group of
/// mobile stations within a defined geographic bounding box. Stations that
/// match the [stationTypeInt] and [shipTypeInt] filters and are located inside
/// the NE/SW bounding box are instructed to adopt the specified transmit/
/// receive mode, reporting [interval], and [quietTime].
///
/// Each numeric field that has a human-readable interpretation is accompanied
/// by a corresponding `String?` field (e.g. [stationType], [shipType],
/// [txrxMode], [intervalInfo]).
class GroupAssignmentCommand extends AISMessage {
  /// Reserved spare bits (bits 38–39). Should be zero.
  final int spare;

  /// Longitude of the north-east corner of the target area in decimal degrees
  /// (positive east), or `null` if the encoded value indicates unavailability.
  final double? neLongitude;

  /// Latitude of the north-east corner of the target area in decimal degrees
  /// (positive north), or `null` if the encoded value indicates unavailability.
  final double? neLatitude;

  /// Longitude of the south-west corner of the target area in decimal degrees
  /// (positive east), or `null` if the encoded value indicates unavailability.
  final double? swLongitude;

  /// Latitude of the south-west corner of the target area in decimal degrees
  /// (positive north), or `null` if the encoded value indicates unavailability.
  final double? swLatitude;

  /// Raw integer encoding of the station type filter (0–15). Stations whose
  /// type matches this value are subject to the command.
  ///
  /// See [stationType] for the human-readable description.
  final int stationTypeInt;

  /// Human-readable description of [stationTypeInt], or `null` if undefined.
  final String? stationType;

  /// Raw integer encoding of the ship/cargo type filter (0–255). Only ships
  /// whose type matches are subject to the command.
  ///
  /// See [shipType] for the human-readable description.
  final int shipTypeInt;

  /// Human-readable description of [shipTypeInt], or `null` if undefined.
  final String? shipType;

  /// Raw integer encoding of the transmit/receive mode to be adopted (0–3).
  ///
  /// See [txrxMode] for the human-readable description.
  final int txrxModeInt;

  /// Human-readable description of [txrxModeInt], or `null` if undefined.
  final String? txrxMode;

  /// Reporting interval code (0–15) specifying how frequently targeted
  /// stations should transmit.
  ///
  /// See [intervalInfo] for the human-readable description.
  final int interval;

  /// Human-readable description of [interval], or `null` if undefined.
  final String? intervalInfo;

  /// Quiet time in minutes (0–15) during which targeted stations should not
  /// transmit. `0` means no quiet time.
  final int quietTime;

  /// Creates a [GroupAssignmentCommand] with all fields supplied explicitly.
  ///
  /// Prefer [GroupAssignmentCommand.fromEncoded] for decoding a real AIS payload.
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

  /// Decodes a six-bit-armored AIS payload string into a
  /// [GroupAssignmentCommand].
  ///
  /// [encoded] must be the payload field of a Type 23 NMEA sentence. The
  /// string is zero-padded to 160 bits before parsing. Coordinates use
  /// 1/10-minute resolution (18-bit signed longitude, 17-bit signed latitude).
  /// Human-readable string fields are resolved via [BinaryConverter] and
  /// [CoordinateUtils].
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