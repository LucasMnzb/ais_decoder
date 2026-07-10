import 'dart:typed_data';
import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

// ToDo: Maybe add actual data decoder but this is way out of scope for now

/// ITU-R M.1371 Message Type 6 — Addressed Binary Message.
///
/// A point-to-point binary message directed at a single destination vessel or
/// station identified by [destinationMMSI]. The payload is an application-
/// specific binary blob identified by a Designated Area Code ([dac]) and
/// Function Identifier ([fid]) pair, which together form the IMO application
/// identifier.
///
/// The raw [data] bytes are provided as-is; interpreting their content
/// requires knowledge of the specific DAC/FID application standard.
class BinaryAddressedMessage extends AISMessage {
  /// Message sequence number (0–3), used to match this message with its
  /// acknowledgement in a [BinaryAcknowledge] (Type 7) response.
  final int sequenceNumber;

  /// MMSI of the intended recipient of this message.
  final int destinationMMSI;

  /// Retransmit flag. `1` indicates the message is being retransmitted,
  /// `0` means this is the original transmission.
  final int retransmit;

  /// Reserved spare bit (bit 71). Should be zero.
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

  /// Creates a [BinaryAddressedMessage] with all fields supplied explicitly.
  ///
  /// Prefer [BinaryAddressedMessage.fromEncoded] for decoding a real AIS payload.
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

  /// Decodes a six-bit-armored AIS payload string into a
  /// [BinaryAddressedMessage].
  ///
  /// [encoded] must be the payload field of a Type 6 NMEA sentence. The string
  /// is zero-padded to 1008 bits before parsing to accommodate the maximum
  /// allowed payload length.
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