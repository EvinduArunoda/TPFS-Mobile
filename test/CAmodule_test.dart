import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tpfs_policeman/models/offences.dart';
import 'package:tpfs_policeman/services/criminalAssessment.dart';

class MockCriminalAssessment extends Mock implements CriminalAssessment{

  Future<List<CriminalOffences>> getOffencesOfCriminals(List<dynamic>offencessnapshot)async{
    List<CriminalOffences> offences = [];
    if(offencessnapshot != null){
      for (var i = 0; i < offencessnapshot.length; i++) {
      CriminalOffences offenceitem = await _offenceFromReference(offencessnapshot[i]);
      offences.add(offenceitem);
      }
    }
    return offences;
  }

  Future<CriminalOffences> _offenceFromReference(dynamic offenceReference) async{
    DocumentSnapshot offencesnapshot = await offenceReference.get();
    if(offencesnapshot.data == null){
      return null;
    }
    return CriminalOffences(
      date: offencesnapshot.data['date'] ?? '',
      offence: offencesnapshot.data['offence'] ?? '',
      place: offencesnapshot.data['place'] ?? ''
    );
  }
}

void main(){
  group("Criminal Assessment Module data handling", (){
    test('Set criminal details to firestore document with merge true', () async {
      final instance = MockFirestoreInstance();
      await instance.collection('CriminalAssessment').document('B12332gkg').setData({
        'image' : 'CriminalAssessment/oepQFl1ByeM4MpR4dteACrcZYEx1:2020-05-18 22:14:23.699751',
        'coorelation' : 72.123334
      });
      final message = 'Matched';
      String location = 'No.23,Silwa Mawatha,Colombo';
      await instance.collection('CriminalAssessment').document('B12332gkg').setData({
        'location':location,
        'MatchResults': message,
        'time': FieldValue.serverTimestamp()
      },merge: true);
      final documentsnapshot = await instance.collection('CriminalAssessment').document('B12332gkg').get();
      expect(documentsnapshot.data['image'],'CriminalAssessment/oepQFl1ByeM4MpR4dteACrcZYEx1:2020-05-18 22:14:23.699751');
      expect(documentsnapshot.data['location'],'No.23,Silwa Mawatha,Colombo');
    });

    test('Offences of criminal being non empty ', () async {
      final instance = MockFirestoreInstance();
      DocumentReference documentID = instance.collection('Offences').document();
      await instance.collection('Offences').document(documentID.documentID).setData({
        'date': '12-12-2012',
        'offence': 'Embexxeling 10 Million Rupees',
        'place': 'Hambantota',
      });
      MockCriminalAssessment ca = MockCriminalAssessment();
      final criminaloffences = await ca.getOffencesOfCriminals([documentID]);
      expect(criminaloffences.length,equals(1));
      expect(criminaloffences[0].offence,'Embexxeling 10 Million Rupees');
    });

    test('Offences of criminal being empty ', () async {
      final instance = MockFirestoreInstance();
      DocumentReference documentID = instance.collection('Offences').document();
      MockCriminalAssessment ca = MockCriminalAssessment();
      final criminaloffences = await ca.getOffencesOfCriminals([documentID]);
      expect(criminaloffences.last,isNull);
    });
  });
}