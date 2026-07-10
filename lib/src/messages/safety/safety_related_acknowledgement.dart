import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

class SafetyRelatedAcknowledgement extends AISMessage {
  final int spare;
  final int mmsi1;
  final int mmsiSeq1;
  final int? mmsi2;
  final int? mmsiSeq2;
  final int? mmsi3;
  final int? mmsiSeq3;
  final int? mmsi4;
  final int? mmsiSeq4;


  SafetyRelatedAcknowledgement({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.mmsi1,
    required this.mmsiSeq1,
    required this.mmsi2,
    required this.mmsiSeq2,
    required this.mmsi3,
    required this.mmsiSeq3,
    required this.mmsi4,
    required this.mmsiSeq4,
  });

  //region Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SafetyRelatedAcknowledgement &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        spare == other.spare &&
        mmsi1 == other.mmsi1 &&
        mmsiSeq1 == other.mmsiSeq1 &&
        mmsi2 == other.mmsi2 &&
        mmsiSeq2 == other.mmsiSeq2 &&
        mmsi3 == other.mmsi3 &&
        mmsiSeq3 == other.mmsiSeq3 &&
        mmsi4 == other.mmsi4 &&
        mmsiSeq4 == other.mmsiSeq4;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    spare,
    mmsi1,
    mmsiSeq1,
    mmsi2,
    mmsiSeq2,
    mmsi3,
    mmsiSeq3,
    mmsi4,
    mmsiSeq4,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Spare: $spare, MMSI1: $mmsi1, Seq1: $mmsiSeq1, MMSI2: $mmsi2, Seq2: $mmsiSeq2, MMSI3: $mmsi3, Seq3: $mmsiSeq3, MMSI4: $mmsi4, Seq4: $mmsiSeq4)';
  //endregion

  factory SafetyRelatedAcknowledgement.fromEncoded(String encoded) {
    String binary = encoded.padRight(168, '0');

    // common
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type 12 specific
    int spare = getUintDirect(binary, 38, 40);
    int mmsi1 = getUintDirect(binary, 40, 70);
    int mmsiSeq1 = getUintDirect(binary, 70, 72);
    int mmsi2 = getUintDirect(binary, 72, 102);
    int mmsiSeq2 = getUintDirect(binary, 102, 104);
    int mmsi3 = getUintDirect(binary, 104, 134);
    int mmsiSeq3 = getUintDirect(binary, 134, 136);
    int mmsi4 = getUintDirect(binary, 136, 166);
    int mmsiSeq4 = getUintDirect(binary, 166, 168);

    return SafetyRelatedAcknowledgement(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare,
      mmsi1: mmsi1,
      mmsiSeq1: mmsiSeq1,
      mmsi2: mmsi2 == 0 ? null : mmsi2,
      mmsiSeq2: mmsiSeq2 == 0 ? null : mmsiSeq2,
      mmsi3: mmsi3 == 0 ? null : mmsi3,
      mmsiSeq3: mmsiSeq3 == 0 ? null : mmsiSeq3,
      mmsi4: mmsi4 == 0 ? null : mmsi4,
      mmsiSeq4: mmsiSeq4 == 0 ? null : mmsiSeq4,
    );
  }
}