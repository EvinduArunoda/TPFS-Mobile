import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tpfs_policeman/services/navigation.dart';
import 'package:tpfs_policeman/services/locator.dart';
import 'package:tpfs_policeman/views/home/HomePage.dart';

class PushNotificationsManager {

   String deviceToken;
   String userID;

  PushNotificationsManager._({this.userID});

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  final NavigationService _navigationService = locator<NavigationService>();
  

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
      },
      // onBackgroundMessage: myBackgroundMessageHandler,

      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _serialiseAndNavigate(message);
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _serialiseAndNavigate(message);
        // _navigateToItemDetail(message);
      },
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
       _firebaseMessaging.subscribeToTopic('puppies');
      deviceToken = token;
      print("FirebaseMessaging token: $token");
      
      _initialized = true;
    }
  }

    void _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var title = notificationData['sendername'];
    var description = notificationData['message'];
    _navigationService.navigateTo(HomePage());
    // if (view != null) {
    //   // Navigate to the create post view
    //   if (view == 'create_post') {
    //     _navigationService.navigateTo(CreatePostViewRoute);
    //   }
    //   // If there's no view it'll just open the app on the first view
    // }
  }

  

  // Future<String> checkToken()async{
  //   DocumentSnapshot tokenDocument = await Firestore.instance
  //       .collection("pushtokens").document(userID).get();
  //   String savedToken = tokenDocument.data['devtoken'];
  //   if(deviceToken != savedToken){

  //   }

  }