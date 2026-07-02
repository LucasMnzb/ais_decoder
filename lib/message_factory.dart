import 'package:ais_decoder/ais_decoder.dart';
import 'package:ais_decoder/src/utils/getInt.dart';
import 'src/utils/convert_char_to_bin.dart';
import 'src/utils/debug_prints.dart';



// ToDo: (For Release) Needs Extensive Documentation
// ToDo: (High Priority) Currently only can deal with single Fragment style AIS Sentences. Needs to be updated to also support sentences with more than one fragment!

class MessageFactory {
  static AISMessage create(String input, bool logging, bool legacy) {
    String binary = '';

    //region sanitizing
    if(input.isEmpty) {
      throw InvalidBinaryDataException(
          "Supplied String is empty or undefined!");
    }

    if(input.contains("!AIVDM") || input.contains("!AIVDO")) {
      // print("Supplied !AIVDM String - Converting...");

      List<String> fields = input.split(',');

      // When logging is enabled print logging
      if(logging) DebugPrinter(fields: fields).debugPrint();


      // Legacy Mode:
      if(legacy) {
        for (String char in fields[5].split('')) {
          binary += convertCharToBinary(char);
        }
      } else {
        binary = fields[5];
      }
    } else {
      // fallback if no AIVDM String is found
      binary = input;
    }

    // minimum length for mmsi part of sentence
    if(legacy && binary.length < 38) {
      throw InvalidBinaryDataException("Supplied binary String too short (${binary.length} bits)!");
    }
    //endregion

    try {
      // get message type
      int messageType = legacy ? int.parse(binary.substring(0,6), radix: 2) : getUintDirect(binary, 0, 6);
      int messagePart = legacy ? int.parse(binary.substring(38, 40), radix: 2) : getUintDirect(binary, 38, 40);
      if(messageType == 24) { messagePart = legacy ? int.parse(binary.substring(38, 40), radix: 2) : getUintDirect(binary, 38, 40); }

      // switch to correct message type handling scenario
      if(!legacy) {

        return switch (messageType) {

        // Position reports
          1 || 2 || 3 => PositionMessage.fromEncoded(binary),
          18 => StandardClassBCSPositionReport.fromBinary(binary),
          19 => ExtendedClassBCSPositionReport.fromBinary(binary),
          27 => LongRangeAISBroadcastMessage.fromBinary(binary),

        // Static data
          5 => StaticAndVoyageRelatedData.fromEncoded(binary),
          24 => messagePart == 0
              ? StaticDataReportA.fromBinary(binary)
              : StaticDataReportB.fromBinary(binary),

        // Safety src.messages
        // 12 => AddressedSafetyRelatedMessage.fromEncoded(binary),
        // 13 => SafetyRelatedAcknowledgement.fromEncoded(binary),
        // 14 => SafetyRelatedBroadcastMessage.fromEncoded(binary),

        // Specialized
          4 => BaseStationReport.fromBinary(binary),
        // 21 => AidToNavigationReport.fromEncoded(binary),

        // Binary src.messages
        // 6 => BinaryAddressedMessage.fromEncoded(binary),
        // 8 => BinaryBroadcastMessage.fromEncoded(binary),*/

          _ => throw UnsupportedMessageTypeException(messageType),
        };
      } else {
        return switch (messageType) {

        // Position reports
          1 || 2 || 3 => PositionMessage.fromBinary(binary),
          18 => StandardClassBCSPositionReport.fromBinary(binary),
          19 => ExtendedClassBCSPositionReport.fromBinary(binary),
          27 => LongRangeAISBroadcastMessage.fromBinary(binary),

        // Static data
          5 => StaticAndVoyageRelatedData.fromBinary(binary),
          24 =>
          messagePart == 0
              ? StaticDataReportA.fromBinary(binary)
              : StaticDataReportB.fromBinary(binary),

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
      }


    } catch (e) {
      throw Exception(e);
    }
  }

  // Helper method to check if a message type is supported ToDo: Update
  static bool isSupported(int messageType) {
    return [1, 2, 3, 4, 5, 18, 19, 24, 27].contains(messageType);
  }

  // Helper method to get supported message types ToDo: Update
  static List<int> getSupportedTypes() {
    return [1, 2, 3, 4, 5, 18, 19, 24, 27];
  }
}