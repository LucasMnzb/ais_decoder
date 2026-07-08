import 'package:ais_decoder/src/utils/getInt.dart';

import '../../../ais_decoder.dart';
import '../../utils/binary_conversion.dart';

class StaticDataReportA extends AISMessage {
  final int partNumber;
  final String vesselName;
  final int spare;

  StaticDataReportA({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.partNumber,
    required this.vesselName,
    required this.spare,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StaticDataReportA &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        partNumber == other.partNumber &&
        vesselName == other.vesselName &&
        spare == other.spare;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    partNumber,
    vesselName,
    spare,
  ]);

  @override
  String toString() =>
      'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, '
          'Vessel Name: $vesselName, Part Number: $partNumber,'
          'spare: $spare, Hint: This is Part/Type A of the Type 24 AIS Message, expect Part/Type B)';
  //endregion

  factory StaticDataReportA.fromBinary(String binaryInput) {
    String binary = binaryInput.padRight(168, '0'); // add padding of zeroes if type a part got truncated for some f*ck-all reasons - // "According to the standard, both the A and B parts are supposed to be 168 bits. However, in the wild, A parts are often transmitted with only 160 bits, omitting the 'spare' 7 bits at the end. Implementers should be permissive about this."

    // common
    int messageType = int.parse(binary.substring(0, 6), radix: 2);
    int repeatIndicator = int.parse(binary.substring(6, 8), radix: 2);
    int mmsi = int.parse(binary.substring(8, 38), radix: 2);

    // binary ranges specific to type 24A
    String partNumberBin = binary.substring(38, 40);
    String vesselNameBin = binary.substring(40, 160);
    String spareBin = binary.substring(160, 168);


    // conversion to actually readable data
    int partNumber = int.parse(partNumberBin, radix: 2);
    String vesselName = BinaryConverter().getVesselName(vesselNameBin);
    int spare = int.parse(spareBin, radix: 2);

    return StaticDataReportA(
        messageType: messageType,
        mmsi: mmsi,
        repeatIndicator: repeatIndicator,
        partNumber: partNumber,
        vesselName: vesselName,
        spare: spare
    );
  }

  factory StaticDataReportA.fromEncoded(String encoded) {
    String binary = encoded.padRight(168, '0'); // add padding of zeroes if type a part got truncated for some f*ck-all reasons - // "According to the standard, both the A and B parts are supposed to be 168 bits. However, in the wild, A parts are often transmitted with only 160 bits, omitting the 'spare' 7 bits at the end. Implementers should be permissive about this."

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // binary ranges specific to type 24A
    int partNumber = getUintDirect(binary, 38, 40);
    String vesselName = BinaryConverter().getVesselNameDirect(binary, 40, 160);
    int spare = getUintDirect(binary, 160, 168);

    return StaticDataReportA(
        messageType: messageType,
        mmsi: mmsi,
        repeatIndicator: repeatIndicator,
        partNumber: partNumber,
        vesselName: vesselName,
        spare: spare
    );
  }
}

class StaticDataReportB extends AISMessage {
  final int partNumber;
  final int vesselTypeInt;
  final String vesselType;
  final String vendorId;
  final int unitModel;
  final int serialNumber;
  final String callSign;
  final int dimensionBow;
  final int dimensionStern;
  final int dimensionPort;
  final int dimensionStarboard;
  final int mothershipMMSI;
  final int spare;

  StaticDataReportB({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.partNumber,
    required this.vesselTypeInt,
    required this.vesselType,
    required this.vendorId,
    required this.unitModel,
    required this.serialNumber,
    required this.callSign,
    required this.dimensionBow,
    required this.dimensionStern,
    required this.dimensionPort,
    required this.dimensionStarboard,
    required this.mothershipMMSI,
    required this.spare,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StaticDataReportB &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        partNumber == other.partNumber &&
        vesselTypeInt == other.vesselTypeInt &&
        vesselType == other.vesselType &&
        vendorId == other.vendorId &&
        unitModel == other.unitModel &&
        serialNumber == other.serialNumber &&
        callSign == other.callSign &&
        dimensionBow == other.dimensionBow &&
        dimensionStern == other.dimensionStern &&
        dimensionPort == other.dimensionPort &&
        dimensionStarboard == other.dimensionStarboard &&
        mothershipMMSI == other.mothershipMMSI &&
        spare == other.spare;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    partNumber,
    vesselTypeInt,
    vesselType,
    vendorId,
    unitModel,
    serialNumber,
    callSign,
    dimensionBow,
    dimensionStern,
    dimensionPort,
    dimensionStarboard,
    mothershipMMSI,
    spare,
  ]);

  @override
  String toString() =>
      'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Part Number: $partNumber, '
          'VendorID: $vendorId, Unit Model: $unitModel, Call Sign: $callSign, '
          'Vessel Type Int: $vesselTypeInt, Vessel Type: $vesselType, '
          'Dimensions: ${dimensionBow}m bow/${dimensionStern}m stern/${dimensionPort}m port/${dimensionStarboard}m starboard, '
          'Mothership MMSI: $mothershipMMSI'
          'Serial Number: $serialNumber, spare: $spare)';
  //endregion

  factory StaticDataReportB.fromBinary(String binaryInput) {
    String binary = binaryInput.padRight(168, '0'); // add padding of zeroes if second part got truncated for some f*ck-all reasons...

    // common
    int messageType = int.parse(binary.substring(0, 6), radix: 2);
    int repeatIndicator = int.parse(binary.substring(6, 8), radix: 2);
    int mmsi = int.parse(binary.substring(8, 38), radix: 2);

    // binary ranges specific to type 5
    String partNumberBin = binary.substring(38, 40);
    String vesselTypeBin = binary.substring(40, 48);
    String vendorIdBin = binary.substring(48, 66);
    String unitModelCodeBin = binary.substring(66, 70);
    String serialNumberBin = binary.substring(70, 90);
    String callSignBin = binary.substring(90, 132);
    String dimensionBowBin = binary.substring(132, 141);
    String dimensionSternBin = binary.substring(141, 150);
    String dimensionPortBin = binary.substring(150, 156);
    String dimensionStarboardBin = binary.substring(156, 162);
    String mothershipMMSIBin = binary.substring(132, 162);
    String spareBin = binary.substring(162, 168);

    // conversion to actually readable data
    int partNumber = int.parse(partNumberBin, radix: 2);
    String vesselType = BinaryConverter().getVesselType(vesselTypeBin);
    String vendorId = BinaryConverter().getVendorId(vendorIdBin);
    int unitModelCode = int.parse(unitModelCodeBin, radix: 2);
    int serialNumber = int.parse(serialNumberBin, radix: 2);
    String callSign = BinaryConverter().getVesselCallSign(callSignBin);
    int dimensionBow = int.parse(dimensionBowBin, radix: 2);
    int dimensionStern = int.parse(dimensionSternBin, radix: 2);
    int dimensionPort = int.parse(dimensionPortBin, radix: 2);
    int dimensionStarboard = int.parse(dimensionStarboardBin, radix: 2);
    int motherShipMMSI = int.parse(mothershipMMSIBin, radix: 2);
    int spare = int.parse(spareBin, radix: 2);

    return StaticDataReportB(
        messageType: messageType,
        mmsi: mmsi,
        repeatIndicator: repeatIndicator,
        partNumber: partNumber,
        vendorId: vendorId,
        vesselType: vesselType,
        vesselTypeInt: int.parse(vesselTypeBin, radix: 2),
        unitModel: unitModelCode,
        serialNumber: serialNumber,
        callSign: callSign,
        dimensionBow: dimensionBow,
        dimensionStern: dimensionStern,
        dimensionPort: dimensionPort,
        dimensionStarboard: dimensionStarboard,
        mothershipMMSI: motherShipMMSI,
        spare: spare
    );
  }

  factory StaticDataReportB.fromEncoded(String encoded) {
    String binary = encoded.padRight(168, '0'); // add padding of zeroes if second part got truncated.

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // binary ranges specific to type 24B
    int partNumber = getUintDirect(binary, 38, 40);
    String vesselType = BinaryConverter().getVesselTypeDirect(getUintDirect(binary, 40, 48));
    int vesselTypeInt = getUintDirect(binary, 40, 48);
    String vendorId = BinaryConverter().getVendorIdDirect(binary, 48, 66);
    int unitModel = getUintDirect(binary, 66, 70);
    int serialNumber = getUintDirect(binary, 70, 90);
    String callSign = BinaryConverter().getVesselCallSignDirect(binary, 90, 132);
    int dimensionBow = getUintDirect(binary, 132, 141);
    int dimensionStern = getUintDirect(binary, 141, 150);
    int dimensionPort = getUintDirect(binary, 150, 156);
    int dimensionStarboard = getUintDirect(binary, 156, 162);
    int mothershipMMSI = getUintDirect(binary, 132, 162);
    int spare = getUintDirect(binary, 162, 168);


    return StaticDataReportB(
        messageType: messageType,
        mmsi: mmsi,
        repeatIndicator: repeatIndicator,
        partNumber: partNumber,
        vesselTypeInt: vesselTypeInt,
        vesselType: vesselType,
        vendorId: vendorId,
        unitModel: unitModel,
        serialNumber: serialNumber,
        callSign: callSign,
        dimensionBow: dimensionBow,
        dimensionStern: dimensionStern,
        dimensionPort: dimensionPort,
        dimensionStarboard: dimensionStarboard,
        mothershipMMSI: mothershipMMSI,
        spare: spare
    );
  }
}

