import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpfs_policeman/models/offences.dart';
import 'package:tpfs_policeman/views/CA%20module/offencesList.dart';

class ViewOffence extends StatefulWidget {
  List<CriminalOffences> offencesOfCriminal;

  ViewOffence({this.offencesOfCriminal});
  @override
  _ViewOffenceState createState() => _ViewOffenceState();
}

class _ViewOffenceState extends State<ViewOffence> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Criminal Offences',style: GoogleFonts.orbitron(),),
        centerTitle: true,
        backgroundColor: Colors.cyan[900],
        elevation: 0.0,
      ),
      body: OffenceList(offencesOfCriminal: widget.offencesOfCriminal),
      
    );
  }
}