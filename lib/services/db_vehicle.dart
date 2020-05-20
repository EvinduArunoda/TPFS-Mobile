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
        insuranceNumber: document.data['Insurance Number'] ?? '',
        makeAndModel: document.data['Make and model'] ?? '',
        regOwner: document.data['Registered Owner'] ?? '',
        regownerNumber: document.data['Register Number'] ?? '',
        conditionAndClass: document.data['Vehicle Conditon and classs'] ?? '',
        regNICNumber: document.data['OwnerNICNumber'] ?? ''  
      );
  }

  //   Future<List<Ticket>> ticketOfVehicle(String licensePlateNumber) async{
  //   List<DocumentSnapshot> ticketDetails;
  //   List<Ticket> tickets;
  //   ticketDetails = (await Firestore.instance
  //       .collection("Ticket")
  //       .where("LicensePlate", isEqualTo: licensePlateNumber)
  //       .getDocuments())
  //       .documents;
  //   if(ticketDetails.isEmpty){
  //     return null;
  //   }
  //   else{
  //     return tickets = ticketDetails.map(_ticketFromDocument).toList();
  //   }
  // }

  Ticket _ticketFromDocument(DocumentSnapshot document){
    return Ticket(
      licenseNumber: document.data['LicenseNumber'] ?? '',
      licensePlate: document.data['LicensePlate'] ?? '',
      areaCoordinates: document.data['Area'] ?? '',
      date: document.data['Date'] ?? '',
      timestamp: document.data['Time'] ?? '',
      vehicle: document.data['Vehicle'] ?? '',
      fineAmount: document.data['FineAmount'] ?? 0,
      status: document.data['Status'] ?? '',
      offences: document.data['Offences'] ?? '' 
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

//   Future<List<Ticket>> _ticketsDetails(String licensePlate) async{
//   List<DocumentSnapshot> outstandingtTicketDetails;
//   List<Ticket> outstandingTickets;
//   outstandingtTicketDetails = (await Firestore.instance
//       .collection("Ticket")
//       .where("LicensePlate", isEqualTo: licensePlate)
//       .where('status', isEqualTo: 'pending')
//       .getDocuments())
//       .documents;
//   return outstandingTickets = outstandingtTicketDetails.map(_ticketFromDocument).toList();    
// }

}
