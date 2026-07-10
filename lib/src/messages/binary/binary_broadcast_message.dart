import 'dart:typed_data';
import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

// ToDo: Maybe add actual data decoder but this is way out of scope for now

/// ITU-R M.1371 Message Type 8 — Binary Broadcast Message.
///
/// An unaddressed, broadcast binary message intended for all stations within
/// range. Like [BinaryAddressedMessage], the payload is identified by a
/// Designated Area Code ([dac]) and Function Identifier ([fid]) pair that
/// specifies how the raw [data] bytes should be interpreted.
///
/// Because the message is a broadcast there is no destination MMSI, sequence
/// number, or retransmit flag.
///
/// The raw [data] bytes are provided as-is; interpreting their content
/// requires knowledge of the specific DAC/FID application standard.
class BinaryBroadcastMessage extends AISMessage {
  /// Reserved spare bits (bits 38–39). Should be zero.
  final int spare;

  /// Designated Area Code (DAC) — the 10-bit country or organization code
  /// that, combined with [fid], identifies the application standard governing
  /// [data].
  final int dac;

  /// Function Identifier (FID) — the 6-bit function code within the [dac]
  /// namespace that describes how to interpret [data].
  final int fid;

  /// Raw application-specific payload bytes. Decode according to the
  /// application standard identified by [dac] and [fid].
  final Uint8List data;

  /// Creates a [BinaryBroadcastMessage] with all fields supplied explicitly.
  ///
  /// Prefer [BinaryBroadcastMessage.fromEncoded] for decoding a real AIS payload.
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

  /// Decodes a six-bit-armored AIS payload string into a
  /// [BinaryBroadcastMessage].
  ///
  /// [encoded] must be the payload field of a Type 8 NMEA sentence. The string
  /// is zero-padded to 1008 bits before parsing to accommodate the maximum
  /// allowed payload length.
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