
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tpfs_policeman/models/criminal.dart';
import 'package:tpfs_policeman/models/offences.dart';
import 'package:tpfs_policeman/services/createTicket.dart';

class CriminalAssessment{

Future <List<Criminal>> getCriminalDetails(String criminalID) async{
    List<DocumentSnapshot> criminalDetails;
    criminalDetails = (await Firestore.instance
        .collection("Criminals").where("nicNumber", isEqualTo: criminalID)
        .getDocuments())
        .documents;
    return criminalDetails.map(_criminalFromDocument).toList();
  }

  Criminal _criminalFromDocument(DocumentSnapshot document){
      return Criminal(
        name: document.data['name'] ?? '',
        nicNumber: document.data['nicNumber'] ?? '',
        phoneNumber: document.data['phoneNumber'] ?? '',
        address: document.data['address'] ?? '',
        offencesReference: document.data['offences'] ?? ''
      );
  }

  Future<List<CriminalOffences>> getOffencesOfCriminals(List<dynamic>offencessnapshot)async{
    List<CriminalOffences> offences = [];
    for (var i = 0; i < offencessnapshot.length; i++) {
      CriminalOffences offenceitem = await _offenceFromReference(offencessnapshot[i]);
      offences.add(offenceitem);
    }
    return offences;
  }

  Future<CriminalOffences> _offenceFromReference(dynamic offenceReference) async{
    DocumentSnapshot offencesnapshot = await offenceReference.get();
    return CriminalOffences(
      date: offencesnapshot.data['date'] ?? '',
      offence: offencesnapshot.data['offence'] ?? '',
      place: offencesnapshot.data['place'] ?? ''
    );
  }

  Future<void>updateMatchAndDetails(String id,String message) async{
    String location = await CreateTicketNew().getLocationData();
    await Firestore.instance.collection('CriminalAssessment').document(id).setData({
      'location':location,
      'MatchResults': message,
      'time': FieldValue.serverTimestamp()
    },merge: true);
  }

}