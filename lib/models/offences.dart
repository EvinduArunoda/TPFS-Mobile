import 'package:cloud_firestore/cloud_firestore.dart';

class CriminalOffences {
  String date;
  String offence;
  String place;

  CriminalOffences({this.offence,this.date,this.place});
}