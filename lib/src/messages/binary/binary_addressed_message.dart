import 'dart:typed_data';
import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

// ToDo: Maybe add actual data decoder but this is way out of scope for now
class BinaryAddressedMessage extends AISMessage {
  final int sequenceNumber;
  final int destinationMMSI;
  final int retransmit;
  final int spare;
  final int dac;
  final int fid;
  final Uint8List data;

  BinaryAddressedMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.sequenceNumber,
    required this.destinationMMSI,
    required this.retransmit,
    required this.spare,
    required this.dac,
    required this.fid,
    required this.data,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BinaryAddressedMessage &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        sequenceNumber == other.sequenceNumber &&
        destinationMMSI == other.destinationMMSI &&
        retransmit == other.retransmit &&
        spare == other.spare &&
        dac == other.dac &&
        fid == other.fid &&
        data == other.data;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    sequenceNumber,
    destinationMMSI,
    retransmit,
    spare,
    dac,
    fid,
    data,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Sequence: $sequenceNumber, Destination: $destinationMMSI, Retransmit: $retransmit, Spare: $spare, DAC: $dac, FID: $fid, Data: $data)';
  //endregion

  factory BinaryAddressedMessage.fromEncoded(String encoded) {
    String binary = encoded.padRight(1008, '0'); // ToDo: This is kind of inefficient - might have to change to an dynamic approach

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type 6 specific
    int sequenceNumber = getUintDirect(binary, 38, 40);
    int destinationMMSI = getUintDirect(binary, 40, 70);
    int retransmit = getUintDirect(binary, 70, 71);
    int spare = getUintDirect(binary, 71, 72);
    int dac = getUintDirect(binary, 72, 82);
    int fid = getUintDirect(binary, 82, 88);
    Uint8List data = getBytesDirect(binary, 88, 1009);

    return BinaryAddressedMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      sequenceNumber: sequenceNumber,
      destinationMMSI: destinationMMSI,
      retransmit: retransmit,
      spare: spare,
      dac: dac,
      fid: fid,
      data: data,
    );
  }
}