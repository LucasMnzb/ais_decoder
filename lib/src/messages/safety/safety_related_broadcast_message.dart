import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/binary_conversion.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 14 — Safety-Related Broadcast Message.
///
/// An unaddressed broadcast of safety-of-navigation text intended for all
/// stations within range. Unlike [AddressedSafetyRelatedMessage] (Type 12),
/// there is no destination MMSI, sequence number, or retransmit flag, and no
/// acknowledgement is expected.
///
/// The plain-text content is decoded from the 6-bit ASCII encoding used
/// throughout AIS and stored in [text].
class SafetyRelatedBroadcastMessage extends AISMessage {
  /// Reserved spare bits (bits 38–39). Should be zero.
  final int spare;

  /// Decoded safety-related text content, up to 161 characters. Encoded in
  /// the 6-bit ASCII character set defined by ITU-R M.1371.
  final String text;

  /// Creates a [SafetyRelatedBroadcastMessage] with all fields supplied
  /// explicitly.
  ///
  /// Prefer [SafetyRelatedBroadcastMessage.fromEncoded] for decoding a real
  /// AIS payload.
  SafetyRelatedBroadcastMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.text,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SafetyRelatedBroadcastMessage &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        spare == other.spare &&
        text == other.text;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    spare,
    text,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Spare: $spare, Text: $text)';
  //endregion

  /// Decodes a six-bit-armored AIS payload string into a
  /// [SafetyRelatedBroadcastMessage].
  ///
  /// [encoded] must be the payload field of a Type 14 NMEA sentence. The
  /// string is zero-padded to 1008 bits before parsing to accommodate the
  /// maximum allowed text length.
  factory SafetyRelatedBroadcastMessage.fromEncoded(String encoded) {
    String binary = encoded.padRight(1008, '0'); // ToDo: This is kind of inefficient - might have to change to an dynamic approach

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type 8 specific
    int spare = getUintDirect(binary, 38, 40);
    String text = BinaryConverter().getTextFromSixBitCharacters(binary, 40, binary.length + 1);

    return SafetyRelatedBroadcastMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare,
      text: text
    );
  }
}