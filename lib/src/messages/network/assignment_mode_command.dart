import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 16 — Assignment Mode Command.
///
/// Transmitted by a base station to assign a specific TDMA slot schedule to
/// one or two mobile stations, overriding their autonomous reporting behaviour.
/// The first assignment ([mmsi1], [offset1], [increment1]) is always present.
/// The second assignment ([mmsi2], [offset2], [increment2]) is optional and
/// will be `null` when absent.
class AssignmentModeCommand extends AISMessage {
  /// Reserved spare bits (bits 38–39). Should be zero.
  final int spare;

  /// MMSI of the first station being assigned a slot schedule.
  final int mmsi1;

  /// TDMA slot offset for the first assigned station (0–4095). Defines the
  /// first slot within the current frame at which the station should transmit.
  final int offset1;

  /// Slot increment for the first assigned station (0–1023). The number of
  /// slots between successive transmissions. `0` means one-time assignment.
  final int increment1;

  /// MMSI of the second station being assigned a slot schedule, or `null`
  /// when only one assignment is present.
  final int? mmsi2;

  /// TDMA slot offset for the second assigned station, or `null` when
  /// [mmsi2] is absent.
  final int? offset2;

  /// Slot increment for the second assigned station, or `null` when [mmsi2]
  /// is absent.
  final int? increment2;

  /// Creates an [AssignmentModeCommand] with all fields supplied explicitly.
  ///
  /// Prefer [AssignmentModeCommand.fromEncoded] for decoding a real AIS payload.
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

  /// Decodes a six-bit-armored AIS payload string into an
  /// [AssignmentModeCommand].
  ///
  /// [encoded] must be the payload field of a Type 16 NMEA sentence. The
  /// string is zero-padded to 144 bits (the maximum two-assignment frame)
  /// before parsing. The optional second MMSI/offset/increment triple is
  /// returned as `null` when the underlying bits are all zero.
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