import '../../../message_factory.dart';

abstract class AISMessage {
  final int messageType;
  final int mmsi;
  final int repeatIndicator;

  AISMessage({
    required this.messageType,
    required this.mmsi,
    required this.repeatIndicator,
  });

  /// # Method .fromString
  ///
  /// Supply either an already binary encoded AIS String or even simpler just supply the ```!AIVDM```String directly
  ///
  /// The enable debugging param is just for more extensive Logging output when developing, defaults to false!
  factory AISMessage.fromString(String input, {bool enableDebugging = false}) =>
      MessageFactory.create(input, enableDebugging);
}