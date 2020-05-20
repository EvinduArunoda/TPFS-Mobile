import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/validate.dart';
import 'package:tpfs_policeman/services/validateTicket.dart';

class ValidateResult extends StatefulWidget {
  String filepath;
  ValidateTicket ticketvalidate;
  Ticket ticket;
  ValidateResult({this.filepath,this.ticketvalidate,this.ticket});
  @override
  _ValidateResultState createState() => _ValidateResultState();
}

class _ValidateResultState extends State<ValidateResult> {
  var licensePlate = 'Validation On Process';
  var license;
  var coorelation;
  var match = 'Validation On Process';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Validate>(context);
    if(user == null){
      license = licensePlate;
      coorelation = match;

    }
    else{

      Map maximumscoreprediction = user.licensePlateValidation['prediction'][0];
      for (var i = 1; i < (user.licensePlateValidation['prediction'].length -1); i++) {
        if(user.licensePlateValidation['prediction'][i]['score']>maximumscoreprediction['score']){
          maximumscoreprediction = user.licensePlateValidation['prediction'][i];
        }
      }
      license = maximumscoreprediction['ocr_text'];
      widget.ticketvalidate.licenseplate = license;
      widget.ticket.validatedText = license;
      coorelation = maximumscoreprediction['score'];
      coorelation = (coorelation*100).toString().substring(0,5);
      widget.ticket.validatedTextScore = coorelation;
    }
    //
    return Container(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
                Text(
                  'LICENSE PLATE : ',
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height:4.0),
                Container(
                  width: MediaQuery.of(context).size.width*0.6,
                  child: Text(
                    '$license',
                    style: TextStyle(
                      color: Colors.cyan[900],
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
             ],
           ),
           SizedBox(height: 12.0),
            Row(
            //  crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
                Text(
                  'Match : '.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.3,
                  child: Text(
                    '$coorelation%',
                    style: TextStyle(
                      color: Colors.cyan[900],
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
             ],
           ),

         ],
       ),
    );
  }
}