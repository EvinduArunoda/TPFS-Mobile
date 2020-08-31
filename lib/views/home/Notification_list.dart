import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/views/home/Notification_tile.dart';
import 'package:tpfs_policeman/models/notification.dart';

class Notificationlist extends StatefulWidget {

  Notificationlist({Key key}) : super(key : key);
  @override
  _NotificationlistState createState() => _NotificationlistState();
}

class _NotificationlistState extends State<Notificationlist> {
  @override
  Widget build(BuildContext context) {

     final notifications = Provider.of<List<NotificationPresent>>(context) ?? [];

    return ListView.builder(
      key: Key('NotificationListBuilder'),
      itemCount:notifications.length,
      itemBuilder: (context, index){
         return NotificationTile(notification: notifications[index],key: Key('Notifications'),);
      },
    );
  }
}