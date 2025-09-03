class BinaryConverter {

  String getVesselCallSign(String binaryCallSign) {
    if(binaryCallSign.length % 6 != 0){
      throw Exception('Input binary Message String for Name must be multiple of 6');
    }

    // AIS 6-bit ASCII character set (64 characters total)
    const aisChars = '@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_ !"#\$%&\'()*+,-./0123456789:;<=>?';


    List<String> segments = [];
    for(int i = 0; i < binaryCallSign.length; i+= 6) {
      segments.add(binaryCallSign.substring(i, i+6));
    }

    String result = "";

    for(String segment in segments) {
      int decimalValue = int.parse(segment, radix: 2);
      if(decimalValue >= 0 && decimalValue < aisChars.length ) {
        result += aisChars[decimalValue];
      } else {
        result += '@';
      }
    }
    return result;
  }

  ///Function to get the AIS Version of the used System.
  String getAISVersion(String binaryAISVersion) {
    final version = int.parse(binaryAISVersion, radix: 2);
    if(version == 0) {
      return "ITU1371";
    } else {
      return "Unknown AIS Version";
    }

  }

  ///Get the Name of the Vessel.
  String getVesselName(String binaryVesselName) {
    if(binaryVesselName.length % 6 != 0){
      throw Exception('Input binary Message String for Name must be multiple of 6');
    }

    // AIS 6-bit ASCII character set (64 characters total)
    const aisChars = '@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_ !"#\$%&\'()*+,-./0123456789:;<=>?';

    List<String> segments = [];
    for(int i = 0; i < binaryVesselName.length; i+= 6) {
      segments.add(binaryVesselName.substring(i, i+6));
    }

    String result = "";

    for(String segment in segments) {
      int decimalValue = int.parse(segment, radix: 2);
      if(decimalValue >= 0 && decimalValue < aisChars.length ) {
        result += aisChars[decimalValue];
      } else {
        result += '@';
      }
    }
    return result;
  }

  ///Get the Dimensions to different places on the vessel in Meters (always provide all four dimensions => bow, stern, port, starboard). Array is => bow, stern, port, starboard.
  List<int> getDimensions(String toBow, String toStern, String toPort, String toStarboard) {
    int metersToBow = int.parse(toBow, radix: 2);
    int metersToStern = int.parse(toStern, radix: 2);
    int metersToPort = int.parse(toPort, radix: 2);
    int metersToStarboard = int.parse(toStarboard, radix: 2);
    return [metersToBow, metersToStern, metersToPort, metersToStarboard];
  }

  ///Get the Vessel Type.
  String getVesselType(String binaryVesselType) {
    int vesselTypeInt = int.parse(binaryVesselType, radix: 2);
    // Long Ass Switch Stmt xD
    switch (vesselTypeInt) {
      case 0:
        return 'Not available (default)';
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
      case 11:
      case 12:
      case 13:
      case 14:
      case 15:
      case 16:
      case 17:
      case 18:
      case 19:
        return 'Reserved for future use';
      case 20:
        return 'Wing in ground (WIG), all ships of this type';
      case 21:
        return 'Wing in ground (WIG), Hazardous category A';
      case 22:
        return 'Wing in ground (WIG), Hazardous category B';
      case 23:
        return 'Wing in ground (WIG), Hazardous category C';
      case 24:
        return 'Wing in ground (WIG), Hazardous category D';
      case 25:
      case 26:
      case 27:
      case 28:
      case 29:
        return 'Wing in ground (WIG), Reserved for future use';
      case 30:
        return 'Fishing';
      case 31:
        return 'Towing';
      case 32:
        return 'Towing: length exceeds 200m or breadth exceeds 25m';
      case 33:
        return 'Dredging or underwater ops';
      case 34:
        return 'Diving ops';
      case 35:
        return 'Military ops';
      case 36:
        return 'Sailing';
      case 37:
        return 'Pleasure Craft';
      case 38:
      case 39:
        return 'Reserved';
      case 40:
        return 'High speed craft (HSC), all ships of this type';
      case 41:
        return 'High speed craft (HSC), Hazardous category A';
      case 42:
        return 'High speed craft (HSC), Hazardous category B';
      case 43:
        return 'High speed craft (HSC), Hazardous category C';
      case 44:
        return 'High speed craft (HSC), Hazardous category D';
      case 45:
      case 46:
      case 47:
      case 48:
        return 'High speed craft (HSC), Reserved for future use';
      case 49:
        return 'High speed craft (HSC), No additional information';
      case 50:
        return 'Pilot Vessel';
      case 51:
        return 'Search and Rescue vessel';
      case 52:
        return 'Tug';
      case 53:
        return 'Port Tender';
      case 54:
        return 'Anti-pollution equipment';
      case 55:
        return 'Law Enforcement';
      case 56:
      case 57:
        return 'Spare - Local Vessel';
      case 58:
        return 'Medical Transport';
      case 59:
        return 'Noncombatant ship according to RR Resolution No. 18';
      case 60:
        return 'Passenger, all ships of this type';
      case 61:
        return 'Passenger, Hazardous category A';
      case 62:
        return 'Passenger, Hazardous category B';
      case 63:
        return 'Passenger, Hazardous category C';
      case 64:
        return 'Passenger, Hazardous category D';
      case 65:
      case 66:
      case 67:
      case 68:
        return 'Passenger, Reserved for future use';
      case 69:
        return 'Passenger, No additional information';
      case 70:
        return 'Cargo, all ships of this type';
      case 71:
        return 'Cargo, Hazardous category A';
      case 72:
        return 'Cargo, Hazardous category B';
      case 73:
        return 'Cargo, Hazardous category C';
      case 74:
        return 'Cargo, Hazardous category D';
      case 75:
      case 76:
      case 77:
      case 78:
        return 'Cargo, Reserved for future use';
      case 79:
        return 'Cargo, No additional information';
      case 80:
        return 'Tanker, all ships of this type';
      case 81:
        return 'Tanker, Hazardous category A';
      case 82:
        return 'Tanker, Hazardous category B';
      case 83:
        return 'Tanker, Hazardous category C';
      case 84:
        return 'Tanker, Hazardous category D';
      case 85:
      case 86:
      case 87:
      case 88:
        return 'Tanker, Reserved for future use';
      case 89:
        return 'Tanker, No additional information';
      case 90:
        return 'Other Type, all ships of this type';
      case 91:
        return 'Other Type, Hazardous category A';
      case 92:
        return 'Other Type, Hazardous category B';
      case 93:
        return 'Other Type, Hazardous category C';
      case 94:
        return 'Other Type, Hazardous category D';
      case 95:
      case 96:
      case 97:
      case 98:
        return 'Other Type, Reserved for future use';
      case 99:
        return 'Other Type, no additional information';
      default:
        return 'Unknown Type';
    }
  }

  ///Get the EPDF Fix Type.
  String getEPFDFixType(String binaryEPFDFixType) {
    int ePFDFixType = int.parse(binaryEPFDFixType, radix: 2);

    switch(ePFDFixType) {
      case(0): return "Undefined (default)";
      case(1): return "GPS";
      case(2): return "GLONASS";
      case(3): return "Combined GPS/GLONASS";
      case(4): return "Loran-C";
      case(5): return "Chayka";
      case(6): return "Integrated Navigation System";
      case(7): return "Surveyed";
      case(8): return "Galileo";
      case(9): return "Reserved";
      case(10): return "Reserved";
      case(11): return "Reserved";
      case(12): return "Reserved";
      case(13): return "Reserved";
      case(14): return "Reserved";
      case(15): return "Internal GNSS";
      default: return "Unknown (not sent)";
    }
  }

  ///Calculates the Draught of the Vessel.
  double calculateDraught(String binaryDraught) {
    int draughtInt = int.parse(binaryDraught, radix: 2);
    return draughtInt.floorToDouble() / 10;
  }

  ///Checks if DTE is ready.
  String getDTEFunction(String binaryDTE) {
    if(binaryDTE == "1") {
      return "Data Terminal not Ready (Default)";
    } else {
      return "Data Terminal Ready";
    }
  }

  ///Function to get the Destination of the Vessel (ChatGPT helped me here).
  String getDestination(String binaryString) {
    // Function to convert a 6-bit binary string to its corresponding ASCII character
    String ais6BitToAscii(String bits) {
      int code = int.parse(bits, radix: 2);
      if (code >= 0 && code <= 31) {
        return String.fromCharCode(code + 64);  // @ for 0, A-Z for 1-26, etc.
      } else if (code >= 32 && code <= 63) {
        return String.fromCharCode(code);  // space for 32, specific characters up to '?'
      }
      return '?';  // Fallback for out-of-range codes
    }

    // Split the binary string into 6-bit segments
    List<String> segments = [];
    for (int i = 0; i < binaryString.length; i += 6) {
      segments.add(binaryString.substring(i, i + 6));
    }

    // Decode each segment and concatenate into the final string
    String destination = segments.map(ais6BitToAscii).join();

    // Trim the padding spaces and return the result
    return destination.trim();
  }

  ///Convert the Binary MessageType to a String to interpret later or show the client.
  String? messageTypeInfo(String binaryMessageType) {
    int messageType = int.parse(binaryMessageType, radix: 2);

    switch(messageType) {
      case(1): return "Position Report Class A";
      case(2): return "Position Report Class A (Assigned Schedule)";
      case(3): return "Position Report Class A (Response to interrogation)";
      case(4): return "Base Station Report";
      case(5): return "Static and Voyage Related Data";
      case(6): return "Binary Addressed Message";
      case(7): return "Binary Acknowledgement";
      case(8): return "Binary Broadcast Message";
      case(9): return "Standard SAR Aircraft Position Report";
      case(10): return "UTC and Date Inquiry";
      case(11): return "UTC and Date Response";
      case(12): return "Addressed Safety Related Message";
      case(13): return "Safety Related Acknowledgement";
      case(14): return "Safety Related Broadcast Message";
      case(15): return "Interrogation";
      case(16): return "Assignment Mode Command";
      case(17): return "DGNSS Binary Broadcast Message";
      case(18): return "Standard Class B CS Position Report";
      case(19): return "Extended Class B Equipment Position Report";
      case(20): return "Data Link Management";
      case(21): return "Aid-to-Navigation Report";
      case(22): return "Channel Management";
      case(23): return "Group Assignment Command";
      case(24): return "Static Data Report";
      case(25): return "Single Slot Binary Message";
      case(26): return "Multiple Slot Binary Message With Communications State";
      case(27): return "Position Report For Long-Range Applications";
      default: return "Unknown";
    }
  }

  ///Convert the Binary Navigation Status to a String to interpret later or show the client.
  String? navigationStatusInfo(String binaryNavigationStatus) {
    int navigationStatus = int.parse(binaryNavigationStatus, radix: 2);

    switch(navigationStatus) {
      case(0): return "Under way using engine";
      case(1): return "At anchor";
      case(2): return "Not under command";
      case(3): return "Restricted manoeuvrability";
      case(4): return "Constrained by her draught";
      case(5): return "Moored";
      case(6): return "Aground";
      case(7): return "Engaged in Fishing";
      case(8): return "Under way sailing";
      case(9): return "Reserved for future amendment of Navigational Status for HSC";
      case(10): return "Reserved for future amendment of Navigational Status for WIG";
      case(11): return "Power-driven vessel towing astern (regional)";
      case(12): return "Power-driven vessel pushing ahead or towing alongside (regional)";
      case(13): return "No official terminology (Error in transmission)";
      case(14): return "AIS-SART is active";
      case(15): return "Undefined (Not transmitted)";
      default: return "Unknown";
    }
  }

  ///Convert the Binary Turn Information to a String to interpret later or show the client.
  String? turnInformationInfo(String binaryTurnInformation) {
    int turnInformation = int.parse(binaryTurnInformation, radix: 2);

    if(turnInformation == 0) {
      return "Not turning";
    }
    if(turnInformation >= 1 && turnInformation <= 126) {
      return "Turning right at up to 708 deg. per minute or higher";
    }
    if(turnInformation <= 1 && turnInformation >= -126) {
      return "Turning left at up to 708 deg. per minute or higher";
    }
    if(turnInformation == 127) {
      return "turning right at more than 5deg/30s (No TI available)";
    }
    if(turnInformation == -127) {
      return "turning left at more than 5deg/30s (No TI available)";
    }
    if(turnInformation == 128) {
      return "No information available (not sent)";
    }
    else {
      return "Unknown";
    }
  }

  ///Convert the Binary Speed Information to a String which shows the speed of the vessel in knots.
  String? speedOverGroundInfo(String binarySpeedOverGround) {
    double speedInfo = int.parse(binarySpeedOverGround, radix: 2) / 10;

    if(speedInfo == 102.3) {
      return "Speed not Available (not sent)";
    } else if(speedInfo == 102.2) {
      return "Speed over 102.2 knots";
    } else {
      return speedInfo.toString();
    }
  }

  ///Convert the Binary Position Accuracy to a String which tells more about the position accuracy.
  String? positionAccuracyInfo(String binaryPositionAccuracy) {
    int positionAccuracy = int.parse(binaryPositionAccuracy);

    if(positionAccuracy == 0) {
      return "Accuracy < 10ms";
    }
    if(positionAccuracy == 1) {
      return "Accuracy > 10ms";
    } else {
      return "Error please Contact: ";
    }
  }

  ///Convert the Binary Course Over Ground to a String which represents the Course Over Ground to interpret later or show the client.
  String? courseOverGroundInfo(String binaryCourseOverGround) {
    double courseOverGround = int.parse(binaryCourseOverGround, radix: 2) / 10;

    if(courseOverGround == 360.0) {
      return "Data not available (not sent)";
    } else {
      return courseOverGround.toString();
    }
  }

  ///Convert the Binary True Heading to a String which represents the True Heading of the vessel to interpret later or show the client.
  String? trueHeadingInfo(String binaryTrueHeading) {
    int trueHeading = int.parse(binaryTrueHeading, radix: 2);

    if(trueHeading == 511) {
      return "Not available (not sent)";
    } else {
      return trueHeading.toString();
    }
  }

  ///Convert the Binary Time Stamp to a String which represents the Time Stamp to interpret later or show the user, or gives out the reason why it isn't available/special.
  String? timeStampInfo(String binaryTimeStamp) {
    int timeStamp = int.parse(binaryTimeStamp, radix: 2);

    if(timeStamp == 60) {
      return "Not available (not sent)";
    }
    if(timeStamp == 61) {
      return "Positioning System is in manual mode";
    }
    if(timeStamp == 62) {
      return "Electronic Position Fixing System operates in estimated (dead reckoning) mode";
    }
    if(timeStamp == 63) {
      return "Positioning System inoperative";
    } else {
      return timeStamp.toString();
    }
  }

  ///Convert the Maneuver Indicator to a String which identifies the current maneuver of the vessel to interpret later or show the client.
  String? maneuverIndicatorInfo(String binaryManeuverIndicator) {
    int maneuverIndicator = int.parse(binaryManeuverIndicator, radix: 2);

    switch(maneuverIndicator) {
      case(0): return "Not available (Default)";
      case(1): return "No Special Maneuver";
      case(2): return "Special Maneuver in Progress";
      default: return "Unknown";
    }
  }

  ///Check if RAIM (Receiver Autonomous Integrity Monitoring) is enabled.
  String? RAIMInfo(String binaryRAIMFlag) {
    int RAIMFlag = int.parse(binaryRAIMFlag);

    if(RAIMFlag == 0) {
      return "RAIM not enabled (default)";
    }
    if(RAIMFlag == 1) {
      return "RAIM enabled (read more under: https://en.wikipedia.org/wiki/Receiver_autonomous_integrity_monitoring)";
    } else {
      return "Unknown (Please Contact: )";
    }
  }

}