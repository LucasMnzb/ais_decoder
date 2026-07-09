/// Custom Exception for unsupported message types!
class UnsupportedMessageTypeException implements Exception {
  final int messageType;
  UnsupportedMessageTypeException(this.messageType);

  @override
  String toString() => 'Unsupported AIS Message Type: $messageType';
}

class UnsupportedMessageTypeExceptionLegacy implements Exception {
  final int messageType;
  UnsupportedMessageTypeExceptionLegacy(this.messageType);

  @override
  String toString() => 'Unsupported AIS Message Type in legacy mode: $messageType, check if supported without legacy';
}

/// Custom Exception for invalid binary data
class InvalidBinaryDataException implements Exception {
  final String reason;
  InvalidBinaryDataException(this.reason);

  @override
  String toString() => 'Invalid binary data: $reason';
}