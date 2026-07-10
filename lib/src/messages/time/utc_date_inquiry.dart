import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

class UtcDateInquiry extends AISMessage {
  final int spare;
  final destinationMmsi;
  final int spare2;

  UtcDateInquiry({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.destinationMmsi,
    required this.spare2,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UtcDateInquiry &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        spare == other.spare &&
        destinationMmsi == other.destinationMmsi &&
        spare2 == other.spare2;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    spare,
    destinationMmsi,
    spare2
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Spare: $spare, Destination MMSI: $destinationMmsi, Spare2: $spare2)';
  //endregion

  factory UtcDateInquiry.fromEncoded(String encoded) {
    String binary = encoded.padRight(72, '0');

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type UtcDateInquiry specific
    int spare = getUintDirect(binary, 38, 40);
    int destinationMmsi = getUintDirect(binary, 40, 70);
    int spare2 = getUintDirect(binary, 70, 72);


    return UtcDateInquiry(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare,
      destinationMmsi: destinationMmsi,
      spare2: spare2,
    );
  }
}