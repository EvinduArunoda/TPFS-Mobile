import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/vehicle.dart';

class VehicleCollection{


  Future <List<Vehicle>> searchLicensePlate(String licensePlateNum) async{
    List<DocumentSnapshot> vehicleDetails;
    List<Vehicle> vehicles;
    vehicleDetails = (await Firestore.instance
        .collection("vehicle")
        .where("LicensePlate", isEqualTo: licensePlateNum)
        .getDocuments())
        .documents;
    return vehicles =vehicleDetails.map(_vehicleFromDocument).toList();
  }

  Vehicle _vehicleFromDocument(DocumentSnapshot document){
      return Vehicle(
        licensePlate: document.data['LicensePlate'] ?? '',
        insuranceNumber: document.data['insuranceNumber'] ?? '',
        makeAndModel: document.data['makeAndModel'] ?? '',
        regOwner: document.data['registeredOwner'] ?? '',
        regownerNumber: document.data['registeredNumber'] ?? '',
        conditionAndClass: document.data['vehicleConditionAndClasses'] ?? [],
        regNICNumber: document.data['ownerID'] ?? ''
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

   Future<List<Ticket>> outstandingticketsDetails(String licensePlate) async{
    List<DocumentSnapshot> outstandingtTicketDetails;
    List<Ticket> outstandingTickets;
    outstandingtTicketDetails = (await Firestore.instance
        .collection("Ticket")
        .where("LicensePlate", isEqualTo: licensePlate)
        .where('Status', isEqualTo: 'open').orderBy('Time',descending: true)
        .getDocuments())
        .documents;
    return outstandingTickets = outstandingtTicketDetails.map(_ticketFromDocument).toList();    
  }

  Future<List<Ticket>> paidticketsDetails(String licensePlate) async{
    List<DocumentSnapshot> outstandingtTicketDetails;
    List<Ticket> outstandingTickets;
    outstandingtTicketDetails = (await Firestore.instance
        .collection("Ticket")
        .where("LicensePlate", isEqualTo: licensePlate)
        .where('Status', isEqualTo: 'closed')
        .getDocuments())
        .documents;
  return outstandingTickets = outstandingtTicketDetails.map(_ticketFromDocument).toList();    
}

  Future<List<Ticket>> reportedticketsDetails(String licensePlate) async{
    List<DocumentSnapshot> outstandingtTicketDetails;
    List<Ticket> outstandingTickets;
    outstandingtTicketDetails = (await Firestore.instance
        .collection("Ticket")
        .where("LicensePlate", isEqualTo: licensePlate)
        .where('Status', isEqualTo: 'reported')
        .getDocuments())
        .documents;
  return outstandingTickets = outstandingtTicketDetails.map(_ticketFromDocument).toList();    
}

}
