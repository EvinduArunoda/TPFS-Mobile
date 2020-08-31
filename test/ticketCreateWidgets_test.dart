import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/fine.dart';
import 'package:tpfs_policeman/models/procedure.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/views/tickets/createTicket.dart';
import 'package:tpfs_policeman/views/tickets/fineList.dart';
import 'package:tpfs_policeman/views/tickets/fineTicket.dart';
import 'authWidgets_test.dart';

void main(){
  group('CreateTicketPage1', (){
    Widget makeTestableTicketOne({Widget child}) {
    return MaterialApp(
    home: child,
      );
    }

    Widget makeTestableTicketOneNavigation({Widget child,mockobservers}) {
    return MaterialApp(
    home: child,
    navigatorObservers: [mockobservers],
      );
    }

    testWidgets('Ticket Page One with all ticket details empty', (WidgetTester tester) async {
      CreateTicket ticketonewidget = CreateTicket(dateAndTime: {'date':'12-12-2013','time':'12.12 pm'}, ticket:Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null),
                                                      location: 'harmers avenue',);
      await tester.pumpWidget(makeTestableTicketOne(child: ticketonewidget));
      expect(find.byKey(Key('AppbarTicket')), findsOneWidget);
      expect(find.byKey(Key('licensenumfield')), findsOneWidget);
      expect(find.byKey(Key('licensefield')), findsOneWidget);
      expect(find.byKey(Key('phoneText')), findsNothing);
      expect(find.byKey(Key('ChangeButton')), findsNothing);
      expect(find.byKey(Key('phoneFieldVal')), findsOneWidget);
      expect(find.byKey(Key('CancelButton')), findsOneWidget);
      expect(find.byKey(Key('ContinueTicketButton')), findsOneWidget);
      expect(find.text('12-12-2013'), findsOneWidget);
      expect(find.text('harmers avenue'), findsOneWidget);
    });

    testWidgets('Ticket Page One with all ticket details already present', (WidgetTester tester) async {
      CreateTicket ticketonewidget = CreateTicket(dateAndTime: {'date':'12-12-2013','time':'12.12 pm'}, ticket:Ticket(licenseNumber: 'B1234567',licensePlate: 'ki-1234',vehicle: null,fineAmount: null,status: null,
                                                      phoneNumber: 0771234567),location: 'harmers avenue',);
      await tester.pumpWidget(makeTestableTicketOne(child: ticketonewidget));
      expect(find.byKey(Key('licensenumfield')), findsNothing);
      expect(find.byKey(Key('licensefield')), findsNothing);
      expect(find.byKey(Key('phoneText')), findsOneWidget);
      expect(find.byKey(Key('ChangeButton')), findsOneWidget);
      expect(find.byKey(Key('phoneFieldVal')), findsNothing);
      expect(find.text('B1234567'), findsOneWidget);
      expect(find.text('ki-1234'), findsOneWidget);
    });

    testWidgets('Ticket Page One with only some details already present', (WidgetTester tester) async {
      CreateTicket ticketonewidget = CreateTicket(dateAndTime: {'date':'12-12-2013','time':'12.12 pm'}, ticket:Ticket(licenseNumber: null,licensePlate: 'ki-1234',vehicle: null,fineAmount: null,status: null),location: 'harmers avenue',);
      await tester.pumpWidget(makeTestableTicketOne(child: ticketonewidget));
      expect(find.byKey(Key('licensenumfield')), findsOneWidget);
      expect(find.byKey(Key('licensefield')), findsNothing);
      expect(find.byKey(Key('phoneText')), findsNothing);
      expect(find.byKey(Key('ChangeButton')), findsNothing);
      expect(find.byKey(Key('phoneFieldVal')), findsOneWidget);
      expect(find.text('ki-1234'), findsOneWidget);
      expect(find.text('B1234567'), findsNothing);
    });

    testWidgets('Ticket Page One with all ticket details correct', (WidgetTester tester) async {
      CreateTicket ticketonewidget = CreateTicket(dateAndTime: {'date':'12-12-2013','time':'12.12 pm'}, ticket:Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null),
                                                      location: 'harmers avenue',);
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(makeTestableTicketOneNavigation(child: ticketonewidget,mockobservers: mockObserver));
      Finder phonefield = find.byKey(Key('phoneFieldVal'));
      await tester.enterText(phonefield, '0771234567');
      Finder licenseField = find.byKey(Key('licensenumfield'));
      await tester.enterText(licenseField, 'B1234567');
      Finder platefield = find.byKey(Key('licensenumfield'));
      await tester.enterText( platefield, 'ki-1234');
      await tester.tap(find.byKey(Key('ContinueTicketButton')));
      await tester.pumpWidget(makeTestableTicketOneNavigation(child: ticketonewidget,mockobservers: mockObserver));
      verify(mockObserver.didPush(any, any));
    });

    testWidgets('Ticket Page One -Cancel Button Pressed', (WidgetTester tester) async {
      CreateTicket ticketonewidget = CreateTicket(dateAndTime: {'date':'12-12-2013','time':'12.12 pm'}, ticket:Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null),
                                                      location: 'harmers avenue',);
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(makeTestableTicketOneNavigation(child: ticketonewidget,mockobservers: mockObserver));
      Finder phonefield = find.byKey(Key('phoneFieldVal'));
      await tester.enterText(phonefield, '0771234567');
      Finder licenseField = find.byKey(Key('licensenumfield'));
      await tester.enterText(licenseField, 'B1234567');
      Finder platefield = find.byKey(Key('licensenumfield'));
      await tester.enterText( platefield, 'ki-1234');
      await tester.tap(find.byKey(Key('CancelButton')));
      await tester.pumpWidget(makeTestableTicketOneNavigation(child: ticketonewidget,mockobservers: mockObserver));
      verify(mockObserver.didPush(any, any));
    });
  });

  group('Create Ticket Page 3', (){
  Widget makeTestableTicketTwo({Widget child}) {
    return MaterialApp(
    home: child,
      );
    }

    testWidgets('Create Page Three - Tickets empty', (WidgetTester tester) async {
      FineList tickettwowidget = FineList(ticket:Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null),
                                            procedure: ProcedurePolice(ticket: null),fines: [],);
      await tester.pumpWidget(makeTestableTicketTwo(child: tickettwowidget));
      expect(find.byKey(Key('TicketPagethreeAppbar')), findsOneWidget);
      expect(find.byKey(Key('finesbuilder')), findsOneWidget);
      expect(find.byKey(Key('Pagethreeticket')), findsNothing);      
      expect(find.byKey(Key('Pagethreecancelbutton')), findsOneWidget);
      expect(find.byKey(Key('Pagethreecontinuebutton')), findsOneWidget);
    });

    testWidgets('Create Page Three - Two Tickets Present', (WidgetTester tester) async {
      FineList tickettwowidget = FineList(ticket:Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null),
                                            procedure: ProcedurePolice(ticket: null),fines: [Fine(fineDescription: 'Speeding',fineAmount: 1234.00),Fine(fineDescription: 'No helmet',fineAmount: 1239.00)],);
      await tester.pumpWidget(makeTestableTicketTwo(child: tickettwowidget));
      expect(find.byKey(Key('TicketPagethreeAppbar')), findsOneWidget);
      expect(find.byKey(Key('finesbuilder')), findsOneWidget);
      expect(find.byKey(Key('Pagethreeticket')), findsNWidgets(2));      
      expect(find.byKey(Key('Pagethreecancelbutton')), findsOneWidget);
      expect(find.byKey(Key('Pagethreecontinuebutton')), findsOneWidget);
      expect(find.byKey(Key('tilefine')), findsNWidgets(2));
      expect(find.byKey(Key('checkboxtilefine')), findsNWidgets(2));
      expect(find.text('Speeding'), findsOneWidget);
      expect(find.text('No helmet'), findsOneWidget);
    });

    testWidgets('Create Page Three - One Tickets Present', (WidgetTester tester) async {
      FineList tickettwowidget = FineList(ticket:Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null),
                                            procedure: ProcedurePolice(ticket: null),fines: [Fine(fineDescription: 'Speeding',fineAmount: 1234.00)],);
      await tester.pumpWidget(makeTestableTicketTwo(child: tickettwowidget));
      expect(find.byKey(Key('TicketPagethreeAppbar')), findsOneWidget);
      expect(find.byKey(Key('finesbuilder')), findsOneWidget);
      expect(find.byKey(Key('Pagethreeticket')), findsOneWidget);      
      expect(find.byKey(Key('Pagethreecancelbutton')), findsOneWidget);
      expect(find.byKey(Key('Pagethreecontinuebutton')), findsOneWidget);
      expect(find.byKey(Key('tilefine')), findsOneWidget);
      expect(find.byKey(Key('checkboxtilefine')), findsOneWidget);
      expect(find.text('Speeding'), findsOneWidget);
      expect(find.text('No helmet'), findsNothing);
    });
  });

  group('Create Page 4', (){

    Widget makeTestableTicketThree({Widget child,User user}) {
    return Provider<User>.value(
      value:user,
      child: MaterialApp(
      home: child,
        ),
    );
    }
    Widget makeTestableTicketFourNavigation({Widget child,mockobservers,User user}) {
    return Provider<User>.value(
      value:user,
      child: MaterialApp(
        home: child,
        navigatorObservers: [mockobservers],
        ),
    );
    }
    testWidgets('Ticket Page four - initial page', (WidgetTester tester) async {
      FineTicket ticketpagethreewidget = FineTicket(ticket: Ticket(licenseNumber: 'B1234567',licensePlate: 'ki-1234',vehicle: 'Car',fineAmount: 1239.12,
                          area: 'Colombo-06',time: '12.12pm',offences: ['Speeding'],date:'12-12-2013',status: null), callable: CloudFunctions.instance.getHttpsCallable(functionName: 'issueTicket'));
      await tester.pumpWidget(makeTestableTicketThree(child: ticketpagethreewidget,user: User(uid:'dgkgk362')));
      expect(find.byKey(Key('Pagefourappbar')), findsOneWidget);
      expect(find.byKey(Key('checkboxiconpagefour')), findsNothing);
      expect(find.byKey(Key('ticketpagefourcard')), findsOneWidget);      
      expect(find.byKey(Key('Closeticketbutton')), findsNothing);
      expect(find.byKey(Key('Ticketnotcreatedbuttonbar')), findsOneWidget);
      expect(find.byKey(Key('Acceptancedialog')), findsNothing);
      expect(find.text('B1234567'), findsOneWidget);
      expect(find.text('Car'), findsOneWidget);
    });

    testWidgets('Ticket Page four - Create Button, Open dialog', (WidgetTester tester) async {
      FineTicket ticketpagethreewidget = FineTicket(ticket: Ticket(licenseNumber: 'B1234567',licensePlate: 'ki-1234',vehicle: 'Car',fineAmount: 1239.12,
                          area: 'Colombo-06',time: '12.12pm',offences: ['Speeding'],date:'12-12-2013',status: null), callable: CloudFunctions.instance.getHttpsCallable(functionName: 'issueTicket'));
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(makeTestableTicketFourNavigation(child: ticketpagethreewidget,user: User(uid:'dgkgk362'),mockobservers: mockObserver));
      await tester.tap(find.byKey(Key('createticketbuttonpagefour')));
      await tester.pumpWidget(makeTestableTicketFourNavigation(child: ticketpagethreewidget,user: User(uid:'dgkgk362'),mockobservers: mockObserver));
      expect(find.byKey(Key('Acceptancedialog')), findsOneWidget);
      expect(find.text('Customer Acceptance'), findsOneWidget);
      expect(find.byKey(Key('Canceldialogacceptancebutton')), findsOneWidget);      
    });

    testWidgets('Ticket Page four - Close dialog', (WidgetTester tester) async {
      FineTicket ticketpagethreewidget = FineTicket(ticket: Ticket(licenseNumber: 'B1234567',licensePlate: 'ki-1234',vehicle: 'Car',fineAmount: 1239.12,
                          area: 'Colombo-06',time: '12.12pm',offences: ['Speeding'],date:'12-12-2013',status: null), callable: CloudFunctions.instance.getHttpsCallable(functionName: 'issueTicket'));
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(makeTestableTicketFourNavigation(child: ticketpagethreewidget,user: User(uid:'dgkgk362'),mockobservers: mockObserver));
      await tester.tap(find.byKey(Key('createticketbuttonpagefour')));
      await tester.pumpWidget(makeTestableTicketFourNavigation(child: ticketpagethreewidget,user: User(uid:'dgkgk362'),mockobservers: mockObserver));
      expect(find.byKey(Key('Acceptancedialog')), findsOneWidget);
      expect(find.byKey(Key('Canceldialogacceptancebutton')), findsOneWidget);   
      await tester.tap(find.byKey(Key('Canceldialogacceptancebutton')));
      await tester.pumpWidget(makeTestableTicketFourNavigation(child: ticketpagethreewidget,user: User(uid:'dgkgk362'),mockobservers: mockObserver));
      expect(find.byKey(Key('Acceptancedialog')), findsNothing);
    });
  });
}