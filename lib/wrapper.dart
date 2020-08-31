import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:tpfs_policeman/services/firebaseStorage.dart';
import 'package:tpfs_policeman/views/authenticate/authenticate.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/views/home/HomePage.dart';

class Wrapper extends StatelessWidget {
  List<CameraDescription> firstCamera;

  Wrapper({this.firstCamera});
  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);
    // DatabaseServicePolicemen(uid:user.uid).updateLocation();
    // return either the Home or Authenticate widget
    if(user != null){
      final DatabaseServicePolicemen policeUser = DatabaseServicePolicemen(uid: user.uid);
      return HomePage(camera: firstCamera,key: Key('HomePage'),storage: Storage(),policeUser: policeUser);
      }
    else{
      return Authenticate(key: Key('Authenticate'),);
    }
    
  }
}