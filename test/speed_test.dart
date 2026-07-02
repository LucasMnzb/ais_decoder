import 'package:ais_decoder/ais_decoder.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  String aisMessage = "!AIVDM,2,1,0,B,55M67F@000004?78000P59HET0000000000000001P<<<70P0N4m1E52CP00,0*20";

  StaticAndVoyageRelatedData legacy = AISMessage.fromString(aisMessage, legacy: true) as StaticAndVoyageRelatedData;
  StaticAndVoyageRelatedData notLegacy = AISMessage.fromString(aisMessage, legacy: false) as StaticAndVoyageRelatedData;

  group('Correctness', () {
    test('Old and direct methods produce identical decoded fields', () {
      final oldResult = legacy;
      final directResult = notLegacy;
      print('Old:    $oldResult');
      print('Direct: $directResult');
      expect(directResult, equals(oldResult));

      // Basic sanity check derived from the payload's first character alone:
      // '5' -> AIS 6-bit value 5 -> message type field (bits 0-5) = 5.
      // expect(oldResult.messageType, equals(1));
    });
  });

  group('Performance', () {
    final iterations = 1000;

    test('Old method (legacy)', () {
      for (int i = 0; i < 100; ++i) {
        final _ = AISMessage.fromString(aisMessage, legacy: true);
      }
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < iterations; ++i) {
        final _ = AISMessage.fromString(aisMessage, legacy: true);
      }
      stopwatch.stop();
      print('Old method: average ${stopwatch.elapsedMicroseconds / iterations} μs');
    });

    test('Direct method (not legacy)', () {
      for (int i = 0; i < 100; ++i) {
        final _ = AISMessage.fromString(aisMessage, legacy: false);
      }
      final stopwatch = Stopwatch()..start();
      for (int i = 0; i < iterations; ++i) {
        final _ = AISMessage.fromString(aisMessage, legacy: false);
      }
      stopwatch.stop();
      print('Direct method: average ${stopwatch.elapsedMicroseconds / iterations} μs');
    });
  });
}
