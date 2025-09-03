class CoordinateUtils {

  double? calculateLongitude(String binaryLongitude) {
    int rawLongitude = _parseSignedBinary(binaryLongitude);

    int nrBits = binaryLongitude.length;

    if (nrBits == 18) {
      // Type 27: 18 bits, 1/10 minute resolution
      double? result = _calculateCoordinate(rawLongitude, 600, 181 * 600);
      return result;
    } else if (nrBits == 25) {
      // Standard for types 1 - 3
      double? result = _calculateCoordinate(rawLongitude, 60000, 181 * 60000);
      return result;
    } else if (nrBits == 28) {
      double? result = _calculateCoordinate(rawLongitude, 600000, 181 * 600000);
      return result;
    } else {
      return null;
    }
  }

  double? calculateLatitude(String binaryLatitude) {
    int rawLatitude = _parseSignedBinary(binaryLatitude);

    int nrBits = binaryLatitude.length;

    if (nrBits == 17) {
      // Type 27: 17 bits, 1/10 minute resolution
      double? result = _calculateCoordinate(rawLatitude, 600, 91 * 600);
      return result;
    } else if (nrBits == 24) {
      // Standard for types 1 - 3
      double? result = _calculateCoordinate(rawLatitude, 60000, 91 * 60000);
      return result;
    } else if (nrBits == 27) {
      double? result = _calculateCoordinate(rawLatitude, 600000, 91 * 600000);
      return result;
    } else {
      return null;
    }
  }

// Properly parse two's complement binary
  int _parseSignedBinary(String binary) {
    int value = int.parse(binary, radix: 2);
    int bitLength = binary.length;

    // If MSB is 1, it's negative (two's complement)
    if (value >= (1 << (bitLength - 1))) {
      value = value - (1 << bitLength);
    }

    return value;
  }

// Unified coordinate calculation
  double? _calculateCoordinate(int rawValue, int factor, int invalidValue) {
    if (rawValue == invalidValue) {
      return null; // Invalid/unavailable
    }

    double degrees = rawValue / factor.toDouble();
    return double.parse(degrees.toStringAsFixed(6));
  }
}