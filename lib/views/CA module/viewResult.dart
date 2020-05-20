import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tpfs_policeman/models/criminal.dart';
import 'package:tpfs_policeman/models/offences.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/criminalAssessment.dart';
import 'package:tpfs_policeman/views/CA%20module/viewOffences.dart';

class ViewResult extends StatefulWidget {
  String assessDriverImagePath;
  String matchDriverImagePath;
  Criminal criminalDetails;
  String filepath;
  String corelation;
  
  ViewResult({this.matchDriverImagePath,this.criminalDetails,this.filepath,this.corelation,this.assessDriverImagePath});

  @override
  _ViewResultState createState() => _ViewResultState();
}

class _ViewResultState extends State<ViewResult> {
  bool isMatch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text('Assessment Results'),
      centerTitle: true,
      backgroundColor: Colors.cyan[900],
      elevation: 0.0,
    ),
    body: SingleChildScrollView(
      child: Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Test Image'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
                  ),
                ),
                SizedBox(height: 10.0),
                Container(height: 200, child: Image.file(File(widget.assessDriverImagePath))),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'MATCH  :',
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: Text(
                    '${(double.parse(widget.corelation)*100).toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 21.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
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
                  style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
                  ),
                ),
                SizedBox(height: 10.0),
                Container(height: 200,child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(widget.matchDriverImagePath),
                )),
              ],
            ),
          ),
//          Container(child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//            Text(
//              'Test Image'.toUpperCase(),
//              style: TextStyle(
//                  color: Colors.black,
//                  letterSpacing: 1.0,
//                  fontWeight: FontWeight.bold,
//                  fontSize: 15.0
//              ),
//            ),
//            SizedBox(width:15.0),
//            Text(
//              'Matched Image'.toUpperCase(),
//              style: TextStyle(
//                  color: Colors.black,
//                  letterSpacing: 1.0,
//                  fontWeight: FontWeight.bold,
//                  fontSize: 15.0
//              ),
//            )
//          ],),),
//          Container(height: 200,child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Image.network(widget.matchDriverImagePath),
//          )),
          Divider(
            color: Colors.grey[800],
            height: 30.0,
          ),
          ButtonBar(
              alignment: MainAxisAlignment.end,
              children: <Widget>[
                !isMatch? ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: ()async{
                        await CriminalAssessment().updateMatchAndDetails(widget.filepath,'Match');
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
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0
                                ),
                              )
                            ]
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: ()async{
                        await CriminalAssessment().updateMatchAndDetails(widget.filepath,'No Match');
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
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0
                                ),
                              )
                            ]
                        ),
                      ),
                    )
                  ],
                ):
                RaisedButton(
                  onPressed: () async{
                    List<CriminalOffences> offencesOfCriminal = await CriminalAssessment().getOffencesOfCriminals(widget.criminalDetails.offencesReference);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ViewOffence(offencesOfCriminal: offencesOfCriminal)));
                  },
                  color: Colors.cyan[900],
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        children : <Widget>[
                          Text(
                            'View Offences',
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0
                            ),
                          )
                        ]
                    ),
                  ),
                  // backgroundColor: Colors.cyan[900],
                ),

              ]
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'NAME :',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                width: MediaQuery.of(context).size.width*0.9,
                child: Text(
                  widget.criminalDetails.name,
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
          SizedBox(height: 15.0),
          isMatch?Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'NIC NUMBER : ',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                      child: Text(
                      widget.criminalDetails.nicNumber,
                      style: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
          Row(
            children: <Widget>[
              Text(
                'PHONE NUMBER :',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(width: 5.0),
              Text(
                widget.criminalDetails.phoneNumber,
                style: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ADDRESS : ',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                width: MediaQuery.of(context).size.width*0.9,
                  child: Text(
                  widget.criminalDetails.address,
                  style: TextStyle(
                    color: Colors.cyan[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0),
            ],
          ): Container(),
        ],
      ),
    ),
  ),
    );
  }
}