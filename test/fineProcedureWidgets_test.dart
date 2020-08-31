import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/notification.dart';
import 'package:tpfs_policeman/models/procedure.dart';
import 'package:tpfs_policeman/models/vehicle.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:tpfs_policeman/services/db_vehicle.dart';
import 'package:tpfs_policeman/views/home/Notification_list.dart';
import 'package:tpfs_policeman/views/home/finingProcedure.dart';
import 'package:tpfs_policeman/views/home/searchVehicle.dart';

import 'authWidgets_test.dart';

class MockPolice extends Mock implements DatabaseServicePolicemen {}
class MockTicketCreation extends Mock implements CreateTicketNew {}
class MockVehicle extends Mock implements VehicleCollection {}
class MockCameraDescription extends Mock implements CameraDescription{} 

void main() {
  group('Fine Procedure Steps Testing', (){
    Widget makeTestableWidgetMainHome({Widget child,mockobservers}) {
      return MaterialApp(
      home: child,
      navigatorObservers: [mockobservers],
        );
    }

    testWidgets('FiningProcedure intial UI', (WidgetTester tester) async {
      MockPolice mockpolice = MockPolice();
      MockTicketCreation createticket = MockTicketCreation();
      Ticket ticketNew = new Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null,policemenemployeeID: '12345',
                                                          policemenstationID: '12398');
      ProcedurePolice procedureNew = new ProcedurePolice(startTime: FieldValue.serverTimestamp(),driverProfileSearched: null,vehicleProfileSearched: null,
                                                                ticket: null,criminalAssessment: null,ticketCreated:null,employeeID: '12345');
      FiningProcedure procedurewidget = FiningProcedure(policeUser: mockpolice,ticketCreation: createticket,ticket: ticketNew,
                                                            procedure: procedureNew);
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(makeTestableWidgetMainHome(child : procedurewidget,mockobservers: mockObserver));
      expect(find.byKey(Key('ProcedureAppBar')), findsOneWidget);
      expect(find.byKey(Key('ProcedureAppText')), findsOneWidget);
      expect(find.byKey(Key('ProcedureSteps')), findsOneWidget);
      expect(find.byKey(Key('ProcedureGrids')), findsOneWidget);
      expect(find.byKey(Key('EndProcedureButton')), findsOneWidget);
      expect(find.byKey(Key('VehcileProfile')), findsOneWidget);
      expect(find.byKey(Key('DriverProfile'),skipOffstage: false), findsOneWidget);
      await tester.drag(find.byKey(Key('ProcedureGrids')), const Offset(0.0, -4000));
      await tester.pump();
      expect(find.byKey(Key('CA'),skipOffstage: false), findsOneWidget);
      expect(find.byKey(Key('TicketCreation'),skipOffstage: false), findsOneWidget);
    });

    testWidgets('FiningProcedure search Vehicle Profile', (WidgetTester tester) async {
      MockPolice mockpolice = MockPolice();
      MockTicketCreation createticket = MockTicketCreation();
      MockCameraDescription camera = MockCameraDescription();
      MockCameraDescription camerasecond = MockCameraDescription();
      Ticket ticketNew = new Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null,policemenemployeeID: '12345',
                                                          policemenstationID: '12398');
      ProcedurePolice procedureNew = new ProcedurePolice(startTime: FieldValue.serverTimestamp(),driverProfileSearched: null,vehicleProfileSearched: null,
                                                                ticket: null,criminalAssessment: null,ticketCreated:null,employeeID: '12345');
      FiningProcedure procedurewidget = FiningProcedure(policeUser: mockpolice,ticketCreation: createticket,ticket: ticketNew,
                                                            camera: [camera,camerasecond],procedure: procedureNew);
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(makeTestableWidgetMainHome(child : procedurewidget,mockobservers: mockObserver));
      expect(find.byKey(Key('VehcileProfile')), findsOneWidget);
      await tester.tap(find.byKey(Key('VehcileProfile')));
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
      expect(find.byKey(Key('SearchVehicle')), findsOneWidget);
    });

    testWidgets('FiningProcedure search Driver Profile', (WidgetTester tester) async {
      MockPolice mockpolice = MockPolice();
      MockCameraDescription camera = MockCameraDescription();
      MockCameraDescription camerasecond = MockCameraDescription();
      MockTicketCreation createticket = MockTicketCreation();
      Ticket ticketNew = new Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null,policemenemployeeID: '12345',
                                                          policemenstationID: '12398');
      ProcedurePolice procedureNew = new ProcedurePolice(startTime: FieldValue.serverTimestamp(),driverProfileSearched: null,vehicleProfileSearched: null,
                                                                ticket: null,criminalAssessment: null,ticketCreated:null,employeeID: '12345');
      FiningProcedure procedurewidget = FiningProcedure(policeUser: mockpolice,ticketCreation: createticket,ticket: ticketNew,
                                                            procedure: procedureNew,camera: [camera,camerasecond],);
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(makeTestableWidgetMainHome(child : procedurewidget,mockobservers: mockObserver));
      await tester.drag(find.byKey(Key('ProcedureGrids')), const Offset(0.0, -500));
      await tester.pump();
      expect(find.byKey(Key('DriverProfile'),skipOffstage: false), findsOneWidget);
      Finder driverProfile = (find.byKey(Key('DriverProfile'),skipOffstage: false));
      await tester.tap(driverProfile);
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
    });

    testWidgets('FiningProcedure CA', (WidgetTester tester) async {
      MockPolice mockpolice = MockPolice();
      MockTicketCreation createticket = MockTicketCreation();
      Ticket ticketNew = new Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null,policemenemployeeID: '12345',
                                                          policemenstationID: '12398');
      ProcedurePolice procedureNew = new ProcedurePolice(startTime: FieldValue.serverTimestamp(),driverProfileSearched: null,vehicleProfileSearched: null,
                                                                ticket: null,criminalAssessment: null,ticketCreated:null,employeeID: '12345');
      FiningProcedure procedurewidget = FiningProcedure(policeUser: mockpolice,ticketCreation: createticket,ticket: ticketNew,
                                                            procedure: procedureNew);
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(makeTestableWidgetMainHome(child : procedurewidget,mockobservers: mockObserver));
      await tester.drag(find.byKey(Key('ProcedureGrids')), const Offset(0.0, -2000));
      await tester.pump();
      expect(find.byKey(Key('CA'),skipOffstage: false), findsOneWidget);
      Finder CA = (find.byKey(Key('CA'),skipOffstage: false));
      await tester.tap(CA);
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
      expect(find.byKey(Key('ProcedureAppBar')), findsOneWidget);
    });

    testWidgets('FiningProcedure Ticket creation', (WidgetTester tester) async {
      MockPolice mockpolice = MockPolice();
      MockTicketCreation createticket = MockTicketCreation();
      MockCameraDescription camera = MockCameraDescription();
      MockCameraDescription camerasecond = MockCameraDescription();
      when(createticket.fillTicketForm()).thenAnswer((_) => Future.value({'date': '12-12-2020','time' :'8.23 pm'}));
      when(createticket.getLocationData()).thenAnswer((_) => Future.value('No.12,Harmers Avenue,Wellawatta'));
      Ticket ticketNew = new Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null,policemenemployeeID: '12345',
                                                          policemenstationID: '12398');
      ProcedurePolice procedureNew = new ProcedurePolice(startTime: FieldValue.serverTimestamp(),driverProfileSearched: null,vehicleProfileSearched: null,
                                                                ticket: null,criminalAssessment: null,ticketCreated:null,employeeID: '12345');
      FiningProcedure procedurewidget = FiningProcedure(policeUser: mockpolice,ticketCreation: createticket,ticket: ticketNew,
                                                            camera: [camerasecond,camera],procedure: procedureNew);
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(makeTestableWidgetMainHome(child : procedurewidget,mockobservers: mockObserver));
      await tester.drag(find.byKey(Key('ProcedureGrids')), const Offset(0.0, -4000));
      await tester.pump();
      expect(find.byKey(Key('TicketCreation'),skipOffstage: false), findsOneWidget);
      Finder ticketCreation = (find.byKey(Key('TicketCreation'),skipOffstage: false));
      await tester.tap(ticketCreation);
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
      expect(find.byKey(Key('CreateTicketPage')), findsOneWidget);
    });

    testWidgets('FiningProcedure End Procedure', (WidgetTester tester) async {
      MockPolice mockpolice = MockPolice();
      MockTicketCreation createticket = MockTicketCreation();
      Ticket ticketNew = new Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null,policemenemployeeID: '12345',
                                                          policemenstationID: '12398');
      ProcedurePolice procedureNew = new ProcedurePolice(startTime: FieldValue.serverTimestamp(),driverProfileSearched: null,vehicleProfileSearched: null,
                                                                ticket: null,criminalAssessment: null,ticketCreated:null,employeeID: '12345');
      FiningProcedure procedurewidget = FiningProcedure(policeUser: mockpolice,ticketCreation: createticket,ticket: ticketNew,
                                                            procedure: procedureNew);
      when(mockpolice.updateProcedureCreated(procedureNew)).thenAnswer((_) => Future.value(null));
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(makeTestableWidgetMainHome(child : procedurewidget,mockobservers: mockObserver));
      await tester.tap(find.byKey(Key('EndProcedureButton')));
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
    });
  });

  group('SearchVehicle Widget Testing', (){

    Widget makeTestableWidgetSearch({Widget child}) {
      return MaterialApp(
      home: child,
      );
    }
    testWidgets('Initial UI of Search Vehicle', (WidgetTester tester) async {
      MockVehicle vehicleMock = MockVehicle();
      SearchVehicle vehcilewidget = SearchVehicle(vehicleCollection: vehicleMock);
      await tester.pumpWidget(makeTestableWidgetSearch(child: vehcilewidget));
      expect(find.byKey(Key('VehicleSearchAppbar')), findsOneWidget);
      expect(find.byKey(Key('VehicleSearchApptext')), findsOneWidget);
      expect(find.byKey(Key('SearchBarVehicle')), findsOneWidget);
      expect(find.byKey(Key('CancelWidget')), findsOneWidget);
      expect(find.byKey(Key('NoResultsText')), findsNothing);
      expect(find.byKey(Key('SearchResultTile')), findsNothing);
    });

    testWidgets('Search Vehicle UI-No Result', (WidgetTester tester) async {
      MockVehicle vehicleMock = MockVehicle();
      when(vehicleMock.searchLicensePlate('12345')).thenAnswer((_) => Future.value([]));
      SearchVehicle vehcilewidget = SearchVehicle(vehicleCollection: vehicleMock);
      await tester.pumpWidget(makeTestableWidgetSearch(child: vehcilewidget));
      Finder searchField = find.byKey(Key('SearchBarVehicle'));
      await tester.tap(searchField);
      // await tester.pumpWidget(makeTestableWidgetSearch(child: vehcilewidget));
      //await tester.enterText(searchField, '12345');
      // await tester.pumpWidget(makeTestableWidgetSearch(child: vehcilewidget),Duration(seconds: 10));
      // expect(find.byKey(Key('CancelWidget')), findsOneWidget);
      // expect(find.byKey(Key('NoResultsText')), findsOneWidget);
      // expect(find.byKey(Key('SearchResultTile')), findsNothing); 
    });

    testWidgets('Search Vehicle UI-Result Present', (WidgetTester tester) async {
      MockVehicle vehicleMock = MockVehicle();
      when(vehicleMock.searchLicensePlate('53388233bh')).thenAnswer((_) => Future.value([Vehicle(licensePlate: '53388233bh',insuranceNumber: '12309273jn',
                                                                              regownerNumber: '0754312678',makeAndModel: 'Blue Sedan',regOwner: 'Rajesh',
                                                                              conditionAndClass: [],regNICNumber: '871234098V')]));
      SearchVehicle vehcilewidget = SearchVehicle(vehicleCollection: vehicleMock);
      await tester.pumpWidget(makeTestableWidgetSearch(child: vehcilewidget));
      Finder searchField = find.byKey(Key('SearchBarVehicle'));
      // await tester.enterText(searchField, '53388233bh');
      // await tester.pumpAndSettle(Duration(seconds: 10));
      // expect(find.byKey(Key('CancelWidget')), findsOneWidget);
      // expect(find.byKey(Key('NoResultsText')), findsNothing);
    });

    testWidgets('Search Vehicle UI-Cancel Search', (WidgetTester tester) async {
      MockVehicle vehicleMock = MockVehicle();
      when(vehicleMock.searchLicensePlate('53388233bh')).thenAnswer((_) => Future.value([Vehicle(licensePlate: '53388233bh',insuranceNumber: '12309273jn',
                                                                              regownerNumber: '0754312678',makeAndModel: 'Blue Sedan',regOwner: 'Rajesh',
                                                                              conditionAndClass: [],regNICNumber: '871234098V')]));
      SearchVehicle vehcilewidget = SearchVehicle(vehicleCollection: vehicleMock);
      await tester.pumpWidget(makeTestableWidgetSearch(child: vehcilewidget));
      Finder searchField = find.byKey(Key('SearchBarVehicle'));
      // await tester.enterText(searchField, '53388233bh');
      // await tester.tap(find.byKey(Key('CancelWidget')));
      // await tester.pumpAndSettle(Duration(seconds: 10));
      // expect(find.byKey(Key('CancelWidget')), findsOneWidget);
      // expect(find.byKey(Key('NoResultsText')), findsNothing);
      // expect(find.byKey(Key('SearchResultTile')), findsNothing);
    });
  });

  group('Notification Tab Widget', (){
    Widget makeTestableWidgetNotifications({Widget child,List<NotificationPresent> notifications}) {
      return Provider<List<NotificationPresent>>.value(
        value:notifications,
        child: MaterialApp(
        home: Scaffold(body: child),
        ),
      );
    }

    testWidgets('UI of Notifications tab', (WidgetTester tester) async {
      List<NotificationPresent> notifications = [NotificationPresent(title:'New Fine',description:'New fine of Rs.30000 has been added'),
                                                 NotificationPresent(title:'Increase in Fine',description:'RS.20000 increase in fine for drunk and drive')];
      Notificationlist notificationwidget = Notificationlist();
      await tester.pumpWidget(makeTestableWidgetNotifications(child: notificationwidget,notifications: notifications));
      expect(find.byKey(Key('NotificationListBuilder')), findsOneWidget);
      expect(find.text('New Fine'), findsOneWidget);
      expect(find.text('RS.20000 increase in fine for drunk and drive'), findsOneWidget);
      expect(find.text('New fine of Rs.30000 has been added'), findsOneWidget);
      expect(find.text('Increase in Fine'), findsOneWidget);

    });
  });
}