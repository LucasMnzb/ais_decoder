import 'package:ais_decoder/ais_decoder.dart';
import 'package:ais_decoder/src/utils/coordinate_utils.dart';
import '../../utils/binary_conversion.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 21 — Aid-to-Navigation Report.
///
/// Transmitted by fixed or floating navigational aids (buoys, beacons,
/// lighthouses, etc.) to broadcast their identity, type, position, and
/// operational status. The [mmsi] belongs to the aid itself, not a vessel.
///
/// The [name] field can carry up to 20 characters; if the name is longer,
/// the overflow is placed in [nameExtension] (up to an additional 14
/// characters). Both are decoded from the 6-bit ASCII encoding used in AIS.
///
/// A virtual aid ([virtualAid] = `1`) exists only as a data object — there
/// is no physical structure at the reported position.
class AidToNavigationReport extends AISMessage {
  /// Reserved spare bit (bit 271). Should be zero.
  final int spare;

  /// Human-readable aid type string (e.g. "Lanby", "Buoy, safe water"),
  /// or `null` if the raw value is undefined.
  final String? aidType;

  /// Raw integer encoding of the aid type (0–31).
  ///
  /// See [aidType] for the human-readable description.
  final int aidTypeInt;

  /// Name of the navigational aid, up to 20 characters, decoded from the
  /// 6-bit ASCII character set. `null` if the field is empty.
  final String? name;

  /// Position accuracy flag. `1` = high accuracy (< 10 m, DGPS-quality);
  /// `0` = low accuracy (> 10 m).
  final int positionAccuracy;

  /// Longitude of the aid in decimal degrees (positive east), or `null` when
  /// not available (encoded as 181° × 10⁴).
  final double? longitude;

  /// Latitude of the aid in decimal degrees (positive north), or `null` when
  /// not available (encoded as 91° × 10⁴).
  final double? latitude;

  /// Distance in metres from the AIS antenna reference point to the bow
  /// (or forward face) of the aid structure.
  final int dimensionBow;

  /// Distance in metres from the AIS antenna reference point to the stern
  /// (or aft face) of the aid structure.
  final int dimensionStern;

  /// Distance in metres from the AIS antenna reference point to the port side
  /// of the aid structure.
  final int dimensionPort;

  /// Distance in metres from the AIS antenna reference point to the starboard
  /// side of the aid structure.
  final int dimensionStarboard;

  /// Human-readable Electronic Position-Fixing Device (EPFD) fix type string
  /// (e.g. "GPS", "GLONASS"), or `null` if undefined.
  final String? epfdFixType;

  /// UTC second of the position fix (0–59). Values 60–63 carry special
  /// meaning (e.g. 61 = manual input, 63 = inoperative).
  final int second;

  /// Off-position indicator. `1` = the aid is off its charted position;
  /// `0` = on position. Only meaningful for floating aids.
  final int offPosition;

  /// Regional reserved field (bits 260–267). Interpretation is
  /// region-specific and stored as a raw integer.
  final int regional;

  /// Receiver Autonomous Integrity Monitoring (RAIM) flag.
  /// `1` = RAIM in use, `0` = RAIM not in use.
  final int raimFlag;

  /// Virtual aid flag. `1` = virtual (no physical structure exists at this
  /// position); `0` = real physical aid.
  final int virtualAid;

  /// Assigned mode flag. `0` = autonomous; `1` = assigned by a base station.
  final int assignedMode;

  /// Optional name extension carrying characters beyond the 20-character
  /// limit of [name], decoded from 6-bit ASCII. `null` if not present.
  final String? nameExtension;

  /// Creates an [AidToNavigationReport] with all fields supplied explicitly.
  ///
  /// Prefer [AidToNavigationReport.fromEncoded] for decoding a real AIS payload.
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

  /// Decodes a six-bit-armored AIS payload string into an
  /// [AidToNavigationReport].
  ///
  /// [encoded] must be the payload field of a Type 21 NMEA sentence. The
  /// string is zero-padded to 360 bits before parsing. [name] and
  /// [nameExtension] are both decoded via [BinaryConverter]. Aid type and
  /// EPFD fix type strings are resolved from their respective lookup tables.
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