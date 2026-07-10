import 'package:ais_decoder/ais_decoder.dart';
import 'package:ais_decoder/src/utils/binary_conversion.dart';
import '../../utils/getInt.dart';

class AddressedSafetyRelatedMessage extends AISMessage {
  final int spare;
  final int sequenceNumber;
  final int destinationMmsi;
  final int retransmit;
  final String text;

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