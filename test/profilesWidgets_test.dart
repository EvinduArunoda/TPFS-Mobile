import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/driver.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/db_driver.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:tpfs_policeman/views/profiles/driverprofile.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tpfs_policeman/views/profiles/profile.dart';

import 'authWidgets_test.dart';

class MockDriverCollection extends Mock implements DriverCollection {
  Ticket _ticketFromDocument(DocumentSnapshot document){
    return Ticket(
      licenseNumber: document.data['LicenseNumber'] ?? '',
      licensePlate: document.data['LicensePlate'] ?? '',
      areaCoordinates: document.data['Area'] ?? '',
      date: document.data['Date'] ?? '',
      timestamp: document.data['Time'] ?? '',
      vehicle: document.data['Vehicle'] ?? '',
      fineAmount: document.data['FineAmount'] ?? 0.0,
      status: document.data['Status'] ?? '', 
      offences: document.data['Offences'] ?? []
    );
  }
  Future<List<Ticket>> outstandingticketsDetails(String licenseNumber) async{
    final instance = MockFirestoreInstance();
    await instance.collection('Ticket').add({
      'LicenseNumber': 'B1234567',
      'Status': 'open',
      'LicensePlate': 'KI-1234',
    });
    List<DocumentSnapshot> outstandingtTicketDetails;
    List<Ticket> outstandingTickets;
    outstandingtTicketDetails = (await instance
        .collection("Ticket")
        .where("LicenseNumber", isEqualTo: licenseNumber)
        .where('Status', isEqualTo: 'open').orderBy('Time',descending: true)
        .getDocuments())
        .documents;
    return outstandingTickets = outstandingtTicketDetails.map(_ticketFromDocument).toList();    
  }
  Future<List<Ticket>> paidticketsDetails(String licenseNumber) async{
    final instance = MockFirestoreInstance();
    await instance.collection('Ticket').add({
      'LicenseNumber': 'B1234567',
      'Status': 'closed',
      'LicensePlate': 'KI-1234',
    });
    List<DocumentSnapshot> outstandingtTicketDetails;
    List<Ticket> outstandingTickets;
    outstandingtTicketDetails = (await instance
        .collection("Ticket")
        .where("LicenseNumber", isEqualTo: licenseNumber)
        .where('Status', isEqualTo: 'closed')
        .getDocuments())
        .documents;
  return outstandingTickets = outstandingtTicketDetails.map(_ticketFromDocument).toList();    
}
  Future<List<Ticket>> reportedticketsDetails(String licenseNumber) async{
    final instance = MockFirestoreInstance();
    await instance.collection('Ticket').add({
      'LicenseNumber': 'B1234567',
      'Status': 'open',
      'LicensePlate': 'KI-1234',
    });
    List<DocumentSnapshot> outstandingtTicketDetails;
    List<Ticket> outstandingTickets;
    outstandingtTicketDetails = (await instance
        .collection("Ticket")
        .where("LicenseNumber", isEqualTo: licenseNumber)
        .where('Status', isEqualTo: 'reported')
        .getDocuments())
        .documents;
  return outstandingTickets = outstandingtTicketDetails.map(_ticketFromDocument).toList();    
}
}
class MockTicketCollection extends Mock implements CreateTicketNew {}
class MockAuthService extends Mock implements AuthService {}

class MockPoliceMan extends Mock implements DatabaseServicePolicemen{
   final String uid;

  MockPoliceMan({this.uid});
}

void main(){
  
  group('Test DriverProfile widget', (){
    Widget makeTestableWidgetDriverProfile({Widget child}) {
      return MaterialApp(
        home: child,
      );
    }

    Widget driverProfileNavigation({Widget child,mockobservers}) {
      return MaterialApp(
        home: child,
        navigatorObservers: [mockobservers],
      );
    }

    testWidgets('Verify widgets in ui when navigated', (WidgetTester tester) async{
      Driver driverdetails = Driver(licenseNumber: 'B1234567',name: 'John Green',address: 'No.39,1/2,Wellawatta',phoneNumber: 0712345678,
                                          emailAddress: 'abc@gmail.com',nicnumber: '9776542334V',physicalDisabilities: []);
      
      NinjaCardD driverProfileWidget = NinjaCardD(driver: driverdetails, ticket: null, driverImage: '',driverCollection: MockDriverCollection(),
                                                      creatingTicket: MockTicketCollection());
      await mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidgetDriverProfile(child:driverProfileWidget)));
      expect(find.byKey(Key('AddPictureLicensePlate')), findsNothing);
      expect(find.byKey(Key('DriverProfilePage')), findsOneWidget);
      expect(find.byKey(Key('DriverProfileAppBar')), findsOneWidget);
      expect(find.byKey(Key('DriverProfileAppText')), findsOneWidget);
      expect(find.byKey(Key('DriverImage')), findsOneWidget);
      expect(find.text('NIC NUMBER :'),findsOneWidget);
      expect(find.text('B1234567'),findsOneWidget);
      // expect(find.text('Poor Eyesight'),findsOneWidget);
      // expect(find.text('Parkinsons'),findsOneWidget);
      expect(find.byKey(Key('DriverProfileIcon')), findsOneWidget);
      expect(find.byKey(Key('DriverAddButton')), findsOneWidget);
      expect(find.byKey(Key('DriverViewButton')), findsOneWidget);
      expect(find.byKey(Key('TextWidgets')), findsOneWidget);
    });

    testWidgets('View Tickets Button Interaction', (WidgetTester tester) async{
      MockTicketCollection ticketCollMock = MockTicketCollection();
      MockDriverCollection driverCollMock = MockDriverCollection();
      Driver driverdetails = Driver(licenseNumber: 'B1234568',name: 'John Green',address: 'No.39,1/2,Wellawatta',phoneNumber: 0712345678,
                                          emailAddress: 'abc@gmail.com',nicnumber: '9776542334V',physicalDisabilities: []);
      when(ticketCollMock.getLocationFromCoordinates([])).thenAnswer((_) => Future.value(null));
      NinjaCardD driverProfileWidget = NinjaCardD(driver: driverdetails, ticket: null, driverImage: '',driverCollection: driverCollMock,
                                                      creatingTicket: ticketCollMock);
      final mockObserver = MockNavigatorObserver();
      await mockNetworkImagesFor(() => tester.pumpWidget(driverProfileNavigation(child:driverProfileWidget,mockobservers: mockObserver)));
      await tester.tap(find.byKey(Key('DriverViewButton')));
      await mockNetworkImagesFor(() => tester.pumpAndSettle());
      verify(mockObserver.didPush(any, any));
      verifyNever(ticketCollMock.getLocationFromCoordinates([]));
    });

    testWidgets('Add Tickets Button Interaction', (WidgetTester tester) async{
      MockTicketCollection ticketCollMock = MockTicketCollection();
      MockDriverCollection driverCollMock = MockDriverCollection();
      Driver driverdetails = Driver(licenseNumber: 'B1234568',name: 'John Green',address: 'No.39,1/2,Wellawatta',phoneNumber: 0712345678,
                                          emailAddress: 'abc@gmail.com',nicnumber: '9776542334V',physicalDisabilities: []);
      NinjaCardD driverProfileWidget = NinjaCardD(driver: driverdetails, ticket: null, driverImage: '',driverCollection: driverCollMock,
                                                      creatingTicket: ticketCollMock);
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(makeTestableWidgetDriverProfile(child:driverProfileWidget));
        await tester.tap(find.byKey(Key('DriverAddButton')));
        await tester.pumpWidget(makeTestableWidgetDriverProfile(child:driverProfileWidget));
        // expect(find.byKey(Key('AddPictureLicensePlate')), findsOneWidget);
        // expect(find.byType(AlertDialog), findsOneWidget);
        // expect(find.text('Add a picture of the vehicle with the license plate visible to continue'), findsOneWidget);
      });
    });
  });
  group('PoliceMen Profile Testing', (){
    Widget makeTestableWidgetUserProfile({Widget child, UserData user}) {
      return Provider<UserData>.value(
          value: user,
          child: MaterialApp(
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets('Verify widgets in ui when navigated', (WidgetTester tester) async {
      MockPoliceMan policemen = MockPoliceMan();
      MockAuthService auth = MockAuthService();
      NinjaCard userprofilewidget = NinjaCard(userImage: '', databaseServicePolicemen:policemen,authservice: auth );
      await mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: null)));
      expect(find.byKey(Key('HasChangePassword')), findsNothing);
      expect(find.byKey(Key('NotChangePassword')), findsOneWidget);
      expect(find.byKey(Key('PolicemenImage')), findsOneWidget);
      expect(find.text('ID-NUMBER : '), findsOneWidget);
      expect(find.byKey(Key('PolicemenImage')), findsOneWidget);
      expect(find.text('NIC NUMBER '),findsOneWidget);
      expect(find.text(''),findsNWidgets(4));
      expect(find.byKey(Key('PhoneNumber')), findsNothing);
      expect(find.byKey(Key('HasUserNumber')), findsOneWidget);
      expect(find.byKey(Key('noreset')), findsNothing);
      expect(find.byKey(Key('hasreset')), findsOneWidget);
      expect(find.byKey(Key('editprofile')), findsNothing);
      expect(find.byKey(Key('viewprofile')), findsOneWidget);
    });

    testWidgets('Verify edit profile interaction', (WidgetTester tester) async {
      MockPoliceMan policemen = MockPoliceMan();
      MockAuthService auth = MockAuthService();
      UserData userdetails = UserData(employeeID: '12345',address: 'NO. 12 , Colombo',phoneNumber: '0771234567',nicnumber: '965432134V',
                                          mailID: 'abc@gmail.com',firstName: 'john',lastName: 'green');
      NinjaCard userprofilewidget = NinjaCard(userImage: '', databaseServicePolicemen:policemen,authservice: auth );
      await mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails)));
      expect(find.text('12345'),findsOneWidget);
      expect(find.text('abc@gmail.com'),findsOneWidget);
      expect(find.text('john green'),findsOneWidget);
      await tester.tap(find.byKey(Key('viewprofile')));
      await mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails)));
      expect(find.byKey(Key('editprofile')), findsOneWidget);
      expect(find.byKey(Key('PhoneNumber')), findsOneWidget);
      expect(find.byKey(Key('HasUserNumber')), findsNothing);
      expect(find.byKey(Key('noreset')), findsOneWidget);
      expect(find.byKey(Key('hasreset')), findsNothing);
      expect(find.text('abc@gmail.com'),findsOneWidget);
    });

    testWidgets('Verify save profile interaction with incorrect variables', (WidgetTester tester) async {
      MockPoliceMan policemen = MockPoliceMan();
      MockAuthService auth = MockAuthService();
      UserData userdetails = UserData(employeeID: '12345',address: 'NO. 12 , Colombo',phoneNumber: '0771234567',nicnumber: '965432134V',
                                          mailID: 'abc@gmail.com',firstName: 'john',lastName: 'green');
      NinjaCard userprofilewidget = NinjaCard(userImage: '', databaseServicePolicemen:policemen,authservice: auth, );      
      await mockNetworkImagesFor(() =>
        tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails))
        ); 
      await tester.tap(find.byKey(Key('viewprofile')));
      await mockNetworkImagesFor(() =>
        tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails))
        ); 
      Finder emailField = find.byKey(Key('PhoneNumber'));
      await tester.enterText(emailField, '12345');
      await tester.tap(find.byKey(Key('editprofile')));
      await mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails)));
      expect(find.byKey(Key('editprofile')), findsOneWidget);
      expect(find.byKey(Key('PhoneNumber')), findsOneWidget);
      expect(find.byKey(Key('HasUserNumber')), findsNothing);
      expect(find.byKey(Key('noreset')), findsOneWidget);
      expect(find.byKey(Key('hasreset')), findsNothing);
    });

    testWidgets('Verify save profile interaction with null variables', (WidgetTester tester) async {
      MockPoliceMan policemen = MockPoliceMan();
      MockAuthService auth = MockAuthService();
      UserData userdetails = UserData(employeeID: '12345',address: 'NO. 12 , Colombo',phoneNumber: '0771234567',nicnumber: '965432134V',
                                          mailID: 'abc@gmail.com',firstName: 'john',lastName: 'green');
      NinjaCard userprofilewidget = NinjaCard(userImage: '', databaseServicePolicemen:policemen,authservice: auth, );      
      await mockNetworkImagesFor(() =>
        tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails))
        ); 
      await tester.tap(find.byKey(Key('viewprofile')));
      await mockNetworkImagesFor(() =>
        tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails))
        ); 
      Finder emailField = find.byKey(Key('PhoneNumber'));
      await tester.enterText(emailField, '');
      await tester.tap(find.byKey(Key('editprofile')));
      await mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails)));
      expect(find.byKey(Key('editprofile')), findsOneWidget);
      expect(find.byKey(Key('PhoneNumber')), findsOneWidget);
      expect(find.byKey(Key('HasUserNumber')), findsNothing);
      expect(find.byKey(Key('noreset')), findsOneWidget);
      expect(find.byKey(Key('hasreset')), findsNothing);
    });

    testWidgets('Verify save profile interaction with correct variables', (WidgetTester tester) async {
      MockPoliceMan policemen = MockPoliceMan();
      MockAuthService auth = MockAuthService();
      when(policemen.updateUserData(phoneNumber: '0771234567',address: 'NO. 12 , Colombo',email: 'abc@gmail.com')).thenAnswer((_) => Future.value(null));
      UserData userdetails = UserData(employeeID: '12345',address: 'NO. 12 , Colombo',phoneNumber: '0771234567',nicnumber: '965432134V',
                                          mailID: 'abc@gmail.com',firstName: 'john',lastName: 'green');
      NinjaCard userprofilewidget = NinjaCard(userImage: '', databaseServicePolicemen:policemen,authservice: auth, );      
      await mockNetworkImagesFor(() =>
        tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails))
        ); 
      await tester.tap(find.byKey(Key('viewprofile')));
      await mockNetworkImagesFor(() =>
        tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails))
        ); 
      Finder phoneField = find.byKey(Key('PhoneNumber'));
      await tester.enterText(phoneField, '0771234567');
      Finder emailField = find.byKey(Key('emailAddress'));
      await tester.enterText(emailField, 'abc@gmail.com');
      Finder addressfield = find.byKey(Key('userAddress'));
      await tester.enterText(addressfield, 'NO. 12 , Colombo');
      await tester.tap(find.byKey(Key('editprofile')));
      await mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails)));
    });

    testWidgets('reset password button', (WidgetTester tester) async {
      MockPoliceMan policemen = MockPoliceMan();
      MockAuthService auth = MockAuthService();
      when(auth.resetPassword('abc@gmail.com')).thenAnswer((_) => Future.value(true));
      UserData userdetails = UserData(employeeID: '12345',address: 'NO. 12 , Colombo',phoneNumber: '0771234567',nicnumber: '965432134V',
                                          mailID: 'abc@gmail.com',firstName: 'john',lastName: 'green');
      NinjaCard userprofilewidget = NinjaCard(userImage: '', databaseServicePolicemen:policemen,authservice: auth, );      
      await mockNetworkImagesFor(() =>
        tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails))
        ); 
      expect(find.byKey(Key('noreset')), findsNothing);
      expect(find.byKey(Key('hasreset')), findsOneWidget);
      await tester.tap(find.byKey(Key('hasreset')));
      await mockNetworkImagesFor(() =>
        tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails))
        );
      verify(auth.resetPassword('abc@gmail.com')).called(1); 
      expect(find.byKey(Key('HasChangePassword')), findsOneWidget);
      expect(find.byKey(Key('ReturnProfileButton')), findsOneWidget);
      expect(find.byKey(Key('NotChangePassword')), findsNothing);
    });

    testWidgets('reset password return button', (WidgetTester tester) async {
      MockPoliceMan policemen = MockPoliceMan();
      MockAuthService auth = MockAuthService();
      when(auth.resetPassword('abc@gmail.com')).thenAnswer((_) => Future.value(true));
      UserData userdetails = UserData(employeeID: '12345',address: 'NO. 12 , Colombo',phoneNumber: '0771234567',nicnumber: '965432134V',
                                          mailID: 'abc@gmail.com',firstName: 'john',lastName: 'green');
      NinjaCard userprofilewidget = NinjaCard(userImage: '', databaseServicePolicemen:policemen,authservice: auth, );      
      await mockNetworkImagesFor(() =>
        tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails))
        ); 
      await tester.tap(find.byKey(Key('hasreset')));
      await mockNetworkImagesFor(() =>
        tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails))
        );
      expect(find.byKey(Key('ReturnProfileButton')), findsOneWidget);
      await tester.tap(find.byKey(Key('ReturnProfileButton')));
      await mockNetworkImagesFor(() =>
      tester.pumpWidget(makeTestableWidgetUserProfile(child:userprofilewidget,user: userdetails))
      );
      expect(find.byKey(Key('HasChangePassword')), findsNothing);
      expect(find.byKey(Key('ReturnProfileButton')), findsNothing);
      expect(find.byKey(Key('NotChangePassword')), findsOneWidget);
    });
  });
}