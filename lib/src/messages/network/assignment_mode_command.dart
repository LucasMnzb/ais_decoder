import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

class AssignmentModeCommand extends AISMessage {
  final int spare;
  final int mmsi1;
  final int offset1;
  final int increment1;
  final int? mmsi2;
  final int? offset2;
  final int? increment2;

  AssignmentModeCommand({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.mmsi1,
    required this.offset1,
    required this.increment1,
    required this.mmsi2,
    required this.offset2,
    required this.increment2,
  });

  //region Overrides  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssignmentModeCommand &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        spare == other.spare &&
        mmsi1 == other.mmsi1 &&
        offset1 == other.offset1 &&
        increment1 == other.increment1 &&
        mmsi2 == other.mmsi2 &&
        offset2 == other.offset2 &&
        increment2 == other.increment2;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    spare,
    mmsi1,
    offset1,
    increment1,
    mmsi2,
    offset2,
    increment2,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Spare: $spare, MMSI1: $mmsi1, Offset1: $offset1, Increment1: $increment1, MMSI2: $mmsi2, Offset2: $offset2, Increment2: $increment2)';
  //endregion  

  factory AssignmentModeCommand.fromEncoded(String encoded) {
    String binary = encoded.padRight(144, '0');

    // common  
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type AssignmentModeCommand specific  
    int spare = getUintDirect(binary, 38, 40);
    int mmsi1 = getUintDirect(binary, 40, 70);
    int offset1 = getUintDirect(binary, 70, 82);
    int increment1 = getUintDirect(binary, 82, 92);
    int mmsi2 = getUintDirect(binary, 92, 122);
    int offset2 = getUintDirect(binary, 122, 134);
    int increment2 = getUintDirect(binary, 134, 144);

    return AssignmentModeCommand(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare,
      mmsi1: mmsi1,
      offset1: offset1,
      increment1: increment1,
      mmsi2: mmsi2 == 0 ? null: mmsi2,
      offset2: offset2 == 0 ? null : offset2,
      increment2: increment2 == 0 ? null : increment2,
    );
  }
}