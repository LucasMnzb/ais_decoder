///Converts Ascii Text used in AIS Strings to Binary.
String convertCharToBinary(String char) {
  int asciiValue = char.codeUnitAt(0);

  // AIS 6-bit ASCII conversion
  int aisValue = asciiValue - 48;
  if (aisValue > 40) {
    aisValue = aisValue - 8;
  }

  // Convert to 6-bit binary string (pad with leading zeros)
  return aisValue.toRadixString(2).padLeft(6, '0');
}