import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

class InterrogationMessage extends AISMessage {
  final int spare;
  final int mmsi1;
  final int type1_1;
  final int offset1_1;
  final int? type1_2;
  final int? offset1_2;
  final int? mmsi2;
  final int? type2_1;
  final int? offset2_1;

  InterrogationMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.mmsi1,
    required this.type1_1,
    required this.offset1_1,
    required this.type1_2,
    required this.offset1_2,
    required this.mmsi2,
    required this.type2_1,
    required this.offset2_1,
  });

  //region Overrides  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InterrogationMessage &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        spare == other.spare &&
        mmsi1 == other.mmsi1 &&
        type1_1 == other.type1_1 &&
        offset1_1 == other.offset1_1 &&
        type1_2 == other.type1_2 &&
        offset1_2 == other.offset1_2 &&
        mmsi2 == other.mmsi2 &&
        type2_1 == other.type2_1 &&
        offset2_1 == other.offset2_1;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    spare,
    mmsi1,
    type1_1,
    offset1_1,
    type1_2,
    offset1_2,
    mmsi2,
    type2_1,
    offset2_1,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Spare: $spare, MMSI1: $mmsi1, Type1_1: $type1_1, Offset1_1: $offset1_1, Type1_2: $type1_2, Offset1_2: $offset1_2, MMSI2: $mmsi2, Type2_1: $type2_1, Offset2_1: $offset2_1)';
  //endregion  

  factory InterrogationMessage.fromEncoded(String encoded) {
    String binary = encoded.padRight(160, '0');

    // common  
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type InterrogationMessage specific  
    int spare = getUintDirect(binary, 38, 40);
    int mmsi1 = getUintDirect(binary, 40, 70);
    int type1_1 = getUintDirect(binary, 70, 76);
    int offset1_1 = getUintDirect(binary, 76, 88);
    int type1_2 = getUintDirect(binary, 90, 96);
    int offset1_2 = getUintDirect(binary, 96, 108);
    int mmsi2 = getUintDirect(binary, 110, 140);
    int type2_1 = getUintDirect(binary, 140, 146);
    int offset2_1 = getUintDirect(binary, 146, 158);

    return InterrogationMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare,
      mmsi1: mmsi1,
      type1_1: type1_1,
      offset1_1: offset1_1,
      type1_2: type1_2 == 0 ? null : type1_2,
      offset1_2: offset1_2 == 0 ? null : offset1_2,
      mmsi2: mmsi2 == 0 ? null : mmsi2,
      type2_1: type2_1 == 0 ? null : type2_1,
      offset2_1: offset2_1 == 0 ? null : offset2_1,
    );
  }
}