import 'package:ais_decoder/src/utils/getInt.dart';

import '../../../ais_decoder.dart';
import '../../utils/binary_conversion.dart';

/// ITU-R M.1371 Message Type 5 — Static and Voyage Related Data.
///
/// Transmitted by Class A transponders to broadcast vessel identity and
/// voyage-specific information. Because this message spans 424 bits it always
/// requires two TDMA slots and is therefore sent as a multi-part NMEA
/// sentence.
///
/// Unlike position reports, Type 5 is transmitted infrequently (typically
/// every 6 minutes) and carries data that changes slowly or per-voyage:
/// call sign, vessel name, dimensions, EPFD type, estimated time of arrival,
/// maximum draught, and destination.
///
/// > **Note:** The [vesselName], [destination], and dimension fields depend on
/// > manual data entry and may not always be accurate.
class StaticAndVoyageRelatedData extends AISMessage {
  /// AIS equipment version (0–3). `0` = ITU-R M.1371-1, `1` = ITU-R
  /// M.1371-3, `2` = ITU-R M.1371-5. Values 3 and above are reserved.
  final int aisVersion;

  /// IMO ship identification number (1–999 999 999), or `0` when not
  /// available. The IMO number remains unchanged for the life of the vessel.
  final int imoNumber;

  /// Vessel radio call sign, up to 7 characters, decoded from the 6-bit ASCII
  /// character set (bits 70–111).
  final String callSign;

  /// Vessel name, up to 20 characters, decoded from the 6-bit ASCII character
  /// set (bits 112–231).
  final String vesselName;

  /// Raw integer encoding of the ship and cargo type (0–255).
  ///
  /// See [vesselType] for the human-readable description.
  final int vesselTypeInt;

  /// Human-readable description of [vesselTypeInt] (e.g. "Tanker",
  /// "Cargo vessel").
  final String vesselType;

  /// Distance in metres from the AIS antenna reference point to the bow.
  final int dimensionBow;

  /// Distance in metres from the AIS antenna reference point to the stern.
  final int dimensionStern;

  /// Distance in metres from the AIS antenna reference point to the port side.
  final int dimensionPort;

  /// Distance in metres from the AIS antenna reference point to the starboard
  /// side.
  final int dimensionStarboard;

  /// Human-readable Electronic Position-Fixing Device (EPFD) fix type string
  /// (e.g. "GPS", "GLONASS", "Combined GPS/GLONASS").
  final String epfdFixType;

  /// Estimated month of arrival at destination (1–12). `0` = not available.
  final int etaMonth;

  /// Estimated day of arrival at destination (1–31). `0` = not available.
  final int etaDay;

  /// Estimated hour of arrival at destination (0–23). `24` = not available.
  final int etaHour;

  /// Estimated minute of arrival at destination (0–59). `60` = not available.
  final int etaMinute;

  /// Maximum present static draught in metres (0.0–25.5). Resolution is
  /// 0.1 m. `0.0` = not available.
  final double draught;

  /// Destination port name, up to 20 characters, decoded from the 6-bit ASCII
  /// character set (bits 302–421).
  final String destination;

  /// Data Terminal Equipment (DTE) readiness flag.
  /// `0` = DTE available (ready), `1` = DTE not available (default).
  final int dte;

  /// Reserved spare bit (bit 423). Should be zero.
  final int spare;

  /// Creates a [StaticAndVoyageRelatedData] with all fields supplied explicitly.
  ///
  /// Prefer [StaticAndVoyageRelatedData.fromEncoded] for decoding a real AIS
  /// payload.
  StaticAndVoyageRelatedData({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.aisVersion,
    required this.imoNumber,
    required this.callSign,
    required this.vesselName,
    required this.vesselTypeInt,
    required this.vesselType,
    required this.dimensionBow,
    required this.dimensionStern,
    required this.dimensionPort,
    required this.dimensionStarboard,
    required this.epfdFixType,
    required this.etaMonth,
    required this.etaDay,
    required this.etaHour,
    required this.etaMinute,
    required this.draught,
    required this.destination,
    required this.dte,
    required this.spare,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StaticAndVoyageRelatedData &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        aisVersion == other.aisVersion &&
        imoNumber == other.imoNumber &&
        callSign == other.callSign &&
        vesselName == other.vesselName &&
        vesselTypeInt == other.vesselTypeInt &&
        vesselType == other.vesselType &&
        dimensionBow == other.dimensionBow &&
        dimensionStern == other.dimensionStern &&
        dimensionPort == other.dimensionPort &&
        dimensionStarboard == other.dimensionStarboard &&
        epfdFixType == other.epfdFixType &&
        etaMonth == other.etaMonth &&
        etaDay == other.etaDay &&
        etaHour == other.etaHour &&
        etaMinute == other.etaMinute &&
        draught == other.draught &&
        destination == other.destination &&
        dte == other.dte &&
        spare == other.spare;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    aisVersion,
    imoNumber,
    callSign,
    vesselName,
    vesselTypeInt,
    vesselType,
    dimensionBow,
    dimensionStern,
    dimensionPort,
    dimensionStarboard,
    epfdFixType,
    etaMonth,
    etaDay,
    etaHour,
    etaMinute,
    draught,
    destination,
    dte,
    spare,
  ]);

  @override
  String toString() =>
      'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, '
      'AIS Version: $aisVersion, IMO: $imoNumber, Call Sign: $callSign, '
      'Vessel Name: $vesselName, Vessel Type Int: $vesselTypeInt, Vessel Type: $vesselType, '
      'Dimensions: ${dimensionBow}m bow/${dimensionStern}m stern/${dimensionPort}m port/${dimensionStarboard}m starboard, '
      'EPFD Fix Type: $epfdFixType, ETA: $etaMonth/$etaDay $etaHour:$etaMinute, '
      'Draught: ${draught}m, Destination: $destination, DTE: $dte, Spare: $spare)';
  
  //endregion

  /// Decodes a pre-converted binary string into a [StaticAndVoyageRelatedData].
  ///
  /// **Deprecated.** Use [StaticAndVoyageRelatedData.fromEncoded] instead.
  /// This factory operates on a fully expanded binary string (one character
  /// per bit) which is significantly slower than the direct bit-extraction
  /// path used by [fromEncoded].
  @Deprecated("Legacy Code use .fromEncoded instead for performance reasons")
  factory StaticAndVoyageRelatedData.fromBinary(String binaryInput) {
    String binary = binaryInput.padRight(424, '0'); // add padding of zeroes if second part got truncated for some f*ck-all reasons...

    // common
    int messageType = int.parse(binary.substring(0, 6), radix: 2);
    int repeatIndicator = int.parse(binary.substring(6, 8), radix: 2);
    int mmsi = int.parse(binary.substring(8, 38), radix: 2);

    // binary ranges specific to type 5
    String callSignBin = binary.substring(70, 112);
    String vesselNameBin = binary.substring(112, 232);
    String vesselTypeBin = binary.substring(232, 240);
    String dimensionBowBin = binary.substring(240, 249);
    String dimensionSternBin = binary.substring(249, 258);
    String dimensionPortBin = binary.substring(258, 264);
    String dimensionStarboardBin = binary.substring(264, 270);
    String positionFixTypeBin = binary.substring(270, 274);
    String etaMonthBin = binary.substring(274, 278);
    String etaDayBin = binary.substring(278, 283);
    String etaHourBin = binary.substring(283, 288);
    String etaMinuteBin = binary.substring(288, 294);
    String draughtBin = binary.substring(294, 302);
    String destinationBin = binary.substring(302, 422);

    // conversion to actually readable data
    int aisVersion = int.parse(binary.substring(38, 40), radix: 2);
    int imoNumber = int.parse(binary.substring(40, 70), radix: 2);
    String callSign = BinaryConverter().getVesselCallSign(callSignBin);
    String vesselName = BinaryConverter().getVesselName(vesselNameBin);
    String vesselType = BinaryConverter().getVesselType(vesselTypeBin);
    int dimensionBow = int.parse(dimensionBowBin, radix: 2);
    int dimensionStern = int.parse(dimensionSternBin, radix: 2);
    int dimensionPort = int.parse(dimensionPortBin, radix: 2);
    int dimensionStarboard = int.parse(dimensionStarboardBin, radix: 2);
    String positionFixType = BinaryConverter().getEPFDFixType(positionFixTypeBin);
    int etaMonth = int.parse(etaMonthBin, radix: 2);
    int etaDay = int.parse(etaDayBin, radix: 2);
    int etaHour = int.parse(etaHourBin, radix: 2);
    int etaMinute = int.parse(etaMinuteBin, radix: 2);
    double draught = BinaryConverter().calculateDraught(draughtBin);
    String destination = BinaryConverter().getDestination(destinationBin);
    int dteReady = int.parse(binary.substring(422, 423), radix: 2);
    int spare = int.parse(binary.substring(423, 424), radix: 2);

    return StaticAndVoyageRelatedData(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      aisVersion: aisVersion,
      imoNumber: imoNumber,
      callSign: callSign,
      vesselName: vesselName,
      vesselType: vesselType,
      vesselTypeInt: int.parse(vesselTypeBin, radix: 2),
      dimensionBow: dimensionBow,
      dimensionStern: dimensionStern,
      dimensionPort: dimensionPort,
      dimensionStarboard: dimensionStarboard,
      epfdFixType: positionFixType,
      etaMonth: etaMonth,
      etaDay: etaDay,
      etaHour: etaHour,
      etaMinute: etaMinute,
      draught: draught,
      destination: destination,
      dte: dteReady,
      spare: spare
    );
  }

  /// Decodes a six-bit-armored AIS payload string into a
  /// [StaticAndVoyageRelatedData].
  ///
  /// [encoded] must be the reassembled payload of a Type 5 multi-part NMEA
  /// sentence (424 bits total). The string is zero-padded to 424 bits before
  /// parsing. String fields ([callSign], [vesselName], [vesselType],
  /// [epfdFixType], [destination]) are resolved via [BinaryConverter].
  factory StaticAndVoyageRelatedData.fromEncoded(String encoded) {
    String binary = encoded.padRight(424, '0'); // add padding of zeroes if second part got truncated for some f*ck-all reasons...

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // binary ranges specific to type 5
    // int callSignBin = getUintDirect(binary, 70, 112);
    // int vesselNameBin = getUintDirect(binary, 112, 232);
    int vesselTypeBin = getUintDirect(binary, 232, 240);
    int dimensionBowBin = getUintDirect(binary, 240, 249);
    int dimensionSternBin = getUintDirect(binary, 249, 258);
    int dimensionPortBin = getUintDirect(binary, 258, 264);
    int dimensionStarboardBin = getUintDirect(binary, 264, 270);
    int positionFixTypeBin = getUintDirect(binary, 270, 274);
    int etaMonthBin = getUintDirect(binary, 274, 278);
    int etaDayBin = getUintDirect(binary, 278, 283);
    int etaHourBin = getUintDirect(binary, 283, 288);
    int etaMinuteBin = getUintDirect(binary, 288, 294);
    int draughtBin = getUintDirect(binary, 294, 302);
    // int destinationBin = getUintDirect(binary, 302, 422);

    // conversion to actually readable data
    int aisVersion = getUintDirect(binary,  38, 40);
    int imoNumber = getUintDirect(binary,  40, 70);
    String callSign = BinaryConverter().getVesselCallSignDirect(binary, 70, 112);
    String vesselName = BinaryConverter().getVesselNameDirect(binary, 112, 232);
    String vesselType = BinaryConverter().getVesselTypeDirect(vesselTypeBin);
    int dimensionBow = dimensionBowBin;
    int dimensionStern = dimensionSternBin;
    int dimensionPort = dimensionPortBin;
    int dimensionStarboard = dimensionStarboardBin;
    String positionFixType = BinaryConverter().getEPFDFixTypeDirect(positionFixTypeBin);
    int etaMonth = etaMonthBin;
    int etaDay = etaDayBin;
    int etaHour = etaHourBin;
    int etaMinute = etaMinuteBin;
    double draught = BinaryConverter().calculateDraughtDirect(draughtBin);
    String destination = BinaryConverter().getDestinationDirect(binary, 302, 422);
    int dteReady = getUintDirect(binary, 422, 423);
    int spare = getUintDirect(binary, 423, 424);

    return StaticAndVoyageRelatedData(
        messageType: messageType,
        mmsi: mmsi,
        repeatIndicator: repeatIndicator,
        aisVersion: aisVersion,
        imoNumber: imoNumber,
        callSign: callSign,
        vesselName: vesselName,
        vesselType: vesselType,
        vesselTypeInt: vesselTypeBin,
        dimensionBow: dimensionBow,
        dimensionStern: dimensionStern,
        dimensionPort: dimensionPort,
        dimensionStarboard: dimensionStarboard,
        epfdFixType: positionFixType,
        etaMonth: etaMonth,
        etaDay: etaDay,
        etaHour: etaHour,
        etaMinute: etaMinute,
        draught: draught,
        destination: destination,
        dte: dteReady,
        spare: spare
    );
  }
}
