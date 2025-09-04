import 'src/messages/specialized/basestation_report.dart';
import 'src/utils/convert_char_to_bin.dart';
import 'src/utils/debug_prints.dart';
import 'src/exceptions/ais_exceptions.dart';
import 'src/messages/base/ais_message.dart';
import 'src/messages/position/class_b_position.dart';
import 'src/messages/position/extended_class_b.dart';
import 'src/messages/position/long_range_broadcast.dart';
import 'src/messages/position/position_message.dart';
import 'src/messages/static/static_voyage_data.dart';


// ToDo: (For Release) Needs Extensive Documentation
// ToDo: (High Priority) Currently only can deal with single Fragment style AIS Sentences. Needs to be updated to also support sentences with more than one fragment!

class MessageFactory {
  static AISMessage create(String input, bool logging) {
    String binary = '';

    //region sanitizing
    if(input.isEmpty) {
      throw InvalidBinaryDataException(
          "Supplied String is empty or undefined!");
    }

    if(input.contains("!AIVDM") || input.contains("!AIVDO")) {
      print("Supplied !AIVDM String - Converting...");

      List<String> fields = input.split(',');

      // When logging is enabled print logging
      if(logging) DebugPrinter(fields: fields).debugPrint();

      for (String char in fields[5].split('')) {
        binary += convertCharToBinary(char);
      }
    } else {
      binary = input;
    }

    // minimum length for mmsi part of sentence
    if(binary.length < 38) {
      throw InvalidBinaryDataException("Supplied binary String too short (${binary.length} bits)!");
    }
    //endregion

    try {
      // get message type
      int messageType = int.parse(binary.substring(0,6), radix: 2);

      // switch to correct message type handling scenario
      return switch (messageType) {

      // Position reports
        1 || 2 || 3 => PositionMessage.fromBinary(binary),
        18 => StandardClassBCSPositionReport.fromBinary(binary),
        19 => ExtendedClassBCSPositionReport.fromBinary(binary),
        27 => LongRangeAISBroadcastMessage.fromBinary(binary),

      // Static data
        5 => StaticAndVoyageRelatedData.fromBinary(binary),
        // 24 => StaticDataReport.fromBinary(binary),

      // Safety src.messages
        // 12 => AddressedSafetyRelatedMessage.fromBinary(binary),
        // 13 => SafetyRelatedAcknowledgement.fromBinary(binary),
        // 14 => SafetyRelatedBroadcastMessage.fromBinary(binary),

      // Specialized
        4 => BaseStationReport.fromBinary(binary),
        // 21 => AidToNavigationReport.fromBinary(binary),

      // Binary src.messages
        // 6 => BinaryAddressedMessage.fromBinary(binary),
        // 8 => BinaryBroadcastMessage.fromBinary(binary),*/

        _ => throw UnsupportedMessageTypeException(messageType),
      };

    } catch (e) {
      throw Exception(e);
    }
  }

  // Helper method to check if a message type is supported ToDo: Update
  static bool isSupported(int messageType) {
    return [1, 2, 3, 4, 5, 18, 19, 24].contains(messageType);
  }

  // Helper method to get supported message types ToDo: Update
  static List<int> getSupportedTypes() {
    return [1, 2, 3, 4, 5, 18, 19, 24];
  }
}