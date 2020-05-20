import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/fine.dart';
import 'package:tpfs_policeman/models/validate.dart';
// import 'package:permission_handler/permission_handler.dart';

class CreateTicketNew {


  Future<Map<String,String>> fillTicketForm() async{

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String date = formatter.format(now);
    String time = DateFormat.jm().format(now);
    Map<String,String> dateAndTime = {
      'date': date,
      'time' :time
      };
    return dateAndTime;
  }

  Future<List<Fine>> getSuitableFine(String type) async{
    List<DocumentSnapshot> fineDetail=[];
    List<DocumentSnapshot>commonFine = (await Firestore.instance
        .collection("Fine")
        .where("type", isEqualTo: 'Common')
        .getDocuments())
        .documents;
    List<DocumentSnapshot>typeFine = (await Firestore.instance
      .collection("Fine")
      .where("type", isEqualTo: type)
      .getDocuments())
      .documents;
    fineDetail = new List.from(commonFine)..addAll(typeFine);
    print(fineDetail);
    return fineDetail.map(_fineFromDocument).toList();

  }

  Fine _fineFromDocument(DocumentSnapshot document){
    return Fine(
      fineType: document.data['type'],
      fineDescription: document.data['description'],
      fineAmount: (document.data['amount'])/1.0
    );
  }

  Future<String> getLocationData() async{
    // Position location;

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Service not enabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('permission not granted');
      }
    }

     _locationData = await location.getLocation();
    // bool isShown = await PermissionHandler().shouldShowRequestPermissionRationale(PermissionGroup.location);
    // Position location = await Geolocator()
    //   .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print(_locationData);
    var results = await Geocoder.local.findAddressesFromCoordinates(new Coordinates(_locationData.latitude, _locationData.longitude));
  return results.first.addressLine;
  }

  Future<Coordinates> getLocationFromAddress(String address) async{
    var addresses = await Geocoder.local.findAddressesFromQuery(address);
    var first = addresses.first;
    print(Coordinates);
    return first.coordinates;
  }
  
   Future<List<double>> getCoordinateOnly() async{
    // Position location;
    Location location = new Location();
    LocationData _locationData;
    _locationData = await location.getLocation();
   
      return [_locationData.latitude, _locationData.longitude];
  }

  
  Future<List<Ticket>> getLocationFromCoordinates(List<Ticket>ticket) async{
    for (var i = 0; i < ticket.length; i++) {
      var results = await Geocoder.local.findAddressesFromCoordinates(new Coordinates(ticket[i].areaCoordinates.latitude, ticket[i].areaCoordinates.longitude)); 
      String location = results.first.addressLine;
      ticket[i].area = location;
      DateTime dateAndTime = new DateTime.fromMillisecondsSinceEpoch(ticket[i].timestamp.millisecondsSinceEpoch);
      var formatter = new DateFormat('yyyy-MM-dd');
      ticket[i].date = formatter.format(dateAndTime);
      ticket[i].time = DateFormat.jm().format(dateAndTime);
    }
  return ticket;
  }

  Future<List<String>> findAllFines() async{
    List<DocumentSnapshot>fineDetails = (await Firestore.instance
        .collection("Fine")
        .getDocuments())
        .documents;
    return fineDetails.map(_offencesFromDocument).toList();
  }

  String _offencesFromDocument(DocumentSnapshot document){
    return document.data['description'];
  }

  List<Ticket> filterOffences(List<Ticket> tickets,List<String>offences){
    List<Ticket>filteredTickets =[];
    for (var i = 0; i < tickets.length; i++) {
      if(offences.any((item) => tickets[i].offences.contains(item))){
        filteredTickets.add(tickets[i]);
      }      
    }
    return filteredTickets;
  }
 }