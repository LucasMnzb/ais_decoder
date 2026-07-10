/// Thrown when an AIS sentence contains a message type that this library does
/// not support.
///
/// [messageType] holds the raw integer type identifier (1–27) extracted from
/// the payload. Catch this exception to filter out unsupported types without
/// crashing.
///
/// See also [UnsupportedMessageTypeExceptionLegacy] for the equivalent
/// exception thrown by the legacy decoder path.
class UnsupportedMessageTypeException implements Exception {
  /// The unsupported AIS message type identifier (1–27).
  final int messageType;

  /// Creates an [UnsupportedMessageTypeException] for the given [messageType].
  UnsupportedMessageTypeException(this.messageType);

  @override
  String toString() => 'Unsupported AIS Message Type: $messageType';
}

/// Thrown when the legacy decoder path encounters a message type it does not
/// support.
///
/// This exception is only raised when `legacy: true` is passed to
/// [AISMessage.fromString] or [AISMessage.fromPayload]. If you receive this
/// exception, try decoding without the `legacy` flag, as the current decoder
/// supports a broader set of message types.
///
/// See also [UnsupportedMessageTypeException] for the equivalent exception
/// thrown by the standard decoder path.
class UnsupportedMessageTypeExceptionLegacy implements Exception {
  /// The unsupported AIS message type identifier encountered by the legacy
  /// decoder.
  final int messageType;

  /// Creates an [UnsupportedMessageTypeExceptionLegacy] for the given
  /// [messageType].
  UnsupportedMessageTypeExceptionLegacy(this.messageType);

  @override
  String toString() => 'Unsupported AIS Message Type in legacy mode: $messageType, check if supported without legacy';
}

/// Thrown when the raw AIS input is empty, too short, or otherwise malformed
/// to be decoded.
///
/// [reason] contains a human-readable description of what was wrong with the
/// input. This exception is raised before any field extraction occurs, so it
/// indicates a structural problem with the data rather than an unsupported
/// feature.
class InvalidBinaryDataException implements Exception {
  /// A human-readable description of why the input was considered invalid.
  final String reason;

  /// Creates an [InvalidBinaryDataException] with the given [reason].
  InvalidBinaryDataException(this.reason);

  @override
  String toString() => 'Invalid binary data: $reason';
}