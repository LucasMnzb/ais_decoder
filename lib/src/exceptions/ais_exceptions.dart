/// Custom Exception for unsupported message types!
class UnsupportedMessageTypeException implements Exception {
  final int messageType;
  UnsupportedMessageTypeException(this.messageType);

  @override
  String toString() => 'Unsupported AIS Message Type: $messageType';
}

/// Custom Exception for invalid binary data
class InvalidBinaryDataException implements Exception {
  final String reason;
  InvalidBinaryDataException(this.reason);

  @override
  String toString() => 'Invalid binary data: $reason';
}