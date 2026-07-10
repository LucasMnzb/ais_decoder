import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/binary_conversion.dart';
import '../../utils/getInt.dart';

class SafetyRelatedBroadcastMessage extends AISMessage {
  final int spare;
  final String text;

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