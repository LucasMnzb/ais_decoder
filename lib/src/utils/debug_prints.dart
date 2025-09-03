class DebugPrinter {
  final List<String> fields;

  DebugPrinter({required this.fields});

  void debugPrint() {
    // Print the extracted information => Debugging only might remove it in final version but helpful for now...
    if (fields[0] == "!AIVDM") {
      print("True AIS sentence");
    }
    if (fields[1] == "1") {
      print('One Fraction only, no need for second package');
    } else if (fields[1] != "1") {
      print('Two Fraction Message, waiting for second Fraction');
    }
    if (fields[2] != '') {
      print(fields[2] + '. fragment of sentence');
    }
    if (fields[3] != "") {
      print("id: " + fields[3]);
    }
    if (fields[4] == "A" || fields[4] == "1") {
      print('161.975Mhz (87B)');
    } else if (fields[4] == "B" || fields[4] == "2") {
      print('162.025Mhz (88B)');
    }
  }
}