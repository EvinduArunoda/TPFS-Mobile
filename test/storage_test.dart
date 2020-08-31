import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:tpfs_policeman/services/firebaseStorage.dart';
import 'dart:io';



Future<String> getGsLink(StorageReference storageRef) async {
  return 'gs://' + await storageRef.getBucket() + '/' + storageRef.path;
}

class MockStorage extends Mock implements Storage{

  Future<String> getDriverImage(String licenseNumber) async{
    final storage = MockFirebaseStorage();
    StorageReference storageReference = storage    
        .ref()    
        .child('Drivers/$licenseNumber.jpg');
    // print(storageReference);
    String downloadAddress = await getGsLink(storageReference);
  return downloadAddress;
}

  Future<String> uploadVehicleTicketImage(String vehicleImagePath,String licensePlate,String filepath) async{
    final storage = MockFirebaseStorage();
    StorageReference storageReferencedriver = storage    
        .ref()    
        .child('Tickets/$filepath/$licensePlate');
    StorageUploadTask uploadTask1 = storageReferencedriver.putFile(File(vehicleImagePath));
    StorageTaskSnapshot taskSnap1 = await uploadTask1.onComplete;
    return 'Tickets/$filepath/$licensePlate';
  }
}

void main(){
  group('Firebase Storage Access Methods', (){

    test('Firebase Get Upload Address', () async{
      MockStorage storagemock = MockStorage();
      final uploadurl = await storagemock.uploadVehicleTicketImage('something.png', 'KI-1234', 'djbooewqwoqho321999HVK');
      expect(uploadurl,'Tickets/djbooewqwoqho321999HVK/KI-1234');
    });

    test('Firebase Get Download Address', () async{
      MockStorage storagemock = MockStorage();
      final downloadurl = await storagemock.getDriverImage('B1234567');
      expect(downloadurl,'gs://some-bucket//Drivers/B1234567.jpg');
    });
  });
}