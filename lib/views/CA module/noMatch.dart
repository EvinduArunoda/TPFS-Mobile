import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpfs_policeman/services/createTicket.dart';

class NoMatch extends StatefulWidget {
  String imagePath;

  NoMatch({this.imagePath,Key key}) : super(key:key);
  @override
  _NoMatchState createState() => _NoMatchState();
}

class _NoMatchState extends State<NoMatch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      key: Key('NoMatchAppBar'),
      title: Text('Assessment Results',key:Key('NoMatchAppText'),style: GoogleFonts.orbitron(),),
      centerTitle: true,
      backgroundColor: Colors.cyan[900],
      elevation: 0.0,
    ),
    body: SingleChildScrollView(
      child: Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
      child: Column(
        children: <Widget>[
          Text(
            'No Match Found'.toUpperCase(),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontSize: 25.0,
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'RESULT :',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(width: 10.0),
              Container(
                width: MediaQuery.of(context).size.width*0.4,
                child: Text(
                  'Unknown',
                  style: TextStyle(
                    color: Colors.cyan[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
         Divider(
            color: Colors.grey[800],
            height: 40.0,
          ),
          Text(
            'Test Image',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontSize: 17.0,
            ),
          ),
          SizedBox(height: 15.0),
          Container(key:Key('NoMatchImage'),height: 200,child: Image.file(File(widget.imagePath))),
          Divider(
            color: Colors.grey[800],
            height: 40.0,
          ),
          Text(
            'If any criminal offence has been commited by this individual carry out legal proceedings manually',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    ),
  ),
    );
  }
}