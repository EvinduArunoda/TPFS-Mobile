//Procedure modal class used to store data of each procedure carried out bu policemen when creating ticket

import 'package:cloud_firestore/cloud_firestore.dart';

class ProcedurePolice{
  String employeeID;
  String vehicleProfileSearched;
  String driverProfileSearched;
  List<dynamic> criminalAssessment;
  String ticket;
  DocumentReference ticketCreated;
  FieldValue startTime;
  FieldValue endTime;
  DocumentReference documentID;
  DocumentReference plateValidate;

  ProcedurePolice({this.vehicleProfileSearched,this.driverProfileSearched,this.criminalAssessment,this.ticket,this.endTime,
                      this.startTime,this.employeeID,this.ticketCreated,this.documentID,this.plateValidate});

}