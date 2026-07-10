import 'package:ais_decoder/ais_decoder.dart';
import 'package:ais_decoder/src/utils/binary_conversion.dart';
import 'package:ais_decoder/src/utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 22 — Channel Management.
///
/// Broadcast by a base station to configure VHF channel usage and transmit
/// parameters for mobile stations within a region or for specific stations.
///
/// The message targets either a geographic zone or a pair of addressed
/// stations, depending on [addressed]:
/// - When [addressed] is `0` (broadcast), [neLongitude], [neLatitude],
///   [swLongitude], and [swLatitude] define the bounding box of the managed
///   area, and [mmsi1]/[mmsi2] are `null`.
/// - When [addressed] is `1`, [mmsi1] and [mmsi2] identify the specific
///   stations being configured, and the geographic fields are `null`.
class ChannelManagementMessage extends AISMessage {
  /// Reserved spare bits (bits 38–39). Should be zero.
  final int spare;

  /// ITU channel number for VHF channel A (0–4095).
  final int channelA;

  /// ITU channel number for VHF channel B (0–4095).
  final int channelB;

  /// Raw integer encoding of the transmit/receive mode (0–15).
  ///
  /// See [txrxMode] for the human-readable description.
  final int txrxModeInt;

  /// Human-readable description of [txrxModeInt], or `null` if the value has
  /// no defined description.
  final String? txrxMode;

  /// Transmit power setting. `0` = high power, `1` = low power.
  final int power;

  /// Longitude of the north-east corner of the managed geographic area in
  /// decimal degrees (positive east), or `null` when [addressed] is `1`.
  final double? neLongitude;

  /// Latitude of the north-east corner of the managed geographic area in
  /// decimal degrees (positive north), or `null` when [addressed] is `1`.
  final double? neLatitude;

  /// Longitude of the south-west corner of the managed geographic area in
  /// decimal degrees (positive east), or `null` when [addressed] is `1`.
  final double? swLongitude;

  /// Latitude of the south-west corner of the managed geographic area in
  /// decimal degrees (positive north), or `null` when [addressed] is `1`.
  final double? swLatitude;

  /// MMSI of the first addressed station, or `null` when [addressed] is `0`
  /// (broadcast / geographic zone).
  final int? mmsi1;

  /// MMSI of the second addressed station, or `null` when [addressed] is `0`.
  final int? mmsi2;

  /// Addressed flag. `1` means [mmsi1]/[mmsi2] are used; `0` means the
  /// geographic bounding box fields are used.
  final int addressed;

  /// Channel A bandwidth flag. `0` = default (25 kHz); `1` = 12.5 kHz.
  final int bandA;

  /// Channel B bandwidth flag. `0` = default (25 kHz); `1` = 12.5 kHz.
  final int bandB;

  /// Transitional zone size in nautical miles (1–8). Defines how far outside
  /// the area boundary the channel change takes effect.
  final int zoneSize;

  /// Creates a [ChannelManagementMessage] with all fields supplied explicitly.
  ///
  /// Prefer [ChannelManagementMessage.fromEncoded] for decoding a real AIS payload.
  ChannelManagementMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.channelA,
    required this.channelB,
    required this.txrxMode,
    required this.txrxModeInt,
    required this.power,
    required this.neLongitude,
    required this.neLatitude,
    required this.swLongitude,
    required this.swLatitude,
    required this.mmsi1,
    required this.mmsi2,
    required this.addressed,
    required this.bandA,
    required this.bandB,
    required this.zoneSize,
  });

  //region Overrides  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChannelManagementMessage &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        spare == other.spare &&
        channelA == other.channelA &&
        channelB == other.channelB &&
        txrxMode == other.txrxMode &&
        power == other.power &&
        neLongitude == other.neLongitude &&
        neLatitude == other.neLatitude &&
        swLongitude == other.swLongitude &&
        swLatitude == other.swLatitude &&
        mmsi1 == other.mmsi1 &&
        mmsi2 == other.mmsi2 &&
        addressed == other.addressed &&
        bandA == other.bandA &&
        bandB == other.bandB &&
        zoneSize == other.zoneSize;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    spare,
    channelA,
    channelB,
    txrxMode,
    power,
    neLongitude,
    neLatitude,
    swLongitude,
    swLatitude,
    mmsi1,
    mmsi2,
    addressed,
    bandA,
    bandB,
    zoneSize,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Spare: $spare, ChannelA: $channelA, ChannelB: $channelB, TxRxMode: $txrxMode, Power: $power, NeLongitude: $neLongitude, NeLatitude: $neLatitude, SwLongitude: $swLongitude, SwLatitude: $swLatitude, MMSI1: $mmsi1, MMSI2: $mmsi2, Addressed: $addressed, BandA: $bandA, BandB: $bandB, ZoneSize: $zoneSize)';
  //endregion  

  /// Decodes a six-bit-armored AIS payload string into a
  /// [ChannelManagementMessage].
  ///
  /// [encoded] must be the payload field of a Type 22 NMEA sentence. The
  /// string is zero-padded to 168 bits before parsing. The [addressed] flag
  /// (bit 139) is read first to determine whether to parse the geographic
  /// bounding box or the two station MMSIs from bits 69–134.
  factory ChannelManagementMessage.fromEncoded(String encoded) {
    String binary = encoded.padRight(168, '0');

    // common  
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type ChannelManagementMessage specific  
    int spare = getUintDirect(binary, 38, 40);
    int channelA = getUintDirect(binary, 40, 52);
    int channelB = getUintDirect(binary, 52, 64);
    int txrxModeBin = getUintDirect(binary, 64, 68);
    int power = getUintDirect(binary, 68, 69);

    int mmsi1 = 0;
    int mmsi2 = 0;
    int neLongitudeBin = 0;
    int neLatitudeBin = 0;
    int swLongitudeBin = 0;
    int swLatitudeBin = 0;

    int addressed = getUintDirect(binary, 139, 140);

    if(addressed == 1) {
       mmsi1 = getUintDirect(binary, 69, 99);
       mmsi2 = getUintDirect(binary, 104, 134);
    } else {
       neLongitudeBin = getSignedIntDirect(binary, 69, 87);
       neLatitudeBin = getSignedIntDirect(binary, 87, 104);
       swLongitudeBin = getSignedIntDirect(binary, 104, 122);
       swLatitudeBin = getSignedIntDirect(binary, 122, 139);
    }

    int bandA = getUintDirect(binary, 140, 141);
    int bandB = getUintDirect(binary, 141, 142);
    int zoneSize = getUintDirect(binary, 142, 145);

    return ChannelManagementMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare,
      channelA: channelA,
      channelB: channelB,
      txrxModeInt: txrxModeBin,
      txrxMode: BinaryConverter().transmitModeInfoDirect(txrxModeBin),
      power: power,
      neLongitude: addressed == 0 ? CoordinateUtils().calculateLongitudeDirect(neLongitudeBin, 18) : null,
      neLatitude: addressed == 0 ? CoordinateUtils().calculateLatitudeDirect(neLatitudeBin, 17) : null,
      swLongitude: addressed == 0 ? CoordinateUtils().calculateLongitudeDirect(swLongitudeBin, 18) : null,
      swLatitude: addressed == 0 ? CoordinateUtils().calculateLatitudeDirect(swLatitudeBin, 17) : null,
      mmsi1: addressed == 1 ? mmsi1 : null,
      mmsi2: addressed == 1 ? mmsi2 : null,
      addressed: addressed,
      bandA: bandA,
      bandB: bandB,
      zoneSize: zoneSize,
    );
  }
}