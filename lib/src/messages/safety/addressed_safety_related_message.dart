import 'package:ais_decoder/ais_decoder.dart';
import 'package:ais_decoder/src/utils/binary_conversion.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 12 — Addressed Safety-Related Message.
///
/// A point-to-point text message directed at a single destination station,
/// used to convey safety-of-navigation information (e.g. ice warnings, urgent
/// navigational hazards). The plain-text content is decoded from the 6-bit
/// ASCII encoding used throughout AIS and stored in [text].
///
/// A [SafetyRelatedAcknowledgement] (Type 13) should be returned by the
/// recipient to confirm receipt.
class AddressedSafetyRelatedMessage extends AISMessage {
  /// Reserved spare bit (bit 71). Should be zero.
  final int spare;

  /// Message sequence number (0–3), used to match this message with its
  /// acknowledgement in a [SafetyRelatedAcknowledgement] (Type 13) response.
  final int sequenceNumber;

  /// MMSI of the intended recipient of this safety message.
  final int destinationMmsi;

  /// Retransmit flag. `1` indicates the message is being retransmitted;
  /// `0` means this is the original transmission.
  final int retransmit;

  /// Decoded safety-related text content, up to 156 characters. Encoded in
  /// the 6-bit ASCII character set defined by ITU-R M.1371.
  final String text;

  /// Creates an [AddressedSafetyRelatedMessage] with all fields supplied
  /// explicitly.
  ///
  /// Prefer [AddressedSafetyRelatedMessage.fromEncoded] for decoding a real
  /// AIS payload.
  AddressedSafetyRelatedMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.sequenceNumber,
    required this.destinationMmsi,
    required this.retransmit,
    required this.text,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressedSafetyRelatedMessage &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        spare == other.spare &&
        sequenceNumber == other.sequenceNumber &&
        destinationMmsi == other.destinationMmsi &&
        retransmit == other.retransmit &&
        text == other.text;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    spare,
    sequenceNumber,
    destinationMmsi,
    retransmit,
    text,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Spare: $spare, Sequence: $sequenceNumber, Destination: $destinationMmsi, Retransmit: $retransmit, Text: $text)';
  //endregion

  /// Decodes a six-bit-armored AIS payload string into an
  /// [AddressedSafetyRelatedMessage].
  ///
  /// [encoded] must be the payload field of a Type 12 NMEA sentence. The
  /// string is zero-padded to 1008 bits before parsing to accommodate the
  /// maximum allowed text length.
  factory AddressedSafetyRelatedMessage.fromEncoded(String encoded) {
    String binary = encoded.padRight(1008, '0'); // ToDo: This is kind of inefficient - might have to change to an dynamic approach

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type AddressedSafetyRelatedMessage specific
    int spare = getUintDirect(binary, 71, 72);
    int sequenceNumber = getUintDirect(binary, 38, 40);
    int destinationMmsi = getUintDirect(binary, 40, 70);
    int retransmit = getUintDirect(binary, 70, 71);
    String text = BinaryConverter().getTextFromSixBitCharacters(binary, 72, binary.length + 1);


    return AddressedSafetyRelatedMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare,
      sequenceNumber: sequenceNumber,
      destinationMmsi: destinationMmsi,
      retransmit: retransmit,
      text: text,
    );
  }
}