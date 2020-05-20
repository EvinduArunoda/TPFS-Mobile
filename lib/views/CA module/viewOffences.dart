import 'package:flutter/material.dart';
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
        title: Text('Commited Criminal Offences'),
        centerTitle: true,
        backgroundColor: Colors.cyan[900],
        elevation: 0.0,
      ),
      body: OffenceList(offencesOfCriminal: widget.offencesOfCriminal),
      
    );
  }
}