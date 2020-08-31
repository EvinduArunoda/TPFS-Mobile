import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/fine.dart';
import 'package:tpfs_policeman/models/validate.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/validateTicket.dart';
import 'package:tpfs_policeman/views/tickets/createTicket.dart';
import 'package:tpfs_policeman/views/tickets/fineTicket.dart';

class MockCreateTicket extends Mock implements CreateTicketNew{

  Future<Map<String,String>> fillTicketForm() async{
    var now = new DateTime(2020,05,20,16,30);
    var formatter = new DateFormat('yyyy-MM-dd');
    String date = formatter.format(now);
    String time = DateFormat.jm().format(now);
    Map<String,String> dateAndTime = {
      'date': date,
      'time' :time
      };
    return dateAndTime;
  }

  Future<List<Fine>> getSuitableFine(String type) async{
    final instance = MockFirestoreInstance();
    await instance.collection('Fine').add({
      'type': 'Common',
      'amount': '45000',
      'description': 'Speed above 20% standard',
    });
    await instance.collection('Fine').add({
      'type': 'Car',
      'amount': '3000',
      'description': 'Driving without license',
    });
    List<DocumentSnapshot> fineDetail=[];
    List<DocumentSnapshot>commonFine = (await instance
        .collection("Fine")
        .where("type", isEqualTo: 'Common')
        .getDocuments())
        .documents;
    List<DocumentSnapshot>typeFine = (await instance
      .collection("Fine")
      .where("type", isEqualTo: type)
      .getDocuments())
      .documents;
    fineDetail = new List.from(commonFine)..addAll(typeFine);
    return fineDetail.map(_fineFromDocument).toList();
  }
  Fine _fineFromDocument(DocumentSnapshot document){
    return Fine(
      fineType: document.data['type'],
      fineDescription: document.data['description'],
      fineAmount: int.parse(document.data['amount'])/1.0
    );
  }
  Future<List<String>> findAllFines() async{
    final instance = MockFirestoreInstance();
    await instance.collection('Fine').add({
      'type': 'Common',
      'amount': '45000',
      'description': 'Speed above 20% standard',
    });
    await instance.collection('Fine').add({
      'type': 'Car',
      'amount': '3000',
      'description': 'Driving without license',
    });
    List<DocumentSnapshot>fineDetails = (await instance
        .collection("Fine")
        .getDocuments())
        .documents;
    return fineDetails.map(_offencesFromDocument).toList();
  }
  String _offencesFromDocument(DocumentSnapshot document){
    return document.data['description'];
  }

  List<Ticket> filterOffences(List<Ticket> tickets,List<String>offences){
    List<Ticket>filteredTickets =[];
    for (var i = 0; i < tickets.length; i++) {
      if(offences.any((item) => tickets[i].offences.contains(item))){
        filteredTickets.add(tickets[i]);
      }      
    }
    return filteredTickets;
    }
}

class MockValidateTicket extends Mock implements ValidateTicket{
  String filepath;
  String licenseplate;

  MockValidateTicket({this.filepath , this.licenseplate});

  Stream <Validate> get ticketValidation {
    final instance = MockFirestoreInstance();
    try{
      return instance.collection('TicketValidate').document(filepath).snapshots()
    .map( _validateModelFromSnapshot);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  Validate _validateModelFromSnapshot(DocumentSnapshot snapshot){
      return snapshot.data != null ? Validate(
        docid : snapshot.data['id'] ?? '',
        licensePlateValidation: snapshot.data['LicensePlateImage'] ?? {}
      ) : null;
    // }).toList();
  }
}

void main()async{
  group('Creating Digital Ticket Form Variables', (){
    test('DateTime in correct format', () async{
      MockCreateTicket ticket = MockCreateTicket();
      final datetime = await ticket.fillTicketForm();
      expect(datetime['date'],'2020-05-20');
      expect(datetime['time'],'4:30 PM');
    });
    test('Type of vehicle has seperate fine', () async {
      MockCreateTicket ticket = MockCreateTicket();
      final fines = await ticket.getSuitableFine('Car');
      expect(fines.length, equals(2));
      expect(fines[0].fineAmount, 45000.0);
      expect(fines[0].fineType, 'Common');
      expect(fines[1].fineType, 'Car');
      expect(fines[1].fineDescription, 'Driving without license');
    });
    
    test('Type of vehicle has no seperate fine', () async {
      MockCreateTicket ticket = MockCreateTicket();
      final fines = await ticket.getSuitableFine('Bus');
      print(fines[0].fineAmount);
      expect(fines.length, equals(1));
      expect(fines[0].fineAmount, 45000.0);
      expect(fines[0].fineType, 'Common');
    });

    test('Result Fines to add to filterlist', () async {
      MockCreateTicket ticket = MockCreateTicket();
      final fines = await ticket.findAllFines();
      expect(fines.length, equals(2));
    });

    test('filter offences of existing type', () async {
      List<Ticket> tickets = [Ticket(offences: ['Speed above 20% standard','Driving without license'],licenseNumber: 'B1234567',licensePlate: 'KI 1234'),
                              Ticket(offences: ['Driving without license'],licenseNumber: 'B7654321',licensePlate: 'KI 8407')  ];
      List<String>offences = ['Speed above 20% standard'];
      MockCreateTicket ticket = MockCreateTicket();
      List<Ticket> filteredtickets = ticket.filterOffences(tickets, offences);
      expect(filteredtickets.length, equals(1));
      expect(filteredtickets[0].offences, contains('Speed above 20% standard'));
    });

    test('filter offences of non - existing type', () async {
      List<Ticket> tickets = [Ticket(offences: ['Speed above 20% standard','Driving without license'],licenseNumber: 'B1234567',licensePlate: 'KI 1234'),
                              Ticket(offences: ['Speed above 20% standard'],licenseNumber: 'B7654321',licensePlate: 'KI 8407')  ];
      List<String>offences = ['No helmet on'];
      MockCreateTicket ticket = MockCreateTicket();
      List<Ticket> filteredtickets = ticket.filterOffences(tickets, offences);
      expect(filteredtickets.length, equals(0));
    });

    test('Validating Ticket Stream with no data', () async {
      MockValidateTicket validateticket = MockValidateTicket();
      final streamresult = validateticket.ticketValidation;
      expect(await streamresult.single, isNull);
    });

    test('Validating Ticket Stream with data', () async {
      final instance = MockFirestoreInstance();

      Stream<DocumentSnapshot> getData (){
        try{
          return instance.collection('TicketValidate').document('Bqwer1234').snapshots();
        }catch(e){
          print(e.toString());
          return null;
        }
      }
      final streamresult = getData();
      final streamdocument = await streamresult.single;
      expect(streamdocument['LicenseNumber'],isNull);
      
      await instance.collection('TicketValidate').document('Bqwer1234').setData({
        'LicenseNumber' : 'B1234567'
      });
      final streamresultlatest = getData();
      final streamdocumentlatest = await streamresultlatest.single;
      expect(streamdocumentlatest['LicenseNumber'],isNotNull);
    });

  });

  group('Ticket Forms Fields needed for creating Tickets - Validation', (){
    test('empty otp number returns error string', () {
      final result = OTPNumberValidator.validate('');
      expect(result, 'Enter a code');
    });

    test('non-empty otp with digits less than 6 returns error string', () {
      final result = OTPNumberValidator.validate('0787');
      expect(result, 'Enter a valid code');
    });

    test('non-empty otp with digits more than 6 returns error string', () {
      final result = OTPNumberValidator.validate('076543256');
      expect(result, 'Enter a valid code');
    });

    test('non-empty otp with 6 digits returns null', () {
      final result = OTPNumberValidator.validate('176543');
      expect(result, null);
    });

    test('empty License Plate returns error string', () {
    final result = LicensePlateFieldValidator.validate('');
    expect(result, 'Enter valid license plate number');
    });

    test('non-empty License Plate returns null', () {
    final result = LicensePlateFieldValidator.validate('License Plate');
    expect(result, null);
    });

    test('empty phone number returns error string', () {
      final result = PhoneNumberValidator.validate('');
      expect(result, 'Enter a valid phone number');
    });

    test('non-empty phone with digits less than 10 returns error string', () {
      final result = PhoneNumberValidator.validate('0781234');
      expect(result, 'Enter a valid phone number');
    });

    test('non-empty phone with digits more than 10 returns error string', () {
      final result = PhoneNumberValidator.validate('076543213456');
      expect(result, 'Enter a valid phone number');
    });

    test('non-empty phone with 10 digits starting with 07 returns null', () {
      final result = PhoneNumberValidator.validate('0765431234');
      expect(result, null);
    });

    test('non-empty phone with digits does not start with 07 returns error string', () {
      final result = PhoneNumberValidator.validate('046543213456');
      expect(result, 'Enter a valid phone number');
    });

    test('empty license number returns error string', () {
      final result = LicenseNumberValidator.validate('');
      expect(result, 'Enter valid driving license number');
    });

    test('non-empty license number with characters less than 8 returns error string', () {
      final result = LicenseNumberValidator.validate('B781234');
      expect(result, 'Enter valid driving license number');
    });

    test('non-empty license number with characters more than 8 returns error string', () {
      final result = LicenseNumberValidator.validate('B76543213456');
      expect(result, 'Enter valid driving license number');
    });

    test('non-empty license number with 8 characters starting with B with rest of characters are numbers returns null', () {
      final result = LicenseNumberValidator.validate('B1234567');
      expect(result, null);
    });

    test('non-empty license number with 8 characters not starting with B returns error string', () {
      final result = LicenseNumberValidator.validate('12345678');
      expect(result, 'Enter valid driving license number');
    });

    test('non-empty license number with 8 characters starting with B but rest of characters arent numbers returns error string', () {
      final result = LicenseNumberValidator.validate('B12jhsgV');
      expect(result, 'Enter valid driving license number');
    });

  });
  
}