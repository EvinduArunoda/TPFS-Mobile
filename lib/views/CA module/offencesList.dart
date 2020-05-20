import 'package:flutter/material.dart';
import 'package:tpfs_policeman/models/offences.dart';
import 'package:tpfs_policeman/views/CA%20module/offenceTile.dart';

class OffenceList extends StatefulWidget {
  List<CriminalOffences>offencesOfCriminal;

  OffenceList({this.offencesOfCriminal});
  @override
  _OffenceListState createState() => _OffenceListState();
}

class _OffenceListState extends State<OffenceList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.offencesOfCriminal.length,
      itemBuilder: (context, index){
         return OffenceTile(offence: widget.offencesOfCriminal[index]);
        // return BrewTile(brew: brews[index]);
      },
    );
  }
}