import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:tpfs_policeman/views/tickets/ticketDetails.dart';

class NotificationTile extends StatelessWidget {

  // final Brew brew;
  // BrewTile({this.brew});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          dense: true,
          title: Row(
            children: <Widget>[
              Text(
                'Speeding Fine Increase',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
                ),
                ),
              SizedBox(width: 15.0),
              // Badge(
              //   badgeContent: Text('NEW',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
              //   badgeColor: Colors.yellow,
              //   shape: BadgeShape.square,
              // )
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  'This is to inform the speeding fine has been increased from Rs.3000 to Rs.30,000 from this week ',
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    // fontWeight: FontWeight.bold
                  ),
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