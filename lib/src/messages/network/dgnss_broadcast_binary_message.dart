import 'dart:typed_data';
import 'package:ais_decoder/ais_decoder.dart';
import 'package:ais_decoder/src/utils/coordinate_utils.dart';
import '../../utils/getInt.dart';

class DgnssBroadcastBinaryMessage extends AISMessage {
  final int spare;
  final double? longitude;
  final double? latitude;
  final Uint8List data;

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