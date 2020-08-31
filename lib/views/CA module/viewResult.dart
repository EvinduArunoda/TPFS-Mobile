import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpfs_policeman/models/criminal.dart';
import 'package:tpfs_policeman/models/offences.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/criminalAssessment.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/CA%20module/viewOffences.dart';

class ViewResult extends StatefulWidget {
  String assessDriverImagePath;
  String matchDriverImagePath;
  Criminal criminalDetails;
  String filepath;
  String corelation;
  CriminalAssessment assessCriminal;
  
  ViewResult({this.matchDriverImagePath,this.criminalDetails,this.filepath,this.corelation,
                      this.assessDriverImagePath,@required this.assessCriminal,Key key}) : super(key:key);

  @override
  _ViewResultState createState() => _ViewResultState();
}

class _ViewResultState extends State<ViewResult> {
  bool isMatch = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading? LoadingAnother() : Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      key: Key('MatchAppBar'),
      automaticallyImplyLeading: isMatch,
      title: Text('Assessment Results',key: Key('MatchAppText'),style: GoogleFonts.orbitron(),),
      centerTitle: true,
      backgroundColor: Colors.cyan[900],
      elevation: 0.0,
    ),
    body: SingleChildScrollView(
      child: Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            color: Colors.grey[800],
            height: 30.0,
          ),
          Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Test Image'.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
                  )),
                ),
                SizedBox(height: 10.0),
                Container(key: Key('TestImage'),height: 200, child: Image.file(File(widget.assessDriverImagePath))),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[800],
            height: 30.0,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'MATCH  :',
                    style: GoogleFonts.specialElite(
                      textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    )),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: Text(
                      '${(double.parse(widget.corelation)*100).toStringAsFixed(2)}%',
                      style: GoogleFonts.rambla(
                        textStyle: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 21.0,
                        letterSpacing: 2.0,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[800],
            height: 30.0,
          ),
          Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Matched Image'.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
                  )),
                ),
                SizedBox(height: 10.0),
                Container(key: Key('MatchImage'),height: 200,child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(widget.matchDriverImagePath),
                )),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[800],
            height: 25.0,
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  !isMatch? ButtonBar(
                    children: <Widget>[
                      RaisedButton(
                        key: Key('ConfirmMatchButton'),
                        onPressed: ()async{
                          setState(() => loading = true);
                          await widget.assessCriminal.updateMatchAndDetails(widget.filepath,'Match');
                          setState(() => loading = false);
                          setState(() => isMatch = true);
                        },
                        color: Colors.cyan[900],
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              children : <Widget>[
                                Text(
                                  'Confirm Match',
                                  style: GoogleFonts.bitter(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0
                                  )),
                                )
                              ]
                          ),
                        ),
                      ),
                      RaisedButton(
                        key: Key('RejectMatchButton'),
                        onPressed: ()async{
                          setState(() => loading = true);
                          await widget.assessCriminal.updateMatchAndDetails(widget.filepath,'No Match');
                          setState(() => loading = false);
                          Navigator.pop(context);

                        },
                        color: Colors.cyan[900],
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              children : <Widget>[
                                Text(
                                  'Reject Match',
                                  style: GoogleFonts.bitter(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0
                                  )),
                                )
                              ]
                          ),
                        ),
                      )
                    ],
                  ):
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RaisedButton(
                      key: Key('ViewOffencesButton'),
                      onPressed: () async{
                        setState(() => loading = true);
                        List<CriminalOffences> offencesOfCriminal = await widget.assessCriminal.getOffencesOfCriminals(widget.criminalDetails.offencesReference);
                        await Navigator.push(context,MaterialPageRoute(builder: (context) => ViewOffence(offencesOfCriminal: offencesOfCriminal)));
                        setState(() => loading = false);
                        },
                      color: Colors.cyan[900],
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            children : <Widget>[
                              Text(
                                'View Offences',
                                style: GoogleFonts.bitter(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0
                                )),
                              )
                            ]
                        ),
                      ),
                      // backgroundColor: Colors.cyan[900],
                    ),
                  ),

                ]
            ),
          ),
//          SizedBox(height: 10.0),
          Column(
            key: Key('namedetails'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'NAME :',
                style: GoogleFonts.specialElite(
                  textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 15.0,
                )),
              ),
              SizedBox(height: 5.0),
              Container(
                width: MediaQuery.of(context).size.width*0.9,
                child: Text(
                  widget.criminalDetails.name,
                  style: GoogleFonts.rambla(
                    textStyle: TextStyle(
                    color: Colors.cyan[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    letterSpacing: 2.0,
                  )),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          isMatch?Column(
            children: <Widget>[
              Column(
                key: Key('MatchDetails'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'NIC NUMBER : ',
                    style: GoogleFonts.specialElite(
                      textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold
                    )),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                      child: Text(
                      widget.criminalDetails.nicNumber,
                      style: GoogleFonts.rambla(
                        textStyle: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        letterSpacing: 2.0,
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
          Row(
            children: <Widget>[
              Text(
                'PHONE NUMBER :',
                style: GoogleFonts.specialElite(
                textStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
                )),
              ),
              SizedBox(width: 5.0),
              Text(
                widget.criminalDetails.phoneNumber,
                style: GoogleFonts.rambla(
                  textStyle: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  letterSpacing: 2.0,
                )),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ADDRESS : ',
                style: GoogleFonts.specialElite(
                textStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
                )),
              ),
              SizedBox(height: 5.0),
              Container(
                width: MediaQuery.of(context).size.width*0.9,
                  child: Text(
                  widget.criminalDetails.address,
                  style: GoogleFonts.rambla(
                  textStyle: TextStyle(
                    color: Colors.cyan[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    letterSpacing: 2.0,
                  )),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0),
            ],
          ): Container(key: Key('NoShowDetails'),),
        ],
      ),
    ),
  ),
    );
  }
}