import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/services/locator.dart';
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
  final firstCamera = cameras.last;
  setupLocator();
  runApp(MyApp(camera: firstCamera));
}
class MyApp extends StatefulWidget {
  CameraDescription camera;

  MyApp({this.camera});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
//    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//    await _firebaseMessaging.subscribeToTopic('puppies');
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    bool _initialized = false;
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          new Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );});
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

      // For testing purposes print the Firebase Messaging token
//      String token = await _firebaseMessaging.getToken();
      _firebaseMessaging.subscribeToTopic('puppies');
//      deviceToken = token;
//      print("FirebaseMessaging token: $token");

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