import 'package:ais_decoder/ais_decoder.dart';

void main() {
  // --- Example 1: Type 1 Position Report (Class A) ---
  // A vessel reporting its position, speed, and heading.
  const type1Sentence = '!AIVDM,1,1,,A,15RTgt0PAso;90TKcjM8h6g208CQ,0*4A';

  final positionMessage = AISMessage.fromString(type1Sentence) as PositionMessage;

  print('=== Type 1 — Position Report ===');
  print('MMSI:              ${positionMessage.mmsi}');
  print('Status:            ${positionMessage.navigationStatus}');
  print('Latitude:          ${positionMessage.latitude}°');
  print('Longitude:         ${positionMessage.longitude}°');
  print('Speed over ground: ${positionMessage.speedOverGround} kn');
  print('Course over ground:${positionMessage.courseOverGround}°');
  print('Heading:           ${positionMessage.heading}°');
  print('');

  // --- Example 2: Type 18 — Class B Position Report ---
  // Smaller vessels (e.g. leisure craft) transmit Type 18 instead of Type 1.
  const type18Sentence = '!AIVDM,1,1,,A,B52K>;h00Fc>jpUlNV@ikwpUoP06,0*4C';

  final classBMessage =
      AISMessage.fromString(type18Sentence) as StandardClassBCSPositionReport;

  print('=== Type 18 — Class B Position Report ===');
  print('MMSI:              ${classBMessage.mmsi}');
  print('Latitude:          ${classBMessage.latitude}°');
  print('Longitude:         ${classBMessage.longitude}°');
  print('Speed over ground: ${classBMessage.speedOverGround} kn');
  print('Course over ground:${classBMessage.courseOverGround}°');
  print('');

  // --- Example 3: Decoding from payload only ---
  // If you already extracted the payload field from the NMEA sentence,
  // use fromPayload() to skip the NMEA wrapper parsing.
  const rawPayload = '15RTgt0PAso;90TKcjM8h6g208CQ';

  final fromPayload = AISMessage.fromPayload(rawPayload) as PositionMessage;

  print('=== fromPayload() — same vessel, no NMEA wrapper ===');
  print('MMSI:    ${fromPayload.mmsi}');
  print('Lat/Lon: ${fromPayload.latitude}° / ${fromPayload.longitude}°');
  print('');

  // --- Example 4: Runtime type checking ---
  // fromString() returns AISMessage; cast to the concrete type for full fields.
  const unknownSentence = '!AIVDM,1,1,,A,15RTgt0PAso;90TKcjM8h6g208CQ,0*4A';

  final generic = AISMessage.fromString(unknownSentence);
  print('=== Dynamic dispatch on message type ===');
  print('Message type: ${generic.messageType}');
  if (generic is PositionMessage) {
    print('It is a position report — SOG: ${generic.speedOverGround} kn');
  }
}
