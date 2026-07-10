# AIS Decoder

A comprehensive AIS (Automatic Identification System) message decoder library for Dart and Flutter applications.

## About

This library decodes NMEA AIS sentences (AIVDM format) into structured Dart objects, making it easy to work with maritime vessel data in your applications. Whether you're building fleet management systems, maritime tracking apps, or working with AIS receivers, this library handles the complex binary protocol parsing for you.

## Features

- **Easy to use**: Simple factory pattern for decoding AIS messages
- **Type safe**: Strongly typed message objects with proper null safety
- **Multipart support**: Handles multipart messages (like Message Type 5)
- **Coordinate precision**: Proper handling of different coordinate encodings
- **Extensible**: Clean architecture for adding new message types

## Currently Supported Message Types (full ITU-R M.1371)

- **Type 1, 2, 3**: Position Reports (Class A vessels)
- **Type 4**: Base Station Messages
- **Type 5**: Static and Voyage Related Data
- **Type 6, 7, 8**: Binary Messages
- **Type 9**: SAR Aircraft Position Reports
- **Type 10, 11**: UTC Date Inquiry and Response
- **Type 12, 13, 14**: Safety Related Messages
- **Type 15 , 16, 17**: Networking Messages
- **Type 18, 19**: Standard Class B Position Reports
- **Type 20**: Data Link Management Messages
- **Type 21**: Aid to Navigation Messages
- **Type 22, 23**: Channel Management and Group Assignment Messages
- **Type 24**: Static Data Reports (multipart)
- **Type 25, 26**: Single and Multiple Slot Binary Messages
- **Type 27**: Long Range AIS Broadcast Messages

## Roadmap

- [x] All 27+ standard AIS message types
- [x] Binary message support (Types 6, 8)
- [x] Specialized Binary message support (Types 25, 26)
- [x] Aid to Navigation messages (Type 21)
- [x] Base Station messages (Type 4)
- [x] Comprehensive test coverage
- [x] Performance optimizations
- [ ] Additional utility functions
- [ ] Full Binary Data Decoding

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  ais_decoder: ^0.1.0
```

Then run:
```bash
dart pub get
```

## Usage

### Basic Decoding

Full message decoding:
```dart
import 'package:ais_decoder/ais_decoder.dart';

// Decode a single NMEA sentence
String aisMessage = "!AIVDM,1,1,,A,13u?etPv2;0n:dDPwUM1U1Cb069D,0*23";
AISMessage message = AISMessage.fromString(aisMessage);

// Cast to specific message type for detailed data
if (message is PositionMessage) {
  print('Latitude: ${message.latitude}');
  print('Longitude: ${message.longitude}');
  print('Speed: ${message.speedOverGround} knots');
  print('Course: ${message.courseOverGround}°');
}
```

Only payload decoding:
```dart
import 'package:ais_decoder/ais_decoder.dart';

// Decode a single NMEA sentence
String aisPayload = "13u?etPv2;0n:dDPwUM1U1Cb069D";
AISMessage message = AISMessage.fromPayload(aisPayload);

// Cast to specific message type for detailed data
if (message is PositionMessage) {
  print('Latitude: ${message.latitude}');
  print('Longitude: ${message.longitude}');
  print('Speed: ${message.speedOverGround} knots');
  print('Course: ${message.courseOverGround}°');
}
```

Integrates neatly with the ```nmea``` package.

### Multipart Messages

For Multipart message decoding (Type 5) please combine the two payloads manually.

(Example):  ```!AIVDM,2,1,0,B,55M67F@000004?78000P59HET0000000000000001P,0*0C```

plus

```!AIVDM,2,2,0,B,<<<70P0N4m1E52CP00,2*3B```
    
become

```!AIVDM,2,1,0,B,55M67F@000004?78000P59HET0000000000000001P<<<70P0N4m1E52CP00,0*20```

A utility class for this will be provided in a future release.

**Important** For Type 24 Messages see below:

Type 24 Messages appear as Part A and Part B in the wild. The decoder will take any Part as normal Input and return a StaticDataReportA or StaticDataReportB Object respectively.

For Applications this means storing both Objects separately and then combining their data when needed - matching should be done via MMSI (existent in both Parts).

### Binary Messages

**Important** Binary Messages are not *directly* supported.

The data will be decoded into one big Uint8List field to be interpreted by the application.

Full binary decoding is part of the roadmap.

### Debug Mode

```dart
// Enable debug output for troubleshooting
AISMessage message = AISMessage.fromString(aisMessage, enableDebugging: true);
```

### Legacy Mode
```dart
// Enable legacy mode for whatever
AISMessage message = AISMessage.fromString(aisMessage, legacy: true);
```

Legacy mode is (as of version 0.1.1) **deprecated**. It uses a slower decoding logic and as such should not be used besides testing purposes.
Legacy mode does not and will not support all message types.

## Contributing

Contributions are welcome! This library aims to be the most comprehensive AIS decoder for Dart/Flutter.

- Bug reports and feature requests: [GitHub Issues](https://github.com/LucasMnzb/ais_decoder/issues)
- Pull requests: [GitHub PRs](https://github.com/LucasMnzb/ais_decoder/pulls)
- Documentation improvements
- Test coverage

## 📄 License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- ITU-R M.1371-5 specification for AIS technical standards
- [GPSD](https://gpsd.gitlab.io/gpsd/AIVDM.html) project for AIS protocol documentation
- The maritime development community

---

Made with ⚓ for the maritime Flutter community