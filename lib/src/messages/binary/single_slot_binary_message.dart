import 'dart:typed_data';

import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

class SingleSlotBinaryMessage extends AISMessage {
  final int destinationIndicator;
  final int binaryDataFlag;
  final int? destinationMmsi;
  final int? applicationId;
  final int? dac;
  final int? fid;
  final Uint8List data;

  SingleSlotBinaryMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.destinationIndicator,
    required this.binaryDataFlag,
    required this.destinationMmsi,
    required this.applicationId,
    required this.dac,
    required this.fid,
    required this.data,
  });

  //region Overrides  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SingleSlotBinaryMessage &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        destinationIndicator == other.destinationIndicator &&
        binaryDataFlag == other.binaryDataFlag &&
        destinationMmsi == other.destinationMmsi &&
        applicationId == other.applicationId &&
        dac == other.dac &&
        fid == other.fid &&
        data == other.data;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    destinationIndicator,
    binaryDataFlag,
    destinationMmsi,
    applicationId,
    dac,
    fid,
    data,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Destination Indicator: $destinationIndicator, Binary Data Flag: $binaryDataFlag, Destination MMSI: $destinationMmsi, Application ID: $applicationId, DAC: $dac, FID: $fid, Data: $data)';
  //endregion  

  factory SingleSlotBinaryMessage.fromEncoded(String encoded) {
    String binary = encoded.padRight(168, '0');

    // common  
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type 25 specific
    int destinationIndicator = getUintDirect(binary, 38, 39);
    int binaryDataFlag = getUintDirect(binary, 39, 40);
    int? destinationMmsi = destinationIndicator == 1 ? getUintDirect(binary, 40, 70) : null;
    // Extract applicationId from binary payload at destination-specific bit offset (70-86 or 40-56); null if not binary-encoded
    int? applicationId = destinationIndicator == 1 && binaryDataFlag == 1 ? getUintDirect(binary, 70, 86) : destinationIndicator == 0 && binaryDataFlag == 1 ? getUintDirect(binary, 40, 56) : null;
    int? dac = applicationId != null ? applicationId >> 6 : null;
    int? fid = applicationId != null ? applicationId & 0x3F : null;

    // oh god
    int dataStart = destinationMmsi == null && applicationId == null ? 40 : destinationMmsi != null && applicationId == null ? 70 : destinationMmsi == null && applicationId != null ? 56 : 86;

    Uint8List data = getBytesDirect(binary, dataStart, 168);


    return SingleSlotBinaryMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      destinationIndicator: destinationIndicator,
      binaryDataFlag: binaryDataFlag,
      destinationMmsi: destinationMmsi,
      applicationId: applicationId,
      dac: dac,
      fid: fid,
      data: data,
    );
  }
}