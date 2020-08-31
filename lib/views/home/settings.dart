import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/user.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userLog = Provider.of<UserLog>(context) ?? UserLog(numOfProcedures:0,numbOfTicSuccess:0,numbOfTicRep:0,
                                                                numofDriProfViewed: 0,numofVehProfViewed: 0);

    return SingleChildScrollView(
          child: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:408.0),
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.clear,color: Colors.black,size: 40,),
                  onPressed: ()=> Navigator.of(context).pop()),
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: Text(
                      'Procedure Logs for the year'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.orbitron(
                        textStyle:TextStyle(
                        color: Colors.cyan[900],
                        letterSpacing: 2.0,
                        fontSize: 33.0,
                        fontWeight: FontWeight.bold
                      )),
                    ),
              ),
              Divider(
                color: Colors.grey[800],
                height: 50.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Number Of Procedures Started : '.toUpperCase(),
                    style: GoogleFonts.electrolize(
                      textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      fontSize: 25.0,
                    )),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${userLog.numOfProcedures}',
                    style:GoogleFonts.fjallaOne(
                        textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold
                    )),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              Row(
                children: <Widget>[
                  Text(
                    'Number Of tickets created : '.toUpperCase(),
                     style: GoogleFonts.electrolize(
                      textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      fontSize: 25.0,
                    )),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${userLog.numbOfTicSuccess}',
                    style:GoogleFonts.fjallaOne(
                        textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold
                    )),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              Row(
                children: <Widget>[
                  Text(
                    'Number Of tickets reported : '.toUpperCase(),
                    style: GoogleFonts.electrolize(
                      textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      fontSize: 25.0,
                    )),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${userLog.numbOfTicRep}',
                    style:GoogleFonts.fjallaOne(
                        textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold
                    )),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              Row(
                children: <Widget>[
                  Text(
                    'Number Of vehicle profiles viewed: '.toUpperCase(),
                    style: GoogleFonts.electrolize(
                      textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      fontSize: 25.0,
                    )),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${userLog.numofVehProfViewed}',
                    style: GoogleFonts.fjallaOne(
                        textStyle:TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold
                    )),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              Row(
                children: <Widget>[
                  Text(
                    'Number Of driver profiles viewed : '.toUpperCase(),
                    style: GoogleFonts.electrolize(
                      textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      fontSize: 25.0,
                    )),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '${userLog.numofDriProfViewed}',
                    style: GoogleFonts.fjallaOne(
                        textStyle:TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold
                    )),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
            ],
          ),
        ),
      ),
    );
  }
}