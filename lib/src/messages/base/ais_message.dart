import 'package:ais_decoder/ais_decoder.dart';

/// The base type for every decoded AIS message.
///
/// All specific message types (e.g. [PositionMessage],
/// [StaticAndVoyageRelatedData]) extend this class and add fields specific
/// to their message type. Use [AISMessage.fromString] or
/// [AISMessage.fromPayload] to decode a raw AIS sentence into the
/// appropriate concrete subtype.
abstract class AISMessage {
  /// The AIS message type identifier (1-27), as defined by ITU-R M.1371.
  final int messageType;

  /// The MMSI (Maritime Mobile Service Identity) of the transmitting station.
  final int mmsi;

  /// The repeat indicator, used by repeaters to indicate how many times a
  /// message has been relayed. 0 indicates the original transmission.
  final int repeatIndicator;

  AISMessage({
    required this.messageType,
    required this.mmsi,
    required this.repeatIndicator,
  });

  /// Decodes a full AIS sentence, such as a `!AIVDM`/`!AIVDO` NMEA string,
  /// into the appropriate [AISMessage] subtype.
  ///
  /// Set [enableDebugging] to `true` for verbose logging output during
  /// development. Defaults to `false`.
  ///
  /// Set [legacy] to `true` to decode using the original string-based
  /// implementation instead of the current bit-based one. This is
  /// significantly slower and exists only for backward compatibility;
  /// new code should leave this `false` or just don't set the parameter.
  ///
  /// Throws [UnsupportedMessageTypeException] if [input] specifies a
  /// message type this package does not support.
  ///
  /// Throws [InvalidBinaryDataException] if [input] is empty or too short
  /// to be a valid AIS message.
  ///
  /// Throws [UnsupportedMessageTypeExceptionLegacy] if [input] specifies a
  /// message type the legacy version of this package does not support (try setting legacy to false in this case).
  factory AISMessage.fromString(String input, {bool enableDebugging = false, bool legacy = false}) =>
      MessageFactory.create(input, enableDebugging, legacy, false);

  /// Decodes a raw AIS payload (the six-bit-armored data field of an
  /// `!AIVDM`/`!AIVDO` sentence, without the surrounding NMEA wrapper)
  /// directly into the appropriate [AISMessage] subtype.
  ///
  /// See [AISMessage.fromString] for the meaning of [enableDebugging]
  /// and [legacy].
  factory AISMessage.fromPayload(String input, {bool enableDebugging = false, bool legacy = false}) =>
      MessageFactory.create(input, enableDebugging, legacy, true);
}