import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/views/tickets/Ticket_list.dart';
import 'package:tpfs_policeman/views/tickets/ticketHistory.dart';

import 'authWidgets_test.dart';

void main() {
  group('Check Ticket History', (){
    Widget ticketHistoryWidgetTestable({Widget child}) {
    return MaterialApp(
      home: child,
    );
    }

    testWidgets('TicketHistory Main Intial widget UI-No Tickets', (WidgetTester tester) async {
      TicketHistory tickethistorywidget = TicketHistory(outstandingTickets: [],paidTickets: [],reportedTickets: [],
                  offencelist: [],permoutstandingTickets: [],permpaidTickets: [],permreportedTickets: [],);
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      expect(find.byKey(Key('TicketHistoryTab')), findsOneWidget);
      expect(find.byKey(Key('TicketAppBarHistory')), findsOneWidget);
      expect(find.byKey(Key('FilterTicketsWidget')), findsOneWidget);
      expect(find.byKey(Key('TopTabBarTickets')), findsOneWidget);
      expect(find.byKey(Key('Outstanding')), findsOneWidget);
      expect(find.byKey(Key('Paid')), findsOneWidget);
      expect(find.byKey(Key('Reported')), findsOneWidget);
      expect(find.byKey(Key('ViewBodyTab')), findsOneWidget);
      expect(find.byKey(Key('outHistory')), findsNothing);
      expect(find.byKey(Key('paidHistory')), findsNothing);
      expect(find.byKey(Key('repHistory')), findsNothing);
      expect(find.byKey(Key('nooutHistory')), findsOneWidget);
      expect(find.byKey(Key('nopaidHistory')), findsNothing);
      expect(find.byKey(Key('norepHistory')), findsNothing);
    });

    testWidgets('TicketHistory Main Intial widget UI-With Tickets', (WidgetTester tester) async {
      TicketHistory tickethistorywidget = TicketHistory(outstandingTickets: [Ticket(fineAmount: 23000.0,status: 'open',date: '12-12-2012',
                                              time: '12.33 pm',offences: ['Not wearing helmet'])],paidTickets: [],reportedTickets: [],
                  offencelist: [],permoutstandingTickets: [Ticket(fineAmount: 23000.0,status: 'open',date: '12-12-2012',
                                              time: '12.33 pm',offences: ['Not wearing helmet'])],permpaidTickets: [],permreportedTickets: [],);
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      expect(find.byKey(Key('outHistory')), findsOneWidget);
      expect(find.byKey(Key('paidHistory')), findsNothing);
      expect(find.byKey(Key('repHistory')), findsNothing);
      expect(find.byKey(Key('nooutHistory')), findsNothing);
      expect(find.byKey(Key('nopaidHistory')), findsNothing);
      expect(find.byKey(Key('norepHistory')), findsNothing);
    });

    testWidgets('TicketHistory FilterList-Filter All', (WidgetTester tester) async {
      TicketHistory tickethistorywidget = TicketHistory(outstandingTickets: [Ticket(fineAmount: 23000.0,status: 'open',date: '12-12-2012',
                                              time: '12.33 pm',offences: ['Not wearing helmet'])],paidTickets: [],reportedTickets: [],
                  offencelist: ['Not wearing helmet','SpeedDriving'],permoutstandingTickets: [Ticket(fineAmount: 23000.0,status: 'open',date: '12-12-2012',
                                              time: '12.33 pm',offences: ['Not wearing helmet'])],permpaidTickets: [],permreportedTickets: [],);
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      expect(find.byKey(Key('FilterTicketsWidget')), findsOneWidget);
      await tester.tap(find.byKey(Key('FilterTicketsWidget')));
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      await tester.tap(find.byKey(Key('ChoiceSpeedDriving')));
      await tester.tap(find.byKey(Key('AllButton')));
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      expect(find.byKey(Key('outHistory')), findsOneWidget);
      expect(find.byKey(Key('nooutHistory')), findsNothing);
    }); 
    testWidgets('TicketHistory FilterList-Filter Apply - filter not in offence', (WidgetTester tester) async {
      TicketHistory tickethistorywidget = TicketHistory(outstandingTickets: [Ticket(fineAmount: 23000.0,status: 'open',date: '12-12-2012',
                                              time: '12.33 pm',offences: ['Not wearing helmet'])],paidTickets: [],reportedTickets: [],
                  offencelist: ['Not wearing helmet','SpeedDriving'],permoutstandingTickets: [Ticket(fineAmount: 23000.0,status: 'open',date: '12-12-2012',
                                              time: '12.33 pm',offences: ['Not wearing helmet'])],permpaidTickets: [],permreportedTickets: [],);
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      expect(find.byKey(Key('FilterTicketsWidget')), findsOneWidget);
      await tester.tap(find.byKey(Key('FilterTicketsWidget')));
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      await tester.tap(find.byKey(Key('ChoiceSpeedDriving')));
      await tester.tap(find.byKey(Key('ApplyButton')));
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      expect(find.byKey(Key('outHistory')), findsNothing);
      expect(find.byKey(Key('nooutHistory')), findsOneWidget);
    }); 

    testWidgets('TicketHistory FilterList-Filter Apply - filter in offence', (WidgetTester tester) async {
      TicketHistory tickethistorywidget = TicketHistory(outstandingTickets: [Ticket(fineAmount: 23000.0,status: 'open',date: '12-12-2012',
                                              time: '12.33 pm',offences: ['Not wearing helmet'])],paidTickets: [],reportedTickets: [],
                  offencelist: ['Not wearing helmet','SpeedDriving'],permoutstandingTickets: [Ticket(fineAmount: 23000.0,status: 'open',date: '12-12-2012',
                                              time: '12.33 pm',offences: ['Not wearing helmet'])],permpaidTickets: [],permreportedTickets: [],);
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      expect(find.byKey(Key('FilterTicketsWidget')), findsOneWidget);
      await tester.tap(find.byKey(Key('FilterTicketsWidget')));
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget)); 
      await tester.tap(find.byKey(Key('ChoiceNot wearing helmet')));
      await tester.tap(find.byKey(Key('ResetButton')));
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      expect(find.byKey(Key('outHistory')), findsOneWidget);
      expect(find.byKey(Key('nooutHistory')), findsNothing);
    });
    
    testWidgets('TicketHistory FilterList-Filter Reset', (WidgetTester tester) async {
      TicketHistory tickethistorywidget = TicketHistory(outstandingTickets: [Ticket(fineAmount: 23000.0,status: 'open',date: '12-12-2012',
                                              time: '12.33 pm',offences: ['Not wearing helmet'])],paidTickets: [],reportedTickets: [],
                  offencelist: ['Not wearing helmet','SpeedDriving'],permoutstandingTickets: [Ticket(fineAmount: 23000.0,status: 'open',date: '12-12-2012',
                                              time: '12.33 pm',offences: ['Not wearing helmet'])],permpaidTickets: [],permreportedTickets: [],);
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      expect(find.byKey(Key('FilterTicketsWidget')), findsOneWidget);
      await tester.tap(find.byKey(Key('FilterTicketsWidget')));
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      await tester.tap(find.byKey(Key('ChoiceSpeedDriving')));
      await tester.tap(find.byKey(Key('ResetButton')));
      await tester.pumpWidget(ticketHistoryWidgetTestable(child: tickethistorywidget));
      expect(find.byKey(Key('outHistory')), findsOneWidget);
      expect(find.byKey(Key('nooutHistory')), findsNothing);
    });
  });

  group('TicketTile UI - Tickets', (){
    Widget ticketListWidgetTestable({Widget child}) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
    }
    Widget ticketListWidgetTestableNavigation({Widget child,mockobservers}) {
    return MaterialApp(
    home: Scaffold(body: child),
    navigatorObservers: [mockobservers],
      );
    }
    testWidgets('Ticket List UI with Tickets', (WidgetTester tester) async {
      Ticketlist tickets = Ticketlist(tickets: [Ticket(fineAmount: 23000.0,status: 'open',date: '12-12-2012',
                                              time: '12.33 pm',offences: ['Not wearing helmet'])]);
      await tester.pumpWidget(ticketListWidgetTestable(child: tickets));
      expect(find.byKey(Key('TicketListBuilder')), findsOneWidget);
      expect(find.text('12.33 pm'), findsOneWidget);
      expect(find.text('Not wearing helmet'), findsOneWidget);
      expect(find.byKey(Key('tile2')), findsNothing);
    });

    testWidgets('Ticket tile Navigation details', (WidgetTester tester) async {
      Ticketlist tickets = Ticketlist(tickets: [Ticket(fineAmount: 23000.0,status: 'open',date: '12-12-2012',area: '',vehicle: 'Car',
                                              licenseNumber: '',licensePlate: '',time: '12.33 pm',offences: ['Not wearing helmet'])]);
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(ticketListWidgetTestableNavigation(child: tickets,mockobservers: mockObserver));
      expect(find.byKey(Key('ListTile')), findsOneWidget);
      await tester.tap(find.byKey(Key('ListTile')));
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
      expect(find.byKey(Key('Details')), findsOneWidget);
    });
  });
}