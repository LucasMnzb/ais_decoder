import 'dart:typed_data';

import 'package:ais_decoder/ais_decoder.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 26 — Multiple Slot Binary Message with
/// Communications State.
///
/// A variable-length binary message that occupies multiple TDMA slots and
/// always carries a 20-bit SOTDMA/ITDMA radio status word appended after the
/// payload. It may be either addressed (point-to-point) or broadcast depending
/// on [destinationIndicator], and the payload may carry a structured
/// application identifier ([dac] / [fid]) when [binaryDataFlag] is `1`.
///
/// Field presence rules:
/// - [destinationMmsi] is only present when [destinationIndicator] is `1`.
/// - [applicationId], [dac], and [fid] are only present when [binaryDataFlag]
///   is `1`.
///
/// The raw [data] bytes are provided as-is; interpreting their content
/// requires knowledge of the specific DAC/FID application standard (when
/// [binaryDataFlag] is `1`), or a proprietary format otherwise.
class MultipleSlotBinaryMessage extends AISMessage {
  /// Destination indicator flag.
  ///
  /// `1` means the message is addressed to [destinationMmsi];
  /// `0` means it is a broadcast with no specific destination.
  final int destinationIndicator;

  /// Binary data flag.
  ///
  /// `1` means the payload contains a structured application message
  /// identified by [dac] and [fid]; `0` means unstructured binary data.
  final int binaryDataFlag;

  /// MMSI of the intended recipient, or `null` when [destinationIndicator]
  /// is `0` (broadcast).
  final int? destinationMmsi;

  /// Combined 16-bit application identifier (DAC in the high 10 bits, FID in
  /// the low 6 bits), or `null` when [binaryDataFlag] is `0`.
  final int? applicationId;

  /// Designated Area Code (DAC) extracted from [applicationId], or `null`
  /// when [binaryDataFlag] is `0`.
  final int? dac;

  /// Function Identifier (FID) extracted from [applicationId], or `null`
  /// when [binaryDataFlag] is `0`.
  final int? fid;

  /// Raw application-specific payload bytes. Decode according to the
  /// application standard identified by [dac] and [fid] when
  /// [binaryDataFlag] is `1`.
  final Uint8List data;

  /// 20-bit SOTDMA/ITDMA radio status word appended at the end of the
  /// variable-length frame.
  final int radioStatus;

  /// Creates a [MultipleSlotBinaryMessage] with all fields supplied explicitly.
  ///
  /// Prefer [MultipleSlotBinaryMessage.fromEncoded] for decoding a real AIS payload.
  MultipleSlotBinaryMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.destinationIndicator,
    required this.binaryDataFlag,
    required this.destinationMmsi,
    required this.applicationId,
    required this.dac,
    required this.fid,
    required this.data,
    required this.radioStatus,
  });

  //region Overrides  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MultipleSlotBinaryMessage &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        destinationIndicator == other.destinationIndicator &&
        binaryDataFlag == other.binaryDataFlag &&
        destinationMmsi == other.destinationMmsi &&
        applicationId == other.applicationId &&
        dac == other.dac &&
        fid == other.fid &&
        data == other.data &&
        radioStatus == other.radioStatus;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    destinationIndicator,
    binaryDataFlag,
    destinationMmsi,
    applicationId,
    dac,
    fid,
    data,
    radioStatus,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Destination Indicator: $destinationIndicator, Binary Data Flag: $binaryDataFlag, Destination MMSI: $destinationMmsi, Application ID: $applicationId, DAC: $dac, FID: $fid, Data: $data, Radio Status: $radioStatus)';
  //endregion  

  /// Decodes a six-bit-armored AIS payload string into a
  /// [MultipleSlotBinaryMessage].
  ///
  /// [encoded] must be the payload field of a Type 26 NMEA sentence. The
  /// string is zero-padded to 1064 bits before parsing. The data field bounds
  /// and [radioStatus] position are computed dynamically from the actual
  /// trimmed payload length because Type 26 is variable-length.
  factory MultipleSlotBinaryMessage.fromEncoded(String encoded) {
    String binary = encoded.padRight(1064, '0');

    // common  
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type 25 specific
    int destinationIndicator = getUintDirect(binary, 38, 39);
    int binaryDataFlag = getUintDirect(binary, 39, 40);
    int? destinationMmsi = destinationIndicator == 1 ? getUintDirect(binary, 40, 70) : null;
    // Extract applicationId from binary payload at destination-specific bit offset (70-86 or 40-56); null if not binary-encoded
    int? applicationId = destinationIndicator == 1 && binaryDataFlag == 1 ? getUintDirect(binary, 70, 86) : destinationIndicator == 0 && binaryDataFlag == 1 ? getUintDirect(binary, 40, 56) : null;
    int? dac = applicationId != null ? applicationId >> 6 : null;
    int? fid = applicationId != null ? applicationId & 0x3F : null;

    // oh god
    int dataStart = destinationMmsi == null && applicationId == null ? 40 : destinationMmsi != null && applicationId == null ? 70 : destinationMmsi == null && applicationId != null ? 56 : 86;

    Uint8List data = getBytesDirect(binary, dataStart, binary.trimRight().length - 20);

    int radioStatus = getUintDirect(binary, binary.trimRight().length - 20, binary.trimRight().length);


    return MultipleSlotBinaryMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      destinationIndicator: destinationIndicator,
      binaryDataFlag: binaryDataFlag,
      destinationMmsi: destinationMmsi,
      applicationId: applicationId,
      dac: dac,
      fid: fid,
      data: data,
      radioStatus: radioStatus,
    );
  }
}