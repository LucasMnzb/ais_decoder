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

  group('Performance Types 1, 5, 24A - Raw Speed', () {
    final iterations = 1000;

    final testCases = {
      'Type 1': '!AIVDM,1,1,,A,13lLUr02j01br3REUdh`eW3608Dn,0*52',
      'Type 5': '!AIVDM,2,1,0,B,55M67F@000004?78000P59HET0000000000000001P<<<70P0N4m1E52CP00,0*20',
      'Type 24': '!AIVDM,1,1,,A,H4hJJ>0ME@DD000000000000000,2*46',
    };

    void runBenchmark(String label, bool legacy) {
      test(label, () {
        testCases.forEach((typeName, message) {
          // Warmup
          for (int i = 0; i < 100; ++i) {
            AISMessage.fromString(message, legacy: legacy);
          }

          // Measure
          final stopwatch = Stopwatch()..start();
          for (int i = 0; i < iterations; ++i) {
            AISMessage.fromString(message, legacy: legacy);
          }
          stopwatch.stop();

          print('$label - $typeName: average ${stopwatch.elapsedMicroseconds / iterations} μs');
        });
      });
    }

    runBenchmark('Old method (legacy)', true);
    runBenchmark('Direct method (not legacy)', false);
  });

  group('Performance Types 1, 5, 24A - Start vs End', () {
    final totalIterations = 10000; // each iteration = 3 messages * totalIterations = x total decodings
    final sampleSize = 10; // how many iterations to measure at start and end

    final testCases = {
      'Type 1': '!AIVDM,1,1,,A,13lLUr02j01br3REUdh`eW3608Dn,0*52',
      'Type 5': '!AIVDM,2,1,0,B,55M67F@000004?78000P59HET0000000000000001P<<<70P0N4m1E52CP00,0*20',
      'Type 24': '!AIVDM,1,1,,A,H4hJJ>0ME@DD000000000000000,2*46',
    };

    void decodeAll(bool legacy) {
      testCases.forEach((_, message) {
        AISMessage.fromString(message, legacy: legacy);
      });
    }

    void runBenchmark(String label, bool legacy) {
      test(label, () {
        final perIterationMicros = <int>[];

        for (int i = 0; i < totalIterations; ++i) {
          final sw = Stopwatch()..start();
          decodeAll(legacy);
          sw.stop();
          perIterationMicros.add(sw.elapsedMicroseconds);
        }

        final startSample = perIterationMicros.take(sampleSize).toList();
        final endSample = perIterationMicros.skip(totalIterations - sampleSize).toList();

        final startAvg = startSample.reduce((a, b) => a + b) / startSample.length;
        final endAvg = endSample.reduce((a, b) => a + b) / endSample.length;

        print('$label:');
        print('  Start (first $sampleSize iterations, ${sampleSize * 3} decodings): avg ${startAvg.toStringAsFixed(2)} μs/iteration');
        print('  End   (last $sampleSize iterations, ${sampleSize * 3} decodings):  avg ${endAvg.toStringAsFixed(2)} μs/iteration');
        print('  Delta: ${(endAvg - startAvg).toStringAsFixed(2)} μs (${((endAvg - startAvg) / startAvg * 100).toStringAsFixed(1)}%)');
      });
    }

    runBenchmark('Old method (legacy)', true);
    runBenchmark('Direct method (not legacy)', false);
  });
}
