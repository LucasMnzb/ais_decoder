import 'package:ais_decoder/ais_decoder.dart';
import 'package:test/test.dart';

void main() {
  group('Type 1', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType1Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 1);
      expect(message.mmsi, 371798000);
      expect(message.repeatIndicator, 0);
      expect(message, isA<PositionMessage>());
      final typed = message as PositionMessage;
      expect(typed.speedOverGround, 12.3);
      expect(typed.latitude, closeTo(48.381633, 0.0001));
      expect(typed.longitude, closeTo(-123.395383, 0.0001));
      expect(typed.courseOverGround, 224.0);
      expect(typed.heading, 215.0);
      expect(typed.timestamp, 33);
    });
  });

  group('Type 2', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType2Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 2);
      expect(message.mmsi, 356302000);
      expect(message.repeatIndicator, 0);
      expect(message, isA<PositionMessage>());
      final typed = message as PositionMessage;
      expect(typed.speedOverGround, 13.9);
      expect(typed.heading, 91.0);
      expect(typed.latitude, closeTo(40.392358, 0.0001));
      expect(typed.longitude, closeTo(-71.626143, 0.0001));
    });
  });

  group('Type 3', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType3Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 3);
      expect(message.mmsi, 563808000);
      expect(message.repeatIndicator, 0);
      expect(message, isA<PositionMessage>());
      final typed = message as PositionMessage;
      expect(typed.navigationStatus, 'Moored');
      expect(typed.heading, 352.0);
      expect(typed.timestamp, 35);
    });
  });

  group('Type 4', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType4Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 4);
      expect(message.mmsi, 3669702);
      expect(message.repeatIndicator, 0);
      expect(message, isA<BaseStationReport>());
      final typed = message as BaseStationReport;
      expect(typed.year, 2007);
      expect(typed.month, 5);
      expect(typed.day, 14);
      expect(typed.hour, 19);
      expect(typed.minute, 57);
      expect(typed.second, 39);
      expect(typed.latitude, closeTo(36.883767, 0.0001));
      expect(typed.longitude, closeTo(-76.352362, 0.0001));
    });
  });

  group('Type 5', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType5Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 5);
      expect(message.mmsi, 351759000);
      expect(message.repeatIndicator, 0);
      expect(message, isA<StaticAndVoyageRelatedData>());
      final typed = message as StaticAndVoyageRelatedData;
      expect(typed.imoNumber, 9134270);
      expect(typed.callSign, '3FOF8  ');
      expect(typed.vesselName, 'EVER DIADEM         ');
      expect(typed.vesselTypeInt, 70);
      expect(typed.dimensionBow, 225);
      expect(typed.dimensionStern, 70);
      expect(typed.draught, 12.2);
      expect(typed.destination, 'NEW YORK  ');
    });
  });

  group('Type 6', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType6Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 6);
      expect(message.mmsi, 150834090);
      expect(message, isA<BinaryAddressedMessage>());
    });
  });

  group('Type 7', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType7Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 7);
      expect(message.mmsi, 2655651);
      expect(message, isA<BinaryAcknowledge>());
      final typed = message as BinaryAcknowledge;
      expect(typed.mmsi1, 265538450);
    });
  });

  group('Type 8', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType8Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 8);
      expect(message.mmsi, 366999712);
      expect(message, isA<BinaryBroadcastMessage>());
    });
  });

  group('Type 9', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType9Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 9);
      expect(message.mmsi, 111232511);
      expect(message.repeatIndicator, 0);
      expect(message, isA<SarAircraftPositionReport>());
      final typed = message as SarAircraftPositionReport;
      expect(typed.altitude, 303);
      expect(typed.latitude, closeTo(58.144, 0.001));
      expect(typed.longitude, closeTo(-6.278843, 0.0001));
    });
  });

  group('Type 10', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType10Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 10);
      expect(message.mmsi, 366814480);
      expect(message.repeatIndicator, 0);
      expect(message, isA<UtcDateInquiry>());
      final typed = message as UtcDateInquiry;
      expect(typed.destinationMmsi, 366832740);
    });
  });

  group('Type 11', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType11Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 11);
      expect(message.mmsi, 304137000);
      expect(message.repeatIndicator, 0);
      expect(message, isA<UtcDateResponse>());
      final typed = message as UtcDateResponse;
      expect(typed.year, 2009);
      expect(typed.month, 5);
      expect(typed.day, 22);
      expect(typed.hour, 2);
      expect(typed.minute, 22);
      expect(typed.second, 40);
      expect(typed.latitude, closeTo(28.409117, 0.0001));
      expect(typed.longitude, closeTo(-94.407683, 0.0001));
    });
  });

  group('Type 12', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType12Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 12);
      expect(message.mmsi, 351853000);
      expect(message.repeatIndicator, 0);
      expect(message, isA<AddressedSafetyRelatedMessage>());
      final typed = message as AddressedSafetyRelatedMessage;
      expect(typed.text, 'GOOD');
    });
  });

  group('Type 13', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType13Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 13);
      expect(message.mmsi, 211378120);
      expect(message, isA<SafetyRelatedAcknowledgement>());
      final typed = message as SafetyRelatedAcknowledgement;
      expect(typed.mmsi1, 211217560);
    });
  });

  group('Type 14', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType14Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 14);
      expect(message.mmsi, 351809000);
      expect(message.repeatIndicator, 0);
      expect(message, isA<SafetyRelatedBroadcastMessage>());
      final typed = message as SafetyRelatedBroadcastMessage;
      expect(typed.text, 'RCVD YR TEST MSG');
    });
    test('example 2', () {
      final message = AISMessage.fromString(kType14Ex2);
      expect(message, isNotNull);
      expect(message.messageType, 14);
      expect(message.mmsi, 311764000);
      expect(message, isA<SafetyRelatedBroadcastMessage>());
      final typed = message as SafetyRelatedBroadcastMessage;
      expect(typed.text, 'TEST');
    });
  });

  group('Type 15', () {
    test('example 1 — single interrogation', () {
      final message = AISMessage.fromString(kType15Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 15);
      expect(message.mmsi, 368578000);
      expect(message.repeatIndicator, 0);
      expect(message, isA<InterrogationMessage>());
      final typed = message as InterrogationMessage;
      expect(typed.mmsi1, 5158);
      expect(typed.type1_1, 5);
      expect(typed.offset1_1, 0);
      expect(typed.mmsi2, isNull);
    });
    test('example 2 — double interrogation same station', () {
      final message = AISMessage.fromString(kType15Ex2);
      expect(message, isNotNull);
      expect(message.messageType, 15);
      expect(message.mmsi, 3669720);
      expect(message, isA<InterrogationMessage>());
      final typed = message as InterrogationMessage;
      expect(typed.mmsi1, 367014320);
      expect(typed.type1_1, 3);
      expect(typed.offset1_1, 516);
      expect(typed.type1_2, 5);
      expect(typed.offset1_2, 617);
    });
  });

  group('Type 16', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType16Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 16);
      expect(message.mmsi, 2053501);
      expect(message.repeatIndicator, 0);
      expect(message, isA<AssignmentModeCommand>());
      final typed = message as AssignmentModeCommand;
      expect(typed.mmsi1, 224251000);
      expect(typed.offset1, 200);
      expect(typed.increment1, 0);
      expect(typed.mmsi2, isNull);
    });
  });

  group('Type 17', () {
    test('example 1 — first part only', () {
      final message = AISMessage.fromString(kType17Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 17);
      expect(message.mmsi, 2734450);
      expect(message, isA<DgnssBroadcastBinaryMessage>());
      final typed = message as DgnssBroadcastBinaryMessage;
      expect(typed.longitude, closeTo(29.13, 0.01));
      expect(typed.latitude, closeTo(59.987, 0.01));
    });
  });

  group('Type 18', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType18Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 18);
      expect(message.mmsi, 338087471);
      expect(message.repeatIndicator, 0);
      expect(message, isA<StandardClassBCSPositionReport>());
      final typed = message as StandardClassBCSPositionReport;
      expect(typed.speedOverGround, 0.1);
      expect(typed.latitude, closeTo(40.68454, 0.0001));
      expect(typed.longitude, closeTo(-74.072132, 0.0001));
      expect(typed.courseOverGround, 79.6);
      expect(typed.timestamp, 49);
    });
  });

  group('Type 19', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType19Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 19);
      expect(message.mmsi, 367059850);
      expect(message.repeatIndicator, 0);
      expect(message, isA<ExtendedClassBCSPositionReport>());
      final typed = message as ExtendedClassBCSPositionReport;
      expect(typed.speedOverGround, 8.7);
      expect(typed.latitude, closeTo(29.543695, 0.0001));
      expect(typed.longitude, closeTo(-88.810392, 0.0001));
      expect(typed.vesselName, startsWith('CAPT.J.RIMES'));
    });
  });

  group('Type 20', () {
    test('example 1 — single reservation', () {
      final message = AISMessage.fromString(kType20Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 20);
      expect(message.mmsi, 3669705);
      expect(message.repeatIndicator, 3);
      expect(message, isA<DataLinkManagementMessage>());
      final typed = message as DataLinkManagementMessage;
      expect(typed.offset1, 2182);
      expect(typed.number1, 5);
      expect(typed.timeout1, 7);
      expect(typed.increment1, 225);
      expect(typed.offset2, isNull);
    });
    test('example 2 — three reservations', () {
      final message = AISMessage.fromString(kType20Ex2);
      expect(message, isNotNull);
      expect(message.messageType, 20);
      expect(message.mmsi, 3160097);
      expect(message, isA<DataLinkManagementMessage>());
      final typed = message as DataLinkManagementMessage;
      expect(typed.offset1, 47);
      expect(typed.number1, 1);
      expect(typed.increment1, 250);
      expect(typed.offset2, 2250);
      expect(typed.increment2, 1125);
      expect(typed.offset3, 856);
      expect(typed.number3, 5);
      expect(typed.offset4, isNull);
    });
  });

  group('Type 21', () {
    test('example 1 — first part only', () {
      final message = AISMessage.fromString(kType21Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 21);
      expect(message.mmsi, 123456789);
      expect(message.repeatIndicator, 0);
      expect(message, isA<AidToNavigationReport>());
      final typed = message as AidToNavigationReport;
      expect(typed.aidTypeInt, 20);
      expect(typed.positionAccuracy, 0);
      expect(typed.latitude, closeTo(47.920618, 0.0001));
      expect(typed.longitude, closeTo(-122.698592, 0.0001));
      expect(typed.dimensionBow, 5);
      expect(typed.dimensionStern, 5);
      expect(typed.second, 50);
    });
  });

  group('Type 22', () {
    test('example 1 — broadcast/geographic', () {
      final message = AISMessage.fromString(kType22Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 22);
      expect(message.mmsi, 3160048);
      expect(message.repeatIndicator, 0);
      expect(message, isA<ChannelManagementMessage>());
      final typed = message as ChannelManagementMessage;
      expect(typed.channelA, 2087);
      expect(typed.channelB, 2088);
      expect(typed.addressed, 0);
      expect(typed.power, 0);
      expect(typed.neLongitude, closeTo(-73.5, 0.001));
      expect(typed.neLatitude, closeTo(45.55, 0.001));
      expect(typed.zoneSize, 4);
      expect(typed.mmsi1, isNull);
    });
  });

  group('Type 23', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType23Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 23);
      expect(message.mmsi, 2268120);
      expect(message.repeatIndicator, 0);
      expect(message, isA<GroupAssignmentCommand>());
      final typed = message as GroupAssignmentCommand;
      expect(typed.stationTypeInt, 6);
      expect(typed.shipTypeInt, 0);
      expect(typed.interval, 9);
      expect(typed.quietTime, 0);
      expect(typed.neLongitude, closeTo(2.63, 0.01));
      expect(typed.neLatitude, closeTo(51.07, 0.01));
    });
  });

  group('Type 24', () {
    test('example Part A', () {
      final message = AISMessage.fromString(kType24ExA);
      expect(message, isNotNull);
      expect(message.messageType, 24);
      expect(message.mmsi, 271041815);
      expect(message.repeatIndicator, 0);
      expect(message, isA<StaticDataReportA>());
      final typed = message as StaticDataReportA;
      expect(typed.partNumber, 0);
      expect(typed.vesselName, startsWith('PROGUY'));
    });
    test('example Part B', () {
      final message = AISMessage.fromString(kType24ExB);
      expect(message, isNotNull);
      expect(message.messageType, 24);
      expect(message.mmsi, 271041815);
      expect(message, isA<StaticDataReportB>());
      final typed = message as StaticDataReportB;
      expect(typed.partNumber, 1);
      expect(typed.vesselTypeInt, 60);
    });
  });

  group('Type 25', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType25Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 25);
      expect(message, isA<SingleSlotBinaryMessage>());
    });
  });

  group('Type 26', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType26Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 26);
      expect(message, isA<MultipleSlotBinaryMessage>());
    });
  });

  group('Type 27', () {
    test('example 1', () {
      final message = AISMessage.fromString(kType27Ex1);
      expect(message, isNotNull);
      expect(message.messageType, 27);
      expect(message, isA<LongRangeAISBroadcastMessage>());
    });
  });
}

// Type 1 — Class A Position Report
const kType1Ex1 = '!AIVDM,1,1,,A,15RTgt0PAso;90TKcjM8h6g208CQ,0*4A';

// Type 2 — Class A Position Report (Assigned)
const kType2Ex1 = '!AIVDM,1,1,,B,25Cjtd0Oj;Jp7ilG7=UkKBoB0<06,0*60';

// Type 3 — Class A Position Report (Interrogated)
const kType3Ex1 = '!AIVDM,1,1,,A,38Id705000rRVJhE7cl9n;160000,0*40';

// Type 4 — Base Station Report
const kType4Ex1 = '!AIVDM,1,1,,A,403OviQuMGCqWrRO9>E6fE700@GO,0*4D';

// Type 5 — Static and Voyage Related Data (first part only; all key fields fit in first payload)
const kType5Ex1 = '!AIVDM,2,1,1,A,55?MbV02;H;s<HtKR20EHE:0@T4@Dn2222222216L961O5Gf0NSQEp6ClRp8,0*1C';

// Type 6 — Binary Addressed Message
const kType6Ex1 = '!AIVDM,1,1,,B,6B?n;be:cbapalgc;i6?Ow4,2*4A';

// Type 7 — Binary Acknowledge
const kType7Ex1 = '!AIVDM,1,1,,A,702R5`hwCjq8,0*6B';

// Type 8 — Binary Broadcast Message
const kType8Ex1 = '!AIVDM,1,1,,A,85Mwp`1Kf3aCnsNvBWLi=wQuNhA5t43N`5nCuI=p<IBfVqnMgPGs,0*47';

// Type 9 — SAR Aircraft Position Report
const kType9Ex1 = '!AIVDM,1,1,,B,91b55wi;hbOS@OdQAC062Ch2089h,0*30';

// Type 10 — UTC/Date Inquiry
const kType10Ex1 = '!AIVDM,1,1,,B,:5MlU41GMK6@,0*6C';

// Type 11 — UTC/Date Response (USCG trailing fields stripped)
const kType11Ex1 = '!AIVDM,1,1,,B,;4R33:1uUK2F`q?mOt@@GoQ00000,0*5D';

// Type 12 — Addressed Safety-Related Message
const kType12Ex1 = '!AIVDM,1,1,,A,<5?SIj1;GbD07??4,0*38';

// Type 13 — Safety-Related Acknowledgement
const kType13Ex1 = '!AIVDM,1,1,,A,=39UOj0jFs9R,0*65';

// Type 14 — Safety-Related Broadcast Message
const kType14Ex1 = '!AIVDM,1,1,,A,>5?Per18=HB1U:1@E=B0m<L,2*51';
const kType14Ex2 = '!AIVDM,1,1,,A,>4aDT81@E=@,2*2E';

// Type 15 — Interrogation
const kType15Ex1 = '!AIVDM,1,1,,A,?5OP=l00052HD00,2*5B';
const kType15Ex2 = '!AIVDM,1,1,,B,?h3Ovn1GP<K0<P@59a0,2*04';

// Type 16 — Assignment Mode Command
const kType16Ex1 = '!AIVDM,1,1,,A,@01uEO@mMk7P<P00,0*18';

// Type 17 — DGNSS Broadcast Binary Message (first part only)
const kType17Ex1 = '!AIVDM,2,1,5,A,A02VqLPA4I6C07h5Ed1h<OrsuBTTwS?r:C?w`?la<gno1RTRwSP9:BcurA8a,0*3A';

// Type 18 — Standard Class B CS Position Report
const kType18Ex1 = '!AIVDM,1,1,,A,B52K>;h00Fc>jpUlNV@ikwpUoP06,0*4C';

// Type 19 — Extended Class B CS Position Report
const kType19Ex1 = '!AIVDM,1,1,,B,C5N3SRgPEnJGEBT>NhWAwwo862PaLELTBJ:V00000000S0D:R220,0*0B';

// Type 20 — Data Link Management Message
const kType20Ex1 = '!AIVDM,1,1,,A,Dh3OvjB8IN>4,0*1D';
const kType20Ex2 = '!AIVDM,1,1,,B,D030p8@2tN?b<`O6DmQO6D0,2*5D';

// Type 21 — Aid-to-Navigation Report (first part only)
const kType21Ex1 = '!AIVDM,2,1,5,B,E1mg=5J1T4W0h97aRh6ba84<h2d;W:Te=eLvH50```q,0*46';

// Type 22 — Channel Management
const kType22Ex1 = '!AIVDM,1,1,,A,F030ot22N2P6aoQbhe4736L20000,0*1A';

// Type 23 — Group Assignment Command
const kType23Ex1 = '!AIVDM,1,1,,B,G02:Kn01R`sn@291nj600000900,2*12';

// Type 24 — Static Data Report
const kType24ExA = '!AIVDM,1,1,,A,H42O55i18tMET00000000000000,2*6D';
const kType24ExB = '!AIVDM,1,1,,A,H42O55lti4hhhilD3nink000?050,0*40';

// Type 25 — Single Slot Binary Message
const kType25Ex1 = '!AIVDM,1,1,,A,I6SWo?8P00a3PKpEKEVj0?vNP<65,0*73';

// Type 26 — Multiple Slot Binary Message
const kType26Ex1 = '!AIVDM,1,1,,A,J1@@0IK70PGgT740000000000@000?D0ih1e00006JlPC9C3,0*6B';

// Type 27 — Long-Range AIS Broadcast Message
const kType27Ex1 = '!AIVDM,1,1,,A,KCQ9r=hrFUnH7P00,0*41';
