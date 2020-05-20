import 'package:flutter/material.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:provider/provider.dart';
// import 'package:tpfs_policeman/views/tickets/Ticket_list.dart';
import 'package:tpfs_policeman/views/profiles/profile.dart';

class TicketDetails extends StatelessWidget {

  final Ticket ticket;

  TicketDetails({this.ticket});

  // final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title : Text('Ticket Details'),
      backgroundColor: Colors.cyan[900],
      elevation: 10.0,
    ),
    body: SingleChildScrollView(
      child: Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            color: Colors.grey[800],
            height: 30.0,
          ),
          Text(
            'LICENSE NUMBER',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            ticket.licenseNumber,
            style: TextStyle(
              color: Colors.cyan[900],
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'LICENSE PLATE NUMBER',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            ticket.licensePlate,
            style: TextStyle(
              color: Colors.cyan[900],
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'OFFENCES',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: MediaQuery.of(context).size.width*0.8,
            child: Text(
              'Speed Driving, No license',
              style: TextStyle(
                color: Colors.cyan[900],
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                letterSpacing: 2.0,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'DATE AND TIME',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '${ticket.date} : ${ticket.time}',
            style: TextStyle(
              color: Colors.cyan[900],
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'AREA',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            ticket.area,
            style: TextStyle(
              color: Colors.cyan[900],
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'TYPE OF VEHICLE',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            ticket.vehicle,
            style: TextStyle(
              color: Colors.cyan[900],
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'FINE AMOUNT',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '${ticket.fineAmount}',
            style: TextStyle(
              color: Colors.cyan[900],
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'TICKET STATUS',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            ticket.status,
            style: TextStyle(
              color: Colors.red[900],
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              letterSpacing: 2.0,
            ),
          ),
          Divider(
            color: Colors.grey[800],
            height: 40.0,
          ),
        ],
      ),
    ),
      ),
      );
  }
}