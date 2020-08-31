
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold
  ),
  fillColor: Colors.white38,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 3.0)
  )
);


Container buildGridView (String name , IconData icon,Function whenPressed, String gridData, String step,Key key ) {
    return Container(
      key: key,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Padding(
          padding: const EdgeInsets.only(top:6.0),
          child: Container(
//            color: Colors.white,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            boxShadow:[ BoxShadow(
            color: Colors.blueGrey,
            blurRadius: 10.0,
          ),
          ]),
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 20.0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height:5.0),
                          Text(
                            'Step $step',
                            style: GoogleFonts.fjallaOne(
                              textStyle:TextStyle(
                              color: Colors.red[900],
                              fontWeight: FontWeight.bold,
                              // fontFamily: 'Roboto',
                              letterSpacing: 0.8,
                              fontSize: 19,
                            ),),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height:0.0),
                          IconButton(
                            icon: Icon(
                              icon,
                              color: Colors.cyan[900],
                              ),
                            iconSize: 97.0,
                            onPressed: (){
                              whenPressed();
                            },
                          ),
                          SizedBox(height:0.0),
                          Text(
                            '$name',
                            style:GoogleFonts.fjallaOne(
                              textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              // fontFamily: 'Roboto',
                              letterSpacing: 0.8,
                              fontSize: 22,
                            )),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            gridData.toUpperCase(),
                            style:GoogleFonts.specialElite(
                            textStyle: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              letterSpacing: 1.5
                          )),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              color:  Colors.white,
            ),
          ),
        ),
      ),
    );
    }


Row buildTextView (String name, String data) {
  return Row(
          children: <Widget>[
            Text(
              '$name ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 15,
              )
            ),
            SizedBox(width: 20.0),
            Text(
            '$data',
            style: TextStyle(
              color: Colors.cyan[900],
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 20,
            )
          ),
          ],
        );
}