import 'dart:typed_data';
import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

// ToDo: Maybe add actual data decoder but this is way out of scope for now
class BinaryBroadcastMessage extends AISMessage {
  final int spare;
  final int dac;
  final int fid;
  final Uint8List data;

  BinaryBroadcastMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.dac,
    required this.fid,
    required this.data,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BinaryBroadcastMessage &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
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
    spare,
    dac,
    fid,
    data,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Spare: $spare, DAC: $dac, FID: $fid, Data: $data)';
  //endregion

  factory BinaryBroadcastMessage.fromEncoded(String encoded) {
    String binary = encoded.padRight(1008, '0'); // ToDo: This is kind of inefficient - might have to change to an dynamic approach

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type 8 specific
    int spare = getUintDirect(binary, 38, 40);
    int dac = getUintDirect(binary, 40, 50);
    int fid = getUintDirect(binary, 50, 56);
    Uint8List data = getBytesDirect(binary, 56, 1009);

    return BinaryBroadcastMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare,
      dac: dac,
      fid: fid,
      data: data,
    );
  }
}