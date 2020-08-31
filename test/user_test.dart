import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tpfs_policeman/models/procedure.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:tpfs_policeman/views/profiles/profile.dart';

class MockPoliceMan extends Mock implements DatabaseServicePolicemen{
   final String uid;

  MockPoliceMan({this.uid});

  final instance = MockFirestoreInstance();
  // final CollectionReference policemenCollection = instance.collection('PoliceMen');
  // final CollectionReference policemenActivityCollection = Firestore.instance.collection('PoliceMenActivity');

  Future updateUserData({String phoneNumber , String address , String email }) async {
    await instance.collection('PoliceMen').document(uid).setData({
      'phone_number': 0771234567,
      'address': 'No.39,Perera Lane',
      'mail_id': 'abc@gmail.com',
    });
    await instance.collection('PoliceMen').document(uid).updateData({
      'phone_number' : phoneNumber,
      'address' : address,
      'mail_id': email,
    });
    return await instance.collection('PoliceMen').document(uid).get();
  }
  Future updateProcedureCreated(ProcedurePolice procedure)async{
    DocumentReference id = procedure.documentID;
    if(procedure.ticket == null){
      procedure.ticket = 'No Ticket procedure started';
    }
    await id.updateData({
      'VehicleProfileSearched' : procedure.vehicleProfileSearched,
      'DriverProfileSearched' : procedure.driverProfileSearched,
      'CriminalAssessmentImages' : procedure.criminalAssessment,
      'TicketCreationStatus' : procedure.ticket,
    });
  }
}

void main(){
  group('Policemen model use cases and handling data', (){
    test('Update Data to policemen model to invalid uid', () async {
      MockPoliceMan policemen = MockPoliceMan();
      final result = await policemen.updateUserData(phoneNumber: '0781234560', email: 'wer@yahoo.com', address: 'No.76,Moor Road');
      expect(result['phone_number'],isNull);
    });

    test('Update Data to policemen model to uid', () async {
      MockPoliceMan policemen = MockPoliceMan(uid: 'qwerty');
      final result = await policemen.updateUserData(phoneNumber: '0781234560', email: 'wer@yahoo.com', address: 'No.76,Moor Road');
      expect(result['phone_number'] , isNotNull);
      expect(result['phone_number'] , '0781234560');
    });

    test('Creating procedures adding data to firestore', () async {
      ProcedurePolice procedure = ProcedurePolice(employeeID: 'B1230987');
      final instance = MockFirestoreInstance();
      DocumentReference documentID = instance.collection('PoliceMenActivity').document();
      await documentID.setData({
        'ProcedureStarted' : FieldValue.serverTimestamp(),
        'Policemen_ID' : procedure.employeeID
      });
      final policeid = (await instance.collection('PoliceMenActivity').document(documentID.documentID).get()).data['Policemen_ID'];
      expect(documentID.documentID,isNotNull);
      expect(policeid, 'B1230987');
    });

    test('Creating procedures adding data to firestore with null values', () async {
      ProcedurePolice procedure = ProcedurePolice();
      final instance = MockFirestoreInstance();
      DocumentReference documentID = instance.collection('PoliceMenActivity').document();
      await documentID.setData({
        'ProcedureStarted' : FieldValue.serverTimestamp(),
        'Policemen_ID' : procedure.employeeID
      });
      final policeid = (await instance.collection('PoliceMenActivity').document(documentID.documentID).get()).data['Policemen_ID'];
      expect(documentID.documentID,isNotNull);
      expect(policeid, isNull);
  
    });

    test('Updating Procedure with no ticket created', () async {
      ProcedurePolice procedure = ProcedurePolice(employeeID: 'B1230984', vehicleProfileSearched: 'Ki-1234',driverProfileSearched: 'B1230985',
                                                      criminalAssessment: ['bfdhobfpwebfpb']);
      final instance = MockFirestoreInstance();
      DocumentReference documentID = instance.collection('PoliceMenActivity').document();
      await documentID.setData({
        'ProcedureStarted' : FieldValue.serverTimestamp(),
        'Policemen_ID' : procedure.employeeID
      });
      procedure.documentID = documentID;
      MockPoliceMan policemen = MockPoliceMan();
      await policemen.updateProcedureCreated(procedure);
      final document = (await instance.collection('PoliceMenActivity').document(documentID.documentID).get());
      final ticketstatus = document.data['TicketCreationStatus'];
      final employeeid = document.data['Policemen_ID'];

      expect(ticketstatus, "No Ticket procedure started");
      expect(employeeid, 'B1230984');

    });

    test('Updating Procedure with ticket created', () async {
      ProcedurePolice procedure = ProcedurePolice(employeeID: 'B1230984', vehicleProfileSearched: 'Ki-1234',driverProfileSearched: 'B1230985',
                                                      criminalAssessment: ['bfdhobfpwebfpb'],ticket: 'ticket has been reported');
      final instance = MockFirestoreInstance();
      DocumentReference documentID = instance.collection('PoliceMenActivity').document();
      await documentID.setData({
        'ProcedureStarted' : FieldValue.serverTimestamp(),
        'Policemen_ID' : procedure.employeeID
      });
      procedure.documentID = documentID;
      MockPoliceMan policemen = MockPoliceMan();
      await policemen.updateProcedureCreated(procedure);
      final document = (await instance.collection('PoliceMenActivity').document(documentID.documentID).get());
      final ticketstatus = document.data['TicketCreationStatus'];
      final employeeid = document.data['Policemen_ID'];

      expect(ticketstatus, "ticket has been reported");
      expect(employeeid, 'B1230984');

    });
  });

  group('User Profile Field Validators', (){
    test('empty address returns error string', () {
    final result = AddressFieldValidator.validate('');
    expect(result, 'Enter address');
    });

    test('non-empty address returns null', () {
    final result = AddressFieldValidator.validate('address');
    expect(result, null);
    });

    test('empty email returns error string', () {
      final result = EmailAddressFieldValidator.validate('');
      expect(result, 'Enter email address');
    });

    test('non-empty email returns null', () {
      final result = EmailAddressFieldValidator.validate('email');
      expect(result, null);
    });

    test('empty phone number returns error string', () {
      final result = PhoneNumberFieldValidator.validate('');
      expect(result, 'Enter valid phone number');
    });

    test('non-empty phone with digits less than 10 returns error string', () {
      final result = PhoneNumberFieldValidator.validate('0781234');
      expect(result, 'Enter valid phone number');
    });

    test('non-empty phone with digits more than 10 returns error string', () {
      final result = PhoneNumberFieldValidator.validate('076543213456');
      expect(result, 'Enter valid phone number');
    });

    test('non-empty phone with 10 digits returns null', () {
      final result = PhoneNumberFieldValidator.validate('0765431234');
      expect(result, null);
    });
  });
}