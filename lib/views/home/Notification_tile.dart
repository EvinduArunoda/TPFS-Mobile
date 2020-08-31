import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpfs_policeman/models/notification.dart';
import 'package:tpfs_policeman/views/tickets/ticketDetails.dart';

class NotificationTile extends StatelessWidget {
 NotificationPresent notification ;

 NotificationTile({this.notification,Key key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('NotificationContainer'),
        decoration: new BoxDecoration(
        boxShadow:[ new BoxShadow(
        color: Colors.cyan[900],
        blurRadius: 6.0,
      ),
      ]),
      child: Card(
        color: Colors.white,
        // margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 5.0),
        child: ListTile(
          key: Key('NotificationTile'),
          dense: true,
          title: Row(
            children: <Widget>[
              Text(
                '${notification.title}',
                style: GoogleFonts.fjallaOne(
                  textStyle:TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  letterSpacing: 1.0
                )),
                ),
              SizedBox(width: 15.0),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  notification.description,
                  style: GoogleFonts.specialElite(
                        textStyle:TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    // fontWeight: FontWeight.w100,
                    fontSize: 14.0
                  )),
                ),
                SizedBox(width: 10.0),
              ]
            ),
          ),
        ),
      ),
    );
  }
}