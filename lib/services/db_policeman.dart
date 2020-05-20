import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tpfs_policeman/models/user.dart';

class DatabaseServicePolicemen{

  final String uid;

  DatabaseServicePolicemen({this.uid});

  final CollectionReference policemenCollection = Firestore.instance.collection('PoliceMen');
  final CollectionReference policemenActivityCollection = Firestore.instance.collection('PoliceMenActivity');

  Future updateUserData({num phoneNumber , String address , String email }) async {
    return await policemenCollection.document(uid).updateData({
      'phone_number' : phoneNumber,
      'address' : address,
      'mail_id': email,
    });
  }

  Stream <UserData> get userData {
    return policemenCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }
  
  Stream <UserLog> get userLog {
    return policemenActivityCollection.document(uid).snapshots()
    .map(_userLogFromSnapshot);
  }

  // Future<UserLog> testUserLog(){
  //   return policemenCollection.document(uid).get().then((res) => {})
  //   // DocumentSnapshot snap = await policemenCollection.document(uid).get();
  //   // DocumentSnapshot test = await snap.data['ActivityLog'].get();
  //   // num procedure = test.data['Procedures'];
  //   // print(procedure); 

  // }

  UserLog _userLogFromSnapshot (DocumentSnapshot snapshot){
    return UserLog(
      userid: uid,
      numOfProcedures: snapshot.data['Procedures'] ?? 0,
      numbOfTicSuccess: snapshot.data['SuccessTickets'] ?? 0,
      numbOfTicRep: snapshot.data['ReportedTickets'] ?? 0,
      numofVehProfViewed: snapshot.data['VehicleProfileViewed'] ?? 0,
      numofDriProfViewed: snapshot.data['DriverProfileViewed'] ?? 0
    );

  }

  UserData _userDataFromSnapshot (DocumentSnapshot snapshot) {
    return UserData(
      userid: uid,
      firstName: snapshot.data['first_name'] ?? '',
      lastName: snapshot.data['last_name'] ?? '',
      phoneNumber: snapshot.data['phone_number'] ?? 0,
      address: snapshot.data['address'] ?? '',
      employeeID: snapshot.data['employee_id'] ?? '',
      mailID: snapshot.data['mail_id'] ?? '' ,
      nicnumber: snapshot.data['NICNumber'] ?? '',
      userLog: snapshot.data['ActivityLog'] 
    );
  }

  Future updateNumOfProcedures ()async{
    await policemenActivityCollection.document(uid).updateData({
       'Procedures' : FieldValue.increment(1)
     });
   }

  Future updateNumOfVehicleProfiles () async{
    await policemenActivityCollection.document(uid).updateData({
      'VehicleProfileViewed' : FieldValue.increment(1)
    });
   }

  Future updateNumOfDriverProfiles () async{
    await policemenActivityCollection.document(uid).updateData({
      'DriverProfileViewed' : FieldValue.increment(1)
    });
   }

}