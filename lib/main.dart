import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/services/pushNotification.dart';
import 'package:tpfs_policeman/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/services/navigation.dart';

Future<Null> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  print(cameras);

  // Get a specific camera from the list of available cameras.
  // final firstCamera = cameras.last;
  runApp(MyApp(camera: cameras));
}
class MyApp extends StatefulWidget {
  List<CameraDescription> camera;

  MyApp({this.camera});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    bool _initialized = false;
    if (!_initialized) {
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        // onBackgroundMessage: myBackgroundMessageHandler,

        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          // _navigateToItemDetail(message);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          // _navigateToItemDetail(message);
        },
      );
      _firebaseMessaging.subscribeToTopic('puppies');

      _initialized = true;
    }
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
          child: MaterialApp(
        home: Wrapper(firstCamera: widget.camera),
      ),
    );
  }
}