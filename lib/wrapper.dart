import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/checkType.dart';
import 'package:tpfs_policeman/views/authenticate/authenticate.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/views/home/HomePage.dart';

class Wrapper extends StatelessWidget {
  CameraDescription firstCamera;

  Wrapper({this.firstCamera});
  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);
    // return either the Home or Authenticate widget
    if(user != null){
      // print('gjgkkkkkkkkkkkkkkkkkkkkkkkkkkkkk$user');
      return HomePage(camera: firstCamera);
      }
    else{
      return Authenticate();
    }
    
  }
}