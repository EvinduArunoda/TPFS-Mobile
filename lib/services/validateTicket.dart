import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tpfs_policeman/models/validate.dart';

class ValidateTicket{
  String filepath;
  String licenseplate;

  ValidateTicket({this.filepath , this.licenseplate});

  Stream <Validate> get ticketValidation {
    try{
      print('filepathget $filepath');
      return Firestore.instance.collection('TicketValidate').document(filepath).snapshots()
    .map( _validateModelFromSnapshot);
    }catch(e){
      print(e.toString());
      return null;
    }

  }

  Validate _validateModelFromSnapshot(DocumentSnapshot snapshot){
      return snapshot.data != null ? Validate(
        docid : snapshot.data['id'] ?? '',
        licensePlateValidation: snapshot.data['LicensePlateImageResult'] ?? {}
      ) : null;
    // }).toList();
  }
  
}