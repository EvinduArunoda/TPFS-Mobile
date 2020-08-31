import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:tpfs_policeman/models/notification.dart';
import 'package:tpfs_policeman/models/procedure.dart';
import 'package:tpfs_policeman/models/user.dart';

class DatabaseServicePolicemen{

  final String uid;

  DatabaseServicePolicemen({this.uid});

  final CollectionReference policemenCollection = Firestore.instance.collection('PoliceMen');
  final CollectionReference policemenActivityCollection = Firestore.instance.collection('PoliceMenActivity');

  Future updateUserData({String phoneNumber , String address , String email }) async {
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
  
//  Stream <UserLog> get userLog {
//    return policemenActivityCollection.document(uid).snapshots()
//    .map(_userLogFromSnapshot);
//  }

  Stream <List<NotificationPresent>> get notificationPresent {
    return Firestore.instance.collection('Notification').snapshots().map(_notificationFromSnapshots);
  }

  List<NotificationPresent> _notificationFromSnapshots(QuerySnapshot snap){
    return snap.documents.map((doc){
      return NotificationPresent(
        title: doc.data['title'] ?? '',
        description: doc.data['description'] ?? '',
//        time:doc.data['timestamp']
      );
    }).toList();
  }
  // Future<UserLog> testUserLog(){
  //   return policemenCollection.document(uid).get().then((res) => {})
  //   // DocumentSnapshot snap = await policemenCollection.document(uid).get();
  //   // DocumentSnapshot test = await snap.data['ActivityLog'].get();
  //   // num procedure = test.data['Procedures'];
  //   // print(procedure); 

  // }

//  UserLog _userLogFromSnapshot (DocumentSnapshot snapshot){
//    return UserLog(
//      userid: uid,
//      numOfProcedures: snapshot.data['Procedures'] ?? 0,
//      numbOfTicSuccess: snapshot.data['SuccessTickets'] ?? 0,
//      numbOfTicRep: snapshot.data['ReportedTickets'] ?? 0,
//      numofVehProfViewed: snapshot.data['VehicleProfileViewed'] ?? 0,
//      numofDriProfViewed: snapshot.data['DriverProfileViewed'] ?? 0
//    );
//
//  }

  UserData _userDataFromSnapshot (DocumentSnapshot snapshot) {
    return UserData(
      userid: uid,
      firstName: snapshot.data['first_name'] ?? '',
      lastName: snapshot.data['last_name'] ?? '',
      phoneNumber: snapshot.data['phone_number'] ?? '',
      address: snapshot.data['address'] ?? '',
      employeeID: snapshot.data['employee_id'] ?? '',
      mailID: snapshot.data['mail_id'] ?? '' ,
      nicnumber: snapshot.data['NICNumber'] ?? '',
      stationID: snapshot.data['station_id'] ?? ''
    );
  }

  Future updateProcedureCreated(ProcedurePolice procedure)async{
    DocumentReference id = procedure.documentID;
    if(procedure.ticket == null){
      procedure.ticket = 'No Ticket procedure started';
    }
    return await id.updateData({
      'VehicleProfileSearched' : procedure.vehicleProfileSearched,
      'DriverProfileSearched' : procedure.driverProfileSearched,
      'CriminalAssessmentImages' : procedure.criminalAssessment,
      'ProcedureEnded' : procedure.endTime,
      'TicketCreationStatus' : procedure.ticket,
      'TicketReference' : procedure.ticketCreated,
      'licensePlateValidation' : procedure.plateValidate
    });
  }

  Future<DocumentReference> createProcedure(ProcedurePolice procedure)async{
    DocumentReference documentID = policemenActivityCollection.document();
    await documentID.setData({
      'ProcedureStarted' : procedure.startTime,
      'Policemen_ID' : procedure.employeeID
    });
    return documentID;
  }

//  void updateLocation(){
//    var geolocator = Geolocator();
//    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
//
//    StreamSubscription<Position> positionStream = geolocator.getPositionStream(locationOptions).listen(
//        (Position position) async{
//          if(position != null){
//            await policemenCollection.document(uid).updateData({
//              'location' : GeoPoint(position.latitude,position.longitude)
//            });
//      }
//      //      print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
//    });
//  }

}