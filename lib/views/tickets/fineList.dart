import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/fine.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/tickets/createTicket.dart';
import 'package:tpfs_policeman/views/tickets/createTicket2.dart';
import 'package:tpfs_policeman/views/tickets/createTicket3.dart';
import 'package:tpfs_policeman/views/tickets/fineTicket.dart';

class FineList extends StatefulWidget {
  Ticket ticket;
  List<Fine> fines;
  List<Fine> tempFines = List<Fine>();

  FineList({Key key,@required this.ticket, @required this.fines}) : super(key: key);
  @override
  _FineListState createState() => _FineListState();
}

class _FineListState extends State<FineList> {
  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'issueTicket');
  bool loading = false;

  void showContent(){
    showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Select atleast one offence to proceed',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
            ),
                ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'OK',
               style: TextStyle(
                letterSpacing: 0.5,
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        elevation: 0.0,
        title: Text('Select Offence Commited'),
        centerTitle: true,
      ),
      body: 
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: ListView.builder(
              itemCount: widget.fines.length,
              itemBuilder: (context, index){
                // print(tempFines);
                return CreateTicketPage3(fine: widget.fines[index],tempFines:widget.tempFines);
              },
            ),
          ),
          persistentFooterButtons: <Widget>[
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: RaisedButton(
                color: Colors.cyan[900],
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  widget.ticket.vehicle = null;
                  Navigator.popUntil(context, ModalRoute.withName("Process"));
                }
          ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: RaisedButton(
                  color: Colors.cyan[900],
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async{
                    if(widget.tempFines.length == 0){
                      showContent();
                    }
                    else{
                      setState(()=>loading =true);
                      widget.ticket.offences=[];
                    for (int i = 0; i < widget.tempFines.length; i++) {
                      widget.ticket.offences.add(widget.tempFines[i].fineDescription.toString());
                      
                    }
                    List<String> offences = List<String>();
                    List<dynamic> fineAmounts = List<dynamic>();
                    widget.tempFines.forEach((data)=> offences.add(data.fineDescription));
                    widget.tempFines.forEach((data)=> fineAmounts.add(data.fineAmount));
                    // print(widget.ticket.phoneNumber);
                    // print(widget.ticket.licenseNumber);
                    // print(fineAmounts);
                    final HttpsCallableResult amountFine = await callable.call(
                      <String, dynamic>{
                        'step' : '1',
                        'offences' : offences ,
                        'fineAmounts' :fineAmounts,
                      },
                    );
                    print((amountFine.data)/1.0);
                    widget.ticket.fineAmount = (amountFine.data)/1.0;
                    print(widget.tempFines.length); 
                    setState(()=>loading =false);
                    Navigator.popUntil(context, ModalRoute.withName("CreateTicket"));
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => FineTicket(ticket: widget.ticket,callable: callable)));
                      //print(resp.data);
                    //  print(widget.ticket.offences);
                   } }
              ),
            ),
          ],
    );
  }
}
