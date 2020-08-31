import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/driver.dart';
import 'package:tpfs_policeman/models/validate.dart';
import 'package:tpfs_policeman/models/vehicle.dart';
import 'package:tpfs_policeman/services/validateTicket.dart';
import 'package:tpfs_policeman/views/tickets/addImageToTicket.dart';
import 'package:tpfs_policeman/views/tickets/validateResult.dart';

import 'authWidgets_test.dart';

void main() {

  group('Validate license plate widget', (){

    Widget validateresultwidget({Widget child,Validate result}) {
    return Provider<Validate>.value(
      value:result,
      child: MaterialApp(
      home: child,
        ),
    );
    }

    testWidgets('widget before validated result present', (WidgetTester tester) async {
      ValidateResult resultvalidationwidget = ValidateResult(ticket: Ticket(),ticketvalidate: ValidateTicket());
      await tester.pumpWidget(validateresultwidget(child : resultvalidationwidget,result: null));
      expect(find.byKey(Key('Columnvalidatematch')), findsOneWidget);
      expect(find.text('Validation On Process'), findsOneWidget);
      expect(find.text('Validation On Process%'), findsOneWidget);
    });

    testWidgets('widget after validated result present,one result', (WidgetTester tester) async {
      Validate resultvalidation = Validate(docid: 'bdjke392jbfwbe',licensePlateValidation: {'prediction':[{'ocr_text':'CAS 9034','score':0.981263258}]});
      ValidateResult resultvalidationwidget = ValidateResult(ticket: Ticket(validatedText: null,validatedTextScore: null),ticketvalidate: ValidateTicket(licenseplate: null));
      await tester.pumpWidget(validateresultwidget(child : resultvalidationwidget,result: resultvalidation));
      expect(find.byKey(Key('Columnvalidatematch')), findsOneWidget);
      expect(find.text('CAS 9034'), findsOneWidget);
      expect(find.text('98.1263258%'), findsOneWidget);
    });

    testWidgets('widget after validated result present,more than one result', (WidgetTester tester) async {
      Validate resultvalidation = Validate(docid: 'bdjke392jbfwbe',licensePlateValidation: {'prediction':[{'ocr_text':'CAS 9034','score':0.971263258},{'ocr_text':'CAS 9084','score':0.981463258}]});
      ValidateResult resultvalidationwidget = ValidateResult(ticket: Ticket(validatedText: null,validatedTextScore: null),ticketvalidate: ValidateTicket(licenseplate: null));
      await tester.pumpWidget(validateresultwidget(child : resultvalidationwidget,result: resultvalidation));
      expect(find.byKey(Key('Columnvalidatematch')), findsOneWidget);
      expect(find.text('CAS 9084'), findsOneWidget);
      expect(find.text('98.1463258%'), findsOneWidget);
    });
  });
  
  group('Ticket Validation Take Picture page', (){

    Widget makeTicketTestableTakePicture({Widget child}) {
    return MaterialApp(
        home: child,
    );
    }

    testWidgets('Take Picture - for vehicle image,with image', (WidgetTester tester) async {
      TakePictureTicket takepicturewidget = TakePictureTicket(isVehicle: true,imagePath: 'temp/576576.jpg',vehicle: Vehicle(licensePlate: 'KI-1234',
                                        insuranceNumber: '0912746379YH'),ticket: Ticket(licensePlate: null,licenseNumber: null));
      await tester.pumpWidget(makeTicketTestableTakePicture(child: takepicturewidget));
      expect(find.byKey(Key('Taketicketimageappbar')), findsOneWidget);
      expect(find.byKey(Key('isvehiclelicenseplate')), findsOneWidget);
      expect(find.byKey(Key('isdriverlicensenumber')), findsNothing);
      expect(find.byKey(Key('addticketimagebutton')), findsOneWidget);
      expect(find.byKey(Key('dialogaddticketimage')), findsNothing);
      expect(find.byKey(Key('iconwithimage')), findsOneWidget);
      expect(find.byKey(Key('iconnoimage')), findsNothing);
      expect(find.text('Add Vehicle image to Ticket'), findsOneWidget);
      expect(find.text('Add license image to Ticket'), findsNothing);
      expect(find.text('KI-1234'), findsOneWidget);
    });

    testWidgets('Take Picture - for driver image,with image', (WidgetTester tester) async {
      TakePictureTicket takepicturewidget = TakePictureTicket(isVehicle: false,imagePath: 'temp/576576.jpg',driver: Driver(licenseNumber: 'B1234567',name: 'John green'),ticket: Ticket(licensePlate: null,licenseNumber: null));
      await tester.pumpWidget(makeTicketTestableTakePicture(child: takepicturewidget));
      expect(find.byKey(Key('Taketicketimageappbar')), findsOneWidget);
      expect(find.byKey(Key('isvehiclelicenseplate')), findsNothing);
      expect(find.byKey(Key('isdriverlicensenumber')), findsOneWidget);
      expect(find.byKey(Key('addticketimagebutton')), findsOneWidget);
      expect(find.byKey(Key('dialogaddticketimage')), findsNothing);
      expect(find.byKey(Key('iconwithimage')), findsOneWidget);
      expect(find.byKey(Key('iconnoimage')), findsNothing);
      expect(find.text('Add Vehicle image to Ticket'), findsNothing);
      expect(find.text('Add license image to Ticket'), findsOneWidget);
      expect(find.text('B1234567'), findsOneWidget);
    });

    testWidgets('Take Picture - open dialog driver', (WidgetTester tester) async {
      TakePictureTicket takepicturewidget = TakePictureTicket(isVehicle: false,imagePath: 'temp/576576.jpg',driver: Driver(licenseNumber: 'B1234567',name: 'John green',phoneNumber: 0765123456),ticket: Ticket(licenseNumber: null));
      await tester.pumpWidget(makeTicketTestableTakePicture(child: takepicturewidget));
      await tester.tap(find.byKey(Key('addticketimagebutton')));
      await tester.pumpWidget(makeTicketTestableTakePicture(child: takepicturewidget));
      expect(find.byKey(Key('dialogaddticketimage')), findsOneWidget);
      expect(find.byKey(Key('addticketcontinuebutton')), findsOneWidget);
      expect(find.byKey(Key('addticketcancelbutton')), findsOneWidget);
      expect(find.text('Vehicle reference has been added to the ticket'), findsNothing);
      expect(find.text('Driver reference has been added to the ticket'), findsOneWidget);
    });

    testWidgets('Take Picture - open dialog vehicle', (WidgetTester tester) async {
      TakePictureTicket takepicturewidget = TakePictureTicket(isVehicle: true,imagePath: 'temp/576576.jpg',vehicle: Vehicle(licensePlate: 'KI-1234',
                                        insuranceNumber: '0912746379YH'),ticket: Ticket(licensePlate: null,licenseNumber: null));
      await tester.pumpWidget(makeTicketTestableTakePicture(child: takepicturewidget));
      await tester.tap(find.byKey(Key('addticketimagebutton')));
      await tester.pumpWidget(makeTicketTestableTakePicture(child: takepicturewidget));
      expect(find.byKey(Key('dialogaddticketimage')), findsOneWidget);
      expect(find.byKey(Key('addticketcontinuebutton')), findsOneWidget);
      expect(find.byKey(Key('addticketcancelbutton')), findsOneWidget);
      expect(find.text('Vehicle reference has been added to the ticket'), findsOneWidget);
      expect(find.text('Driver reference has been added to the ticket'), findsNothing);
    });

    testWidgets('Take Picture - cancel button dialog', (WidgetTester tester) async {
      TakePictureTicket takepicturewidget = TakePictureTicket(isVehicle: true,imagePath: 'temp/576576.jpg',vehicle: Vehicle(licensePlate: 'KI-1234',
                                        insuranceNumber: '0912746379YH'),ticket: Ticket(licensePlate: null,licenseNumber: null));
      await tester.pumpWidget(makeTicketTestableTakePicture(child: takepicturewidget));
      await tester.tap(find.byKey(Key('addticketimagebutton')));
      await tester.pumpWidget(makeTicketTestableTakePicture(child: takepicturewidget));
      expect(find.byKey(Key('dialogaddticketimage')), findsOneWidget);
      expect(find.byKey(Key('addticketcancelbutton')), findsOneWidget);
      await tester.tap(find.byKey(Key('addticketcancelbutton')));
      await tester.pumpWidget(makeTicketTestableTakePicture(child: takepicturewidget));
      expect(find.byKey(Key('dialogaddticketimage')), findsNothing);
    });
  });
}