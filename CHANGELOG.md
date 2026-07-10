## 1.0.1'

* Minor refactor to comply to Darts linting rules.

## 1.0.0

* First stable release — all 27 ITU-R M.1371 message types implemented and tested.
* Added working pub.dev example (`example/example.dart`).
* Expanded documentation and API dartdoc comments across all public types.
* Stable public API: `AISMessage.fromString()` and `AISMessage.fromPayload()` are
  considered stable going forward.

## 0.1.2

* Completed implementation of all 27 ITU-R M.1371 message types, covering
  position reports (Types 1–3, 9, 18, 19, 27), static & voyage data (Types 5,
  24), binary messages (Types 6–8, 25, 26), network messages (Types 10, 15–17,
  20, 22, 23), safety messages (Types 12–14), and specialized reports (Types 4,
  21).
* Added unit tests for every supported message type using real-world AIS data.

## 0.1.1

* Replaced the original string-based binary decoding algorithm with a direct
  bit-manipulation approach, significantly improving decoding performance.
* Introduced `AISMessage.fromString()` for full NMEA sent
* The original string-based implementation is retained as a legacy mode and can
  still be selected via the `legacy` flag on `AISMessage.fromString()` and
  `AISMessage.fromPayload()`.

## 0.1.0

* Initial release.
* Implemented decoding for Class A position reports (Types 1–3), static &
  voyage data (Type 5), Class B position reports (Types 18, 19), base station
  reports (Type 4), and static data reports (Type 24).
* Introduced `AISMessage.fromString()` for full NMEA sentences.
* Supports all major platforms: Android, iOS, Linux, macOS, Windows, Web.
