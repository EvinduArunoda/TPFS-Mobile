import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/criminal.dart';
import 'package:tpfs_policeman/models/offences.dart';
import 'package:tpfs_policeman/models/procedure.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/criminalAssessment.dart';
import 'package:tpfs_policeman/views/CA%20module/noMatch.dart';
import 'package:tpfs_policeman/views/CA%20module/offencesList.dart';
import 'package:tpfs_policeman/views/CA%20module/takePicture.dart';
import 'package:tpfs_policeman/views/CA%20module/viewResult.dart';
import 'authWidgets_test.dart';

class MockCA extends Mock implements CriminalAssessment {}
void main() {
  group('CA Take Picture page', (){

    Widget makeTestableTakePicture({Widget child,User user}) {
    return Provider<User>.value(
        value:user,
        child: MaterialApp(
        home: child,
      ),
    );
    }

    Widget makeTestableTakePictureNavigation({Widget child,User user,mockobservers}) {
    return Provider<User>.value(
        value:user,
        child: MaterialApp(
        home: child,
        navigatorObservers: [mockobservers],
      ),
    );
    }
    testWidgets('Ca Take Picture - initial UI', (WidgetTester tester) async {
      ProcedurePolice procedureNew = new ProcedurePolice(startTime: FieldValue.serverTimestamp(),driverProfileSearched: null,vehicleProfileSearched: null,
                                                                ticket: null,criminalAssessment: null,ticketCreated:null,employeeID: '12345');
      TakePicture takepicturewidget = TakePicture(procedure: procedureNew);
      User user = User(uid: 'hilhr30283j5bbj');
      await tester.pumpWidget(makeTestableTakePicture(child: takepicturewidget,user: user));
      expect(find.byKey(Key('CAAppBar')), findsOneWidget);
      expect(find.byKey(Key('CAAppBarText')), findsOneWidget);
      expect(find.byKey(Key('CAIcon')), findsOneWidget);
      expect(find.byKey(Key('TitleCA')), findsOneWidget);
      expect(find.byKey(Key('TextCA')), findsOneWidget);
      expect(find.byKey(Key('CAassessbutton')), findsOneWidget);
      expect(find.byKey(Key('IsImageimage')), findsNothing);
      expect(find.byKey(Key('Checktext')), findsNothing);
      expect(find.byKey(Key('TakeText')), findsOneWidget);
      expect(find.byKey(Key('ImageIcon')), findsNothing);
      expect(find.byKey(Key('NoImageIcon')), findsOneWidget);
    });

    testWidgets('No Image Path-Button Press', (WidgetTester tester) async {
      ProcedurePolice procedureNew = new ProcedurePolice(startTime: FieldValue.serverTimestamp(),driverProfileSearched: null,vehicleProfileSearched: null,
                                                                ticket: null,criminalAssessment: null,ticketCreated:null,employeeID: '12345');
      TakePicture takepicturewidget = TakePicture(procedure: procedureNew);
      User user = User(uid: 'hilhr30283j5bbj');
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(makeTestableTakePictureNavigation(child: takepicturewidget,user: user,mockobservers: mockObserver));
      await tester.tap(find.byKey(Key('CAassessbutton')));
      await tester.pumpWidget(makeTestableTakePictureNavigation(child: takepicturewidget,user: user,mockobservers: mockObserver));
      verify(mockObserver.didPush(any, any));
    });

    testWidgets('CA widget with imagepath', (WidgetTester tester) async {
      ProcedurePolice procedureNew = new ProcedurePolice(startTime: FieldValue.serverTimestamp(),driverProfileSearched: null,vehicleProfileSearched: null,
                                                                ticket: null,criminalAssessment: null,ticketCreated:null,employeeID: '12345');
      TakePicture takepicturewidget = TakePicture(procedure: procedureNew,imagePath: 'temp/1234454.jpg',);
      User user = User(uid: 'hilhr30283j5bbj');
      await tester.pumpWidget(makeTestableTakePicture(child: takepicturewidget,user: user));
      expect(find.byKey(Key('CAassessbutton')), findsOneWidget);
      expect(find.byKey(Key('IsImageimage')), findsOneWidget);
      expect(find.byKey(Key('Checktext')), findsOneWidget);
      expect(find.byKey(Key('TakeText')), findsNothing);
      expect(find.byKey(Key('ImageIcon')), findsOneWidget);
      expect(find.byKey(Key('NoImageIcon')), findsNothing);
    });
  });

  group('No Match Widget Testing', (){
    Widget makeTestableNoMatch({Widget child}) {
    return MaterialApp(
    home: child,
      );
    }
    testWidgets('No Match Widget - UI', (WidgetTester tester) async {
      NoMatch nomatchwidget = NoMatch(imagePath: 'temp/1he3g23932.jpg');
      await tester.pumpWidget(makeTestableNoMatch(child: nomatchwidget));
      expect(find.byKey(Key('NoMatchAppBar')), findsOneWidget);
      expect(find.byKey(Key('NoMatchAppText')), findsOneWidget);
      expect(find.text('No Match Found'.toUpperCase()), findsOneWidget);
      expect(find.text('RESULT :'), findsOneWidget);
      expect(find.text('Unknown'), findsOneWidget);
      expect(find.text('Test Image'), findsOneWidget);
      expect(find.text('If any criminal offence has been commited by this individual carry out legal proceedings manually'), findsOneWidget);
      expect(find.byKey(Key('NoMatchImage')), findsOneWidget);
    });
  });

  group('Match Image Widget Testing', (){
    Widget makeTestableWidgetMatch({Widget child}) {
      return MaterialApp(
      home: child,
        );
    }

    Widget makeNavigationWidgetMatch({Widget child,mockobservers}) {
      return MaterialApp(
      home: child,
      navigatorObservers: [mockobservers],
        );
    }
    testWidgets('View results initial UI', (WidgetTester tester) async {
      MockCA caAssess = MockCA();
      ViewResult viewresultwidget = ViewResult(assessCriminal: caAssess,assessDriverImagePath: 'temp/23n1432.jpg',matchDriverImagePath: '',
                                        filepath: 'filepath',corelation: '0.9813142324',criminalDetails: Criminal(name: 'Sheldon',address: 'No.123,Dubai',nicNumber: '951209346V',
                                                                        phoneNumber: '0712340985',offencesReference: []),);
      await mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidgetMatch(child: viewresultwidget)));
      expect(find.byKey(Key('MatchAppBar')), findsOneWidget);
      expect(find.byKey(Key('MatchAppText')), findsOneWidget);
      expect(find.byKey(Key('TestImage')), findsOneWidget);
      expect(find.byKey(Key('MatchImage')), findsOneWidget);
      expect(find.byKey(Key('ConfirmMatchButton')), findsOneWidget);
      expect(find.byKey(Key('RejectMatchButton')), findsOneWidget);
      expect(find.byKey(Key('ViewOffencesButton')), findsNothing);
      expect(find.byKey(Key('MatchDetails')), findsNothing);
      expect(find.byKey(Key('NoShowDetails')), findsOneWidget);
      expect(find.text('98.13%'), findsOneWidget);
      expect(find.byKey(Key('namedetails')), findsOneWidget);
    });

    testWidgets('Press Is Match', (WidgetTester tester) async {
      MockCA caAssess = MockCA();
      when(caAssess.updateMatchAndDetails('filepath','Match')).thenAnswer((_) => Future.value(null));
      ViewResult viewresultwidget = ViewResult(assessCriminal: caAssess,assessDriverImagePath: 'temp/23n1432.jpg',matchDriverImagePath: '',
                                        filepath: 'filepath',corelation: '0.9813142324',criminalDetails: Criminal(name: 'Sheldon',address: 'No.123,Dubai',nicNumber: '951209346V',
                                                                        phoneNumber: '0712340985',offencesReference: []),);
      await mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidgetMatch(child: viewresultwidget)));
      await tester.tap(find.byKey(Key('ConfirmMatchButton')));
      await tester.pumpWidget(makeTestableWidgetMatch(child: viewresultwidget));
    });

    testWidgets('Press Reject Button', (WidgetTester tester) async {
      MockCA caAssess = MockCA();
      when(caAssess.updateMatchAndDetails('filepath','No Match')).thenAnswer((_) => Future.value(null));
      ViewResult viewresultwidget = ViewResult(assessCriminal: caAssess,assessDriverImagePath: 'temp/23n1432.jpg',matchDriverImagePath: '',
                                        filepath: 'filepath',corelation: '0.9813142324',criminalDetails: Criminal(name: 'Sheldon',address: 'No.123,Dubai',nicNumber: '951209346V',
                                                                        phoneNumber: '0712340985',offencesReference: []),);
      final mockObserver = MockNavigatorObserver();
      await mockNetworkImagesFor(() => tester.pumpWidget(makeNavigationWidgetMatch(child: viewresultwidget,mockobservers: mockObserver)));
      await tester.tap(find.byKey(Key('RejectMatchButton')));
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
    });

    testWidgets('Press Is Match', (WidgetTester tester) async {
      MockCA caAssess = MockCA();
      when(caAssess.updateMatchAndDetails('filepath','Match')).thenAnswer((_) => Future.value(null));
      ViewResult viewresultwidget = ViewResult(assessCriminal: caAssess,assessDriverImagePath: 'temp/23n1432.jpg',matchDriverImagePath: '',
                                        filepath: 'filepath',corelation: '0.9813142324',criminalDetails: Criminal(name: 'Sheldon',address: 'No.123,Dubai',nicNumber: '951209346V',
                                                                        phoneNumber: '0712340985',offencesReference: []),);
      await mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidgetMatch(child: viewresultwidget)));
      await tester.tap(find.byKey(Key('ConfirmMatchButton')));
      await tester.pumpWidget(makeTestableWidgetMatch(child: viewresultwidget));
    });
  });

  group('View Offences Widget', (){
    Widget makeTestableWidgetOffence({Widget child}) {
      return MaterialApp(
      home: Scaffold(body: child),
        );
    }

    testWidgets('View OffenceList UI', (WidgetTester tester) async {
      List<CriminalOffences> offences = [CriminalOffences(date: '12-11-2020',place: 'Colombo',offence: 'Embezzlement'),
                                          CriminalOffences(date:'23-04-2020',place:'Galle',offence:'Road Accident')];
      OffenceList offencelistwidget = OffenceList(offencesOfCriminal: offences);
      await tester.pumpWidget(makeTestableWidgetOffence(child: offencelistwidget));
      expect(find.byKey(Key('OffenceListBuilder')), findsOneWidget);
      expect(find.text('12-11-2020'.toUpperCase()), findsOneWidget);
      expect(find.text('Road Accident'), findsOneWidget);
      expect(find.text('Embezzlement'), findsOneWidget);
      expect(find.text('Galle'), findsOneWidget);

    });
  });
}