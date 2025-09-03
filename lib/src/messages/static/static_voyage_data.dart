import '/ais_decoder.dart';
import '/src/utils/binary_conversion.dart';

class StaticAndVoyageRelatedData extends AISMessage {
  final int aisVersion;
  final int imoNumber;
  final String callSign;
  final String vesselName;
  final int vesselTypeInt;
  final String vesselType;
  final int dimensionBow;
  final int dimensionStern;
  final int dimensionPort;
  final int dimensionStarboard;
  final String epfdFixType;
  final int etaMonth;
  final int etaDay;
  final int etaHour;
  final int etaMinute;
  final double draught;
  final String destination;
  final int dte;
  final int spare;

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

  @override
  String toString() =>
      'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, '
      'AIS Version: $aisVersion, IMO: $imoNumber, Call Sign: $callSign, '
      'Vessel Name: $vesselName, Vessel Type Int: $vesselTypeInt, Vessel Type: $vesselType, '
      'Dimensions: ${dimensionBow}m bow/${dimensionStern}m stern/${dimensionPort}m port/${dimensionStarboard}m starboard, '
      'EPFD Fix Type: $epfdFixType, ETA: $etaMonth/$etaDay $etaHour:$etaMinute, '
      'Draught: ${draught}m, Destination: $destination, DTE: $dte, Spare: $spare)';

  factory StaticAndVoyageRelatedData.fromBinary(String binaryInput) {
    String binary = binaryInput.padRight(424, '0'); // add padding of zeroes if second part got truncated for some f*ck-all reasons...

    // common shit
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
}
