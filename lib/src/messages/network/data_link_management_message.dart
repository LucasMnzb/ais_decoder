import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

class DataLinkManagementMessage extends AISMessage {
  final int spare;
  final int offset1;
  final int number1;
  final int timeout1;
  final int increment1;
  final int? offset2;
  final int? number2;
  final int? timeout2;
  final int? increment2;
  final int? offset3;
  final int? number3;
  final int? timeout3;
  final int? increment3;
  final int? offset4;
  final int? number4;
  final int? timeout4;
  final int? increment4;

  DataLinkManagementMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.offset1,
    required this.number1,
    required this.timeout1,
    required this.increment1,
    required this.offset2,
    required this.number2,
    required this.timeout2,
    required this.increment2,
    required this.offset3,
    required this.number3,
    required this.timeout3,
    required this.increment3,
    required this.offset4,
    required this.number4,
    required this.timeout4,
    required this.increment4,
  });

  //region Overrides  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DataLinkManagementMessage &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        spare == other.spare &&
        offset1 == other.offset1 &&
        number1 == other.number1 &&
        timeout1 == other.timeout1 &&
        increment1 == other.increment1 &&
        offset2 == other.offset2 &&
        number2 == other.number2 &&
        timeout2 == other.timeout2 &&
        increment2 == other.increment2 &&
        offset3 == other.offset3 &&
        number3 == other.number3 &&
        timeout3 == other.timeout3 &&
        increment3 == other.increment3 &&
        offset4 == other.offset4 &&
        number4 == other.number4 &&
        timeout4 == other.timeout4 &&
        increment4 == other.increment4;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    spare,
    offset1,
    number1,
    timeout1,
    increment1,
    offset2,
    number2,
    timeout2,
    increment2,
    offset3,
    number3,
    timeout3,
    increment3,
    offset4,
    number4,
    timeout4,
    increment4,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Spare: $spare, Offset1: $offset1, Number1: $number1, Timeout1: $timeout1, Increment1: $increment1, Offset2: $offset2, Number2: $number2, Timeout2: $timeout2, Increment2: $increment2, Offset3: $offset3, Number3: $number3, Timeout3: $timeout3, Increment3: $increment3, Offset4: $offset4, Number4: $number4, Timeout4: $timeout4, Increment4: $increment4)';
  //endregion  

  factory DataLinkManagementMessage.fromEncoded(String encoded) {
    String binary = encoded.padRight(160, '0');

    // common  
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type DataLinkManagementMessage specific  
    int spare = getUintDirect(binary, 38, 40);
    int offset1 = getUintDirect(binary, 40, 52);
    int number1 = getUintDirect(binary, 52, 56);
    int timeout1 = getUintDirect(binary, 56, 59);
    int increment1 = getUintDirect(binary, 59, 70);
    int offset2 = getUintDirect(binary, 70, 82);
    int number2 = getUintDirect(binary, 82, 86);
    int timeout2 = getUintDirect(binary, 86, 89);
    int increment2 = getUintDirect(binary, 89, 100);
    int offset3 = getUintDirect(binary, 100, 112);
    int number3 = getUintDirect(binary, 112, 116);
    int timeout3 = getUintDirect(binary, 116, 119);
    int increment3 = getUintDirect(binary, 119, 130);
    int offset4 = getUintDirect(binary, 130, 142);
    int number4 = getUintDirect(binary, 142, 146);
    int timeout4 = getUintDirect(binary, 146, 149);
    int increment4 = getUintDirect(binary, 149, 160);

    return DataLinkManagementMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare,
      offset1: offset1,
      number1: number1,
      timeout1: timeout1,
      increment1: increment1,
      offset2: offset2 == 0 ? null : offset2,
      number2: number2 == 0 ? null : number2,
      timeout2: timeout2 == 0 ? null : timeout2,
      increment2: increment2 == 0 ? null : increment2,
      offset3: offset3 == 0 ? null : offset3,
      number3: number3 == 0 ? null : number3,
      timeout3: timeout3 == 0 ? null : timeout3,
      increment3: increment3 == 0 ? null : increment3,
      offset4: offset4 == 0 ? null : offset4,
      number4: number4 == 0 ? null : number4,
      timeout4: timeout4 == 0 ? null : timeout4,
      increment4: increment4 == 0 ? null : increment4,
    );
  }
}