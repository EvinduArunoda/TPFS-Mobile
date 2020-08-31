import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/fine.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/shared/constant.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:tpfs_policeman/views/tickets/createTicket.dart';
import 'package:tpfs_policeman/views/tickets/fineTicket.dart';

class CreateTicketPage3 extends StatefulWidget {
  Fine fine;
  List<Fine> tempFines;

  CreateTicketPage3({@required this.fine, @required this.tempFines,Key key}) : super(key:key);
  @override
 _CreateTicketPage3State createState() => _CreateTicketPage3State();
}

class _CreateTicketPage3State extends State<CreateTicketPage3> {
  bool checkboxvalue = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('tilefine'),
    padding: EdgeInsets.only(top:4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CheckboxListTile(
          key: Key('checkboxtilefine'),
          title: Text(widget.fine.fineDescription),
          controlAffinity: ListTileControlAffinity.leading,
          value: checkboxvalue,
          onChanged: (bool value) {
            setState(() { 
              checkboxvalue = value;
              });
              value? widget.tempFines.add(widget.fine) : widget.tempFines.remove(widget.fine);
          },
          secondary: Text(
            '${widget.fine.fineAmount}',
            style: TextStyle(
            color: Colors.black,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            )),
        ),
      ] 
    ),
        );
  }
}