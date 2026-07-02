int getUintDirect(String encoded, int startBit, int endBit) {
  int value = 0;
  int i = startBit;

  while (i < endBit) {
    final charIndex = i ~/ 6;
    final bitOffsetInChar = i % 6;
    final bitsAvailableInChar = 6 - bitOffsetInChar;
    final bitsNeeded = endBit - i;
    final bitsToTake = bitsAvailableInChar < bitsNeeded ? bitsAvailableInChar : bitsNeeded;

    int chunk;
    if (charIndex >= encoded.length) {
      chunk = 0; // padding, mirrors padRight(..., '0') on the old binary string
    } else {
      int aisValue = encoded.codeUnitAt(charIndex) - 48;
      if (aisValue > 40) aisValue -= 8;

      final shiftAmount = 6 - bitOffsetInChar - bitsToTake;
      final mask = (1 << bitsToTake) - 1;
      chunk = (aisValue >> shiftAmount) & mask;
    }

    value = value * (1 << bitsToTake) + chunk; // multiply, not <<, for web safety
    i += bitsToTake;
  }
  return value;
}

int getSignedIntDirect(String encoded, int startBit, int endBit) {
  final length = endBit - startBit;
  int value = getUintDirect(encoded, startBit, endBit);   // read bits as if unsigned
  if (value >= (1 << (length - 1))) {                     // top bit is set?
    value -= (1 << length);                                // reinterpret as negative
  }
  return value;
}