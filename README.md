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

## Currently Supported Message Types

- **Type 1, 2, 3**: Position Reports (Class A vessels)
- **Type 5**: Static and Voyage Related Data
- **Type 18, 19**: Standard Class B Position Reports
- **Type 27**: Long Range AIS Broadcast Messages

## Roadmap

- [ ] All 27+ standard AIS message types
- [ ] Binary message support (Types 6, 8, 25, 26)
- [ ] Aid to Navigation messages (Type 21)
- [x] Base Station messages (Type 4)
- [ ] Comprehensive test coverage
- [ ] Performance optimizations
- [ ] Additional utility functions

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

### Multipart Messages

**Important** As of this version Multipart messages are not directly supported.

For Multipart message decoding (Type 5) please just combine the two payloads manually.

(Example):  !AIVDM,2,1,0,B,55M67F@000004?78000P59HET0000000000000001P,0*0C + !AIVDM,2,2,0,B,<<<70P0N4m1E52CP00,2*3B
            
!AIVDM,2,1,0,B,55M67F@000004?78000P59HET0000000000000001P<<<70P0N4m1E52CP00,0*20

A utility class for this will be provided in a future release.

### Debug Mode

```dart
// Enable debug output for troubleshooting
AISMessage message = AISMessage.fromString(aisMessage, enableDebugging: true);
```

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