import 'package:ais_decoder/ais_decoder.dart';
import 'package:ais_decoder/src/utils/getInt.dart';
import 'src/utils/convert_char_to_bin.dart';
import 'src/utils/debug_prints.dart';



// ToDo: (For Release) Needs Extensive Documentation
// ToDo: (High Priority) Currently only can deal with single Fragment style AIS Sentences. Needs to be updated to also support sentences with more than one fragment!
// ToDo: (Medium Priority) isPayload should be later moved into a separate function if any more parameters become necessary, fine for now - for later documentation: isPayload bypasses the String splitting via , and just passes the payload directly into encoded.

class MessageFactory {
  static AISMessage create(String input, bool logging, bool legacy, bool isPayload) {
    String encoded = '';

    //region sanitizing

    //legacy method to create binary String from input String
    String makeBinaryString(String input) {
      String binaryOutput = '';
      for (String char in input.split('')) {
        binaryOutput += convertCharToBinary(char);
      }
      return binaryOutput;
    }
    
    if(input.isEmpty) {
      throw InvalidBinaryDataException(
          "Supplied String is empty or undefined!");
    }

    if(input.contains("!AIVDM") || input.contains("!AIVDO")) {

      List<String> fields = input.split(',');

      // When logging is enabled print logging
      if(logging) DebugPrinter(fields: fields).debugPrint();
      
      // Legacy Mode:
      if(legacy) {
        encoded = isPayload ? input : makeBinaryString(fields[5]);
      } else {
        encoded = isPayload ? input : fields[5];
      }
      
    } else {
      // fallback if no AIVDM String is found aka is payload
      encoded = input;
    }

    // minimum length for mmsi part of sentence
    if(legacy && encoded.length < 38) {
      throw InvalidBinaryDataException("Supplied binary String too short (${encoded.length} bits)!");
    }
    //endregion

    try {
      // get message type
      int messageType = legacy ? int.parse(encoded.substring(0,6), radix: 2) : getUintDirect(encoded, 0, 6);
      int messagePart = legacy ? int.parse(encoded.substring(38, 40), radix: 2) : getUintDirect(encoded, 38, 40);
      if(messageType == 24) { messagePart = legacy ? int.parse(encoded.substring(38, 40), radix: 2) : getUintDirect(encoded, 38, 40); }

      // switch to correct message type handling scenario
      if(!legacy) {

        return switch (messageType) {

        // Position reports
          1 || 2 || 3 => PositionMessage.fromEncoded(encoded),
          18 => StandardClassBCSPositionReport.fromEncoded(encoded),
          19 => ExtendedClassBCSPositionReport.fromEncoded(encoded),
          27 => LongRangeAISBroadcastMessage.fromEncoded(encoded),

        // Static data
          5 => StaticAndVoyageRelatedData.fromEncoded(encoded),
          24 => messagePart == 0
              ? StaticDataReportA.fromEncoded(encoded)
              : StaticDataReportB.fromEncoded(encoded),

        // Safety src.messages
        // 12 => AddressedSafetyRelatedMessage.fromEncoded(encoded),
        // 13 => SafetyRelatedAcknowledgement.fromEncoded(encoded),
        // 14 => SafetyRelatedBroadcastMessage.fromEncoded(encoded),

        // Specialized
          4 => BaseStationReport.fromBinary(makeBinaryString(encoded)),
        // 21 => AidToNavigationReport.fromEncoded(encoded),

        // Binary src.messages
        // 6 => BinaryAddressedMessage.fromEncoded(encoded),
        // 8 => BinaryBroadcastMessage.fromEncoded(encoded),*/

          _ => throw UnsupportedMessageTypeException(messageType),
        };
      } else {
        return switch (messageType) {

        // Position reports
          1 || 2 || 3 => PositionMessage.fromBinary(encoded),
          18 => StandardClassBCSPositionReport.fromBinary(encoded),
          19 => ExtendedClassBCSPositionReport.fromBinary(encoded),
          27 => LongRangeAISBroadcastMessage.fromBinary(encoded),

        // Static data
          5 => StaticAndVoyageRelatedData.fromBinary(encoded),
          24 =>
          messagePart == 0
              ? StaticDataReportA.fromBinary(encoded)
              : StaticDataReportB.fromBinary(encoded),

        // Specialized
          4 => BaseStationReport.fromBinary(encoded),

          _ => throw UnsupportedMessageTypeExceptionLegacy(messageType),
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
  static bool isSupportedByLegacy(int messageType) {
    return [1, 2, 3, 4, 5, 18, 19, 24, 27].contains(messageType);
  }

  // Helper method to get supported message types ToDo: Update
  static List<int> getSupportedTypes() {
    return [1, 2, 3, 4, 5, 18, 19, 24, 27];
  }
}