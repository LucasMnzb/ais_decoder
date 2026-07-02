import 'package:ais_decoder/ais_decoder.dart';
import 'package:test/test.dart';

void main() {
  group('TalkerSentencesTest', () {

    test('should return a decoded position sentence', () {

      const sentence = "!AIVDM,1,1,,A,13q5W0PP1fQEpJVO9V>pIVgp0D7k,0*66!";

      AISMessage aisMessage = AISMessage.fromString(sentence);

      expect(aisMessage, isA<PositionMessage>());

    });

    test('type 5 test', () {



      const multipart2 = "!AIVDO,2,1,0,A,51mg=5@00000IT00000IDpeT0000000000000000000000000020@R@R@00000000000000,2*26";


      AISMessage aisMessage = AISMessage.fromString(multipart2);

      expect(aisMessage, isA<StaticAndVoyageRelatedData>());

      var message = aisMessage as StaticAndVoyageRelatedData;

      print(aisMessage.messageType);
      print(message.destination);
      print(message);



    });
  });
}