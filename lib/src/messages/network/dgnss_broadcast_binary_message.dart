import 'dart:typed_data';
import 'package:ais_decoder/ais_decoder.dart';
import 'package:ais_decoder/src/utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

/// ITU-R M.1371 Message Type 17 — DGNSS Broadcast Binary Message.
///
/// Broadcast by a base station to distribute Differential GNSS (DGNSS)
/// correction data to vessels within range. The correction payload follows
/// the RTCM SC-104 standard and is carried as raw bytes in [data].
///
/// The [longitude] and [latitude] fields give the geographic position of the
/// transmitting base station, allowing receivers to assess the applicability
/// and accuracy of the corrections.
class DgnssBroadcastBinaryMessage extends AISMessage {
  /// Reserved spare bits (bits 38–39). Should be zero.
  final int spare;

  /// Longitude of the transmitting base station in decimal degrees (positive
  /// east), or `null` if the encoded value indicates unavailability.
  final double? longitude;

  /// Latitude of the transmitting base station in decimal degrees (positive
  /// north), or `null` if the encoded value indicates unavailability.
  final double? latitude;

  /// Raw RTCM SC-104 DGNSS correction payload bytes (bits 80–816).
  final Uint8List data;

  /// Creates a [DgnssBroadcastBinaryMessage] with all fields supplied explicitly.
  ///
  /// Prefer [DgnssBroadcastBinaryMessage.fromEncoded] for decoding a real AIS payload.
  DgnssBroadcastBinaryMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.spare,
    required this.longitude,
    required this.latitude,
    required this.data,
  });

  //region Overrides  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DgnssBroadcastBinaryMessage &&
        messageType == other.messageType &&
        mmsi == other.mmsi &&
        repeatIndicator == other.repeatIndicator &&
        spare == other.spare &&
        longitude == other.longitude &&
        latitude == other.latitude &&
        data == other.data;
  }

  @override
  int get hashCode => Object.hashAll([
    messageType,
    mmsi,
    repeatIndicator,
    spare,
    longitude,
    latitude,
    data,
  ]);

  @override
  String toString() => 'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Spare: $spare, Longitude: $longitude, Latitude: $latitude, Data: $data)';
  //endregion  

  /// Decodes a six-bit-armored AIS payload string into a
  /// [DgnssBroadcastBinaryMessage].
  ///
  /// [encoded] must be the payload field of a Type 17 NMEA sentence. The
  /// string is zero-padded to 816 bits before parsing. Position coordinates
  /// are decoded using 1/10-minute resolution for longitude (18-bit signed)
  /// and latitude (17-bit signed).
  factory DgnssBroadcastBinaryMessage.fromEncoded(String encoded) {
    String binary = encoded.padRight(816, '0');

    // common  
    int messageType = getUintDirect(binary, 0, 6);
    int repeatIndicator = getUintDirect(binary, 6, 8);
    int mmsi = getUintDirect(binary, 8, 38);

    // type DgnssBroadcastBinaryMessage specific  
    int spare = getUintDirect(binary, 38, 40);
    int longitudeBin = getSignedIntDirect(binary, 40, 58);
    int latitudeBin = getSignedIntDirect(binary, 58, 75);
    Uint8List data = getBytesDirect(binary, 80, 816);



    return DgnssBroadcastBinaryMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      spare: spare,
      longitude: CoordinateUtils().calculateLongitudeDirect(longitudeBin, 18),
      latitude: CoordinateUtils().calculateLatitudeDirect(latitudeBin, 17),
      data: data,
    );
  }
}