import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tpfs_policeman/models/offences.dart';

class Criminal{
    String name;
    String address;
    String nicNumber;
    String phoneNumber;
    List<dynamic> offencesReference;

    Criminal({this.name,this.address,this.nicNumber,this.phoneNumber,this.offencesReference});
}
