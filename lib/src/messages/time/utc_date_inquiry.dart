import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 10 — UTC/Date Inquiry.
///
/// Sent by any station to request the current UTC time and date from a
/// specific destination station. The recipient should respond with a
/// [UtcDateResponse] (Type 11) or a [BaseStationReport] (Type 4), which
/// carries the UTC timestamp and position of the responding station.
class UtcDateInquiry extends AISMessage {
  /// Reserved spare bits (bits 38–39). Should be zero.
  final int spare;

  /// MMSI of the station being asked to provide UTC date and time.
  final int destinationMmsi;

  /// Reserved spare bits (bits 70–71). Should be zero.
  final int spare2;

  /// Creates a [UtcDateInquiry] with all fields supplied explicitly.
  ///
  /// Prefer [UtcDateInquiry.fromEncoded] for decoding a real AIS payload.
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

  /// Decodes a six-bit-armored AIS payload string into a [UtcDateInquiry].
  ///
  /// [encoded] must be the payload field of a Type 10 NMEA sentence. The
  /// string is zero-padded to 72 bits before parsing.
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