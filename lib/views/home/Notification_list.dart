import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/views/home/Notification_tile.dart';
import 'package:tpfs_policeman/views/tickets/Ticket_tile.dart';

class Notificationlist extends StatefulWidget {
  @override
  _NotificationlistState createState() => _NotificationlistState();
}

class _NotificationlistState extends State<Notificationlist> {
  @override
  Widget build(BuildContext context) {

    // final brews = Provider.of<List<Brew>>(context);

    return ListView.builder(
      itemCount:2,
      itemBuilder: (context, index){
         return NotificationTile();
        // return BrewTile(brew: brews[index]);
      },
    );
  }
}