import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 15 — Interrogation.
///
/// Sent by a base station or mobile station to request specific message types
/// from one or two target stations. Each interrogation specifies the desired
/// AIS message type and a slot offset at which the response should be
/// transmitted.
///
/// Structure:
/// - [mmsi1] is always present and receives the first interrogation
///   ([type1_1] / [offset1_1]).
/// - A second interrogation directed at [mmsi1] ([type1_2] / [offset1_2]) is
///   optional.
/// - A second target station ([mmsi2]) with one interrogation
///   ([type2_1] / [offset2_1]) is also optional.
class InterrogationMessage extends AISMessage {
  /// Reserved spare bits (bits 38–39). Should be zero.
  final int spare;

  /// MMSI of the first interrogated station.
  final int mmsi1;

  /// AIS message type requested from [mmsi1] in the first interrogation.
  final int type1_1;

  /// Slot offset at which [mmsi1] should reply to the first interrogation
  /// (0–4095). `0` means no specific slot preference.
  final int offset1_1;

  /// AIS message type requested from [mmsi1] in the optional second
  /// interrogation, or `null` if absent.
  final int? type1_2;

  /// Slot offset for the optional second interrogation directed at [mmsi1],
  /// or `null` if [type1_2] is absent.
  final int? offset1_2;

  /// MMSI of the optional second interrogated station, or `null` if absent.
  final int? mmsi2;

  /// AIS message type requested from [mmsi2], or `null` if [mmsi2] is absent.
  final int? type2_1;

  /// Slot offset at which [mmsi2] should reply, or `null` if [mmsi2] is absent.
  final int? offset2_1;

  /// Creates an [InterrogationMessage] with all fields supplied explicitly.
  ///
  /// Prefer [InterrogationMessage.fromEncoded] for decoding a real AIS payload.
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

  /// Decodes a six-bit-armored AIS payload string into an
  /// [InterrogationMessage].
  ///
  /// [encoded] must be the payload field of a Type 15 NMEA sentence. The
  /// string is zero-padded to 160 bits before parsing. Optional fields whose
  /// underlying bits are all zero are returned as `null`.
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