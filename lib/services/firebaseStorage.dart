 import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore    
import 'package:flutter/material.dart';  
import 'package:flutter/cupertino.dart';
import 'dart:io';

class Storage{

Future<String> getDriverImage(String licenseNumber) async{
  StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('Drivers/$licenseNumber.jpg');
  // print(storageReference);
  String downloadAddress = "https://miro.medium.com/max/790/1*reXbWdk_3cew69RuAUbVzg.png";
  try {
    downloadAddress = await storageReference.getDownloadURL();
  }catch (e) {
  }
  return downloadAddress;
}

Future<String> getUserImage(String userID) async{
  StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('Policemen/$userID.jpg');
  print(storageReference);
  String downloadAddress = await storageReference.getDownloadURL();
  return downloadAddress;
}

Future<String> getTicketImage(String employeeID) async{
  StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('Policemen/$employeeID.jpg');
  print(storageReference);
  String downloadAddress = await storageReference.getDownloadURL();
  return downloadAddress;
}

Future<String> uploadVehicleTicketImage(String vehicleImagePath,String licensePlate,String filepath) async{
  StorageReference storageReferencedriver = FirebaseStorage.instance    
       .ref()    
       .child('Tickets/$filepath/$licensePlate');
  print(storageReferencedriver);
  StorageUploadTask uploadTask1 = storageReferencedriver.putFile(File(vehicleImagePath));
  StorageTaskSnapshot taskSnap1 = await uploadTask1.onComplete;

  print(taskSnap1);
  return 'Tickets/$filepath/$licensePlate';
}

Future<String> uploadDriverTicketImage(String driverImagePath,String licenseNumber,String filepath) async{
  StorageReference storageReferencedriver = FirebaseStorage.instance    
       .ref()    
       .child('Tickets/$filepath/$licenseNumber');
  print(storageReferencedriver);
  StorageUploadTask uploadTask1 = storageReferencedriver.putFile(File(driverImagePath,));
  StorageTaskSnapshot taskSnap1 = await uploadTask1.onComplete;

  print(taskSnap1);
  return 'Tickets/$filepath/$licenseNumber';
}

Future<String> uploadDriverAssessImage(String driverAssessImagePath,String filepath) async{
  StorageReference storageReferencedriver = FirebaseStorage.instance    
       .ref()    
       .child('CriminalAssessment/$filepath');
  print(storageReferencedriver);
  StorageUploadTask uploadTask1 = storageReferencedriver.putFile(File(driverAssessImagePath));
  StorageTaskSnapshot taskSnap1 = await uploadTask1.onComplete;

  print(taskSnap1);
  return 'CriminalAssessment/$filepath';
}

Future<String> getCriminalImage(String personID) async{
  FirebaseStorage customstorageInstance = FirebaseStorage(storageBucket: 'gs://e-fining-sep-criminalassessment');
  StorageReference storageReference = customstorageInstance    
       .ref()    
       .child('CriminalDataset/$personID/1.jpg');
  print(storageReference);
  String downloadAddress = await storageReference.getDownloadURL();
  return downloadAddress;
}

}