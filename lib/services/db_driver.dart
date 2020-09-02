import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/driver.dart';
import 'package:tpfs_policeman/views/tickets/ticketDetails.dart';

class DriverCollection{


  Future <List<Driver>> searchLicensePlate(String licensePlateNum) async{
    List<DocumentSnapshot> driverDetails;
    List<Driver> drivers;
    driverDetails = (await Firestore.instance
        .collection("Drivers")
        .where("LicenseNumber", isEqualTo: licensePlateNum)
        .getDocuments())
        .documents;
    print(driverDetails);
    return drivers = driverDetails.map(_driverFromDocument).toList();
  }

  Driver _driverFromDocument(DocumentSnapshot document){
      return Driver(
        licenseNumber: document.data['LicenseNumber'] ?? '',
        name: document.data['name'] ?? '',
        phoneNumber: int.parse(document.data['phonenumber']) ?? 0000000000,
        physicalDisabilities: document.data['physicaldisabilities'] ?? [],
        address: document.data['address'] ?? '',
        emailAddress: document.data['emailaddress'] ?? '',
        nicnumber: document.data['NIC'] ?? ''
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
      fineAmount: document.data['FineAmount'] + .0 ?? 0.0,
      status: document.data['Status'] ?? '', 
      offences: document.data['Offences'] ?? []
    );
  }


  Future<List<Ticket>> outstandingticketsDetails(String licenseNumber) async{
    List<DocumentSnapshot> outstandingtTicketDetails;
    List<Ticket> outstandingTickets;
    outstandingtTicketDetails = (await Firestore.instance
        .collection("Ticket")
        .where("LicenseNumber", isEqualTo: licenseNumber)
        .where('Status', isEqualTo: 'open').orderBy('Time',descending: true)
        .getDocuments())
        .documents;
    return outstandingTickets = outstandingtTicketDetails.map(_ticketFromDocument).toList();    
  }

  Future<List<Ticket>> paidticketsDetails(String licenseNumber) async{
    List<DocumentSnapshot> outstandingtTicketDetails;
    List<Ticket> outstandingTickets;
    outstandingtTicketDetails = (await Firestore.instance
        .collection("Ticket")
        .where("LicenseNumber", isEqualTo: licenseNumber)
        .where('Status', isEqualTo: 'closed')
        .getDocuments())
        .documents;
  return outstandingTickets = outstandingtTicketDetails.map(_ticketFromDocument).toList();    
}

Future<List<Ticket>> reportedticketsDetails(String licenseNumber) async{
    List<DocumentSnapshot> outstandingtTicketDetails;
    List<Ticket> outstandingTickets;
    outstandingtTicketDetails = (await Firestore.instance
        .collection("Ticket")
        .where("LicenseNumber", isEqualTo: licenseNumber)
        .where('Status', isEqualTo: 'reported').orderBy('Time',descending: true)
        .getDocuments())
        .documents;
    return outstandingTickets = outstandingtTicketDetails.map(_ticketFromDocument).toList();    
  }

}