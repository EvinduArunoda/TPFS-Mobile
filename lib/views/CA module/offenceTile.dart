import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpfs_policeman/models/offences.dart';

class OffenceTile extends StatefulWidget {
  CriminalOffences offence;

  OffenceTile({this.offence});
  @override
  _OffenceTileState createState() => _OffenceTileState();
}

class _OffenceTileState extends State<OffenceTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              decoration: new BoxDecoration(
              boxShadow:[ new BoxShadow(
              color: Colors.blueGrey,
              blurRadius: 6.0,
            ),
            ]),
            child: Card(
              color: Colors.white,
              // margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 5.0),
              child: ListTile(
                dense: true,
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Date : '.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2.0,
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            widget.offence.date,
                            style: GoogleFonts.specialElite(
                              textStyle: TextStyle(
                              color: Colors.cyan[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              letterSpacing: 2.0,
                            )),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Text(
                            'Location : '.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2.0,
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(
                                widget.offence.place,
                                style: GoogleFonts.specialElite(
                                  textStyle: TextStyle(
                                  color: Colors.red[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  letterSpacing: 2.0,
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.0),
                      Row(
                        children: <Widget>[
                          Text(
                            'Offence : '.toUpperCase(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.9,
                              child:Text(
                                widget.offence.offence,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.specialElite(
                                textStyle: TextStyle(
                                  color: Colors.cyan[900],
                                  letterSpacing: 2.0,
                                   fontSize: 17.0,
                                  fontWeight: FontWeight.bold
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      
    );
  }
}