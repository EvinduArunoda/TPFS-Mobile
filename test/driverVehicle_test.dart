import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/driver.dart';
import 'package:tpfs_policeman/services/db_driver.dart';

class MockDriver extends Mock implements DriverCollection{
  Future <List<Driver>> searchLicensePlate(String licensePlateNum) async{
    final instance = MockFirestoreInstance();
    await instance.collection('Drivers').add({
      'LicenseNumber': 'B1234567',
      'name': 'Koothrapali Rajesh',
      'NICnumber': '199712345678',
    });
    List<DocumentSnapshot> driverDetails;
    List<Driver> drivers;
    driverDetails = (await instance
        .collection("Drivers")
        .where("LicenseNumber", isEqualTo: licensePlateNum)
        .getDocuments())
        .documents;
    return drivers = driverDetails.map(_driverFromDocument).toList();
  }
  Driver _driverFromDocument(DocumentSnapshot document){
      return Driver(
        licenseNumber: document.data['LicenseNumber'] ?? '',
        name: document.data['name'] ?? '',
        phoneNumber: document.data['Phone Number'] ?? 0000000000,
        physicalDisabilities: document.data['physical disabilities'] ?? [],
        address: document.data['address'] ?? '',
        emailAddress: document.data['email address'] ?? '',
        nicnumber: document.data['NICNumber'] ?? ''  
      );
  }
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
      'Status': 'open',
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
}}

void main(){
  group('Handling Driver and Vehicle user data', (){
    test('Search licenseplate stored in firestore', () async{
      MockDriver driverinterface = MockDriver();
      final driver = await driverinterface.searchLicensePlate('B1234567');
      expect(driver.length, equals(1));
      expect(driver[0].licenseNumber, 'B1234567');
    });

    test('Search licenseplate not stored in firestore', () async{
      MockDriver driverinterface = MockDriver();
      final driver = await driverinterface.searchLicensePlate('B1234576');
      expect(driver.length, equals(0));
    });

    test('Tickets present during search with correct status', () async {
      MockDriver driverinterface = MockDriver();
      final tickets = await driverinterface.outstandingticketsDetails("B1234567");
       expect(tickets.length, equals(1));
    });

    test('Tickets not present during search with incorrect status', () async {
      MockDriver driverinterface = MockDriver();
      final tickets = await driverinterface.paidticketsDetails("B1234567");
       expect(tickets.length, equals(0));
    });

    test('Fields not present in firestore document', () async {
      MockDriver driverinterface = MockDriver();
      final driver = await driverinterface.searchLicensePlate('B1234567');
      final tickets = await driverinterface.outstandingticketsDetails("B1234567");
       expect(driver[0].address, '');
       expect(driver[0].physicalDisabilities, []);
       expect(driver[0].phoneNumber, 0000000000);
       expect(tickets[0].areaCoordinates, '');
       expect(tickets[0].fineAmount, 0.0);
    });

  });
}