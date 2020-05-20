import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/firebaseStorage.dart';
import 'package:tpfs_policeman/views/tickets/ticketHistory.dart';
import 'package:tpfs_policeman/shared/constant.dart';
import 'package:tpfs_policeman/models/user.dart';

class FineTicket extends StatefulWidget {
  Ticket ticket ;
  HttpsCallable callable;

  FineTicket({@required this.ticket,@required this.callable});
  @override
  _FineTicketState createState() => _FineTicketState();
}

class _FineTicketState extends State<FineTicket> {

  final _formKey = GlobalKey<FormState>();
  bool created = false;
  int verificationCode = 0;
  String hashNum = '';
  num numOfTimes =0;
  String testCode = '';
  final time = DateTime.now();

  Widget getTextWidgets(){
    return new Column(children: widget.ticket.offences.map((item) => Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom:7.0),
        child: new Text(
                  item,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    letterSpacing: 2.0,
                  ),
                  ),
      ),
    )).toList());
  }

  @override
  void showContent(User userUID){
    showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Customer Acceptance',
        style: TextStyle(fontWeight: FontWeight.bold),),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Driver acceptance should be recieved to create ticket.'),
              SizedBox(height: 3.0),
              Text('A verification code will be sent to the driver to proceed'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('ACCEPT',
                style: TextStyle(fontWeight: FontWeight.bold),),
            onPressed: () async{
              if(numOfTimes > 3){
                widget.ticket.fineAmount=0.0;
                 Navigator.pop(context);
                 showFailureMessage('Exceeded the limit of verification codes.Please start a new ticket');
              }
              else{
              //send verification code
              print(widget.ticket.phoneNumber);
              final HttpsCallableResult sentCode = await widget.callable.call(
                  <String, dynamic>{
                    'step' : '2',
                    'phoneNumber' : widget.ticket.phoneNumber ,
                  },
                );
                setState(() => numOfTimes = numOfTimes + 1);
                print(sentCode.data);
                Navigator.of(context).pop();
                List<dynamic> hashNumCode = sentCode.data;
                print(hashNumCode[1]);
                hashNum = hashNumCode[0];
                testCode = hashNumCode[1];
                print(hashNum);
                _getVerificationCode(userUID);}
            },
          ),
          FlatButton(
            child: Text('CANCEL',
        style: TextStyle(fontWeight: FontWeight.bold),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
  }

  void _getVerificationCode(User userUID){
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Form(
          key: _formKey,
          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Message has been sent to the phone number.',
                style: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 16.0
                ),
                ),
               SizedBox(height: 3.0),
               Text(
                 'Please enter the code within 5 minutes',
                 style: TextStyle(
                   color: Colors.cyan[900],
                   fontWeight: FontWeight.bold,
                   letterSpacing: 2.0,
                   fontSize: 16.0
                 ),
                 ),
              SizedBox(height:15.0),
              Text(
                'VERIFICATION CODE',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 14.0
                ),
              ),
              SizedBox(height:5.0),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: textInputDecoration.copyWith(),
                  validator: (val) {
                    if(val.isEmpty){
                      return 'Enter a code';
                    }
                    else{
                      if(val.length==6){
                        return null;
                      }
                      else{
                        return 'Enter a valid code';
                      }
                    }
                  },
                  onChanged: (val){
                  verificationCode = int.parse(val.trim());
                },
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: ButtonBar(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("SUBMIT",
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      onPressed: () async{
                        if (_formKey.currentState.validate()) {
                          //check if verification code is right
                          print(hashNum);
                          print(testCode);
                          print(verificationCode);
                          final HttpsCallableResult checkCode = await widget.callable.call(
                            <String, dynamic>{
                              'step' : '3',
                              'otp' : verificationCode,
                              'phoneNumber' : widget.ticket.phoneNumber ,
                              'hashNum' : hashNum ,
                            },
                          );
                          print(checkCode.data);
                          // bool isMatch = true;
                          if(checkCode.data == true){
                            //if right add the ticket to the database
                            List<double> coding = await CreateTicketNew().getCoordinateOnly();
                            print(coding);
                            widget.ticket.status = 'open';
                            final HttpsCallableResult saveData = await widget.callable.call(
                               <String, dynamic>{
                                 'step' : '4',
                                 'userID':userUID.uid,
                                 'licenseNumber' : widget.ticket.licenseNumber,
                                 'licensePlate' : widget.ticket.licensePlate,
                                 'phoneNumber' : widget.ticket.phoneNumber,
                                 'vehicle' : widget.ticket.vehicle,
                                 'fineAmount' : widget.ticket.fineAmount,
                                 'area' : coding,
                                 'status' : 'open',
                                 'offences' : widget.ticket.offences
                               },
                             );
                             print(saveData.data);
                            // final filepath = '${userUID.uid}:$time';
                            // print(filepath);
                            // String fileUsed = await Storage().uploadDriverTicketImage(widget.ticket.driverImagePath,widget.ticket.licenseNumber,filepath);
                            // // print(fileUsed);
                            // await Storage().uploadVehicleTicketImage( widget.ticket.vehicleImagePath, widget.ticket.licensePlate,fileUsed);
                            Navigator.of(context).pop();
                            setState(() => created = true);
                          }
                          else if(checkCode.data == 'falsebytime'){
                            Navigator.of(context).pop();
                            showResult('Code has expired. Please try again');
                          }
                          else{
                            Navigator.of(context).pop();
                            showResult('The code entered was incorrect.Please try again');
                          }
                          // }
                          // else{
                          //   //if not right send a message through modal.With button to resend or cancel.if resend same modal again

                          //   //modal with message the code doesnt match resend or expired resend
                          // }


                        }

                      },
                    ),
                    RaisedButton(
                      child: Text("RESEND",
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      onPressed: () async {
                        if(numOfTimes > 3){
                          widget.ticket.fineAmount=0.0;
                          widget.ticket.status = 'Failed';
                          Navigator.pop(context);
                          showFailureMessage('Exceeded the limit of verification codes.Please start a new ticket');
                        }
                        else{
                        Navigator.of(context).pop();}
                        showContent(userUID);
                      },
                    ),
                    RaisedButton(
                      child: Text("REPORT",
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      onPressed: () async{
                       List<double> coding = await CreateTicketNew().getCoordinateOnly();
                            print(coding);
                            widget.ticket.status = 'reported';
                            final HttpsCallableResult saveData = await widget.callable.call(
                               <String, dynamic>{
                                 'step' : '4',
                                 'userID':userUID.uid,
                                 'licenseNumber' : widget.ticket.licenseNumber,
                                 'licensePlate' : widget.ticket.licensePlate,
                                 'phoneNumber' : widget.ticket.phoneNumber,
                                 'vehicle' : widget.ticket.vehicle,
                                 'fineAmount' : widget.ticket.fineAmount,
                                 'area' : coding,
                                 'status' : 'reported',
                                 'offences' : widget.ticket.offences
                               },
                             );
                            //  final filepath = '${userUID.uid}:$time';
                            //   print(filepath);
                            //   String fileUsed = await Storage().uploadDriverTicketImage(widget.ticket.driverImagePath,widget.ticket.licenseNumber,filepath);
                            //   // print(fileUsed);
                            //   await Storage().uploadVehicleTicketImage( widget.ticket.vehicleImagePath, widget.ticket.licensePlate,fileUsed);
                             print(saveData.data);
                            Navigator.of(context).pop();
                            widget.ticket.fineAmount=0.0;
                            showFailureMessage('The ticket has been reported');
                        // hashNumCode = '12345'
                      },
                    ),
                    RaisedButton(
                      child: Text("CANCEL",
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
    );
}

 void showResult(String message){
    showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK',
                style: TextStyle(fontWeight: FontWeight.bold),),
            onPressed: () {
                Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  }

     void showFailureMessage(String message){
    showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                message,
                style: TextStyle(
                  // color: Colors.black,
                  letterSpacing: 2.0,
                  // fontWeight: FontWeight.bold,
                  fontSize: 18,
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
              Navigator.popUntil(context, ModalRoute.withName("Process"));
            },
          ),
        ],
      );
    },
  );
  }
  @override
  Widget build(BuildContext context) {
    final userUID = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Ticket'),
        centerTitle: true,
        backgroundColor: Colors.cyan[900],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 3.0, 30.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              created ? Center(
                child: Icon(
                  Icons.check_box,
                  color: Colors.green,
                  size: 50.0,
                ),
              ) : Container(),
              Divider(
                color: Colors.grey[800],
                height: 20.0,
              ), 
              Container(
                decoration: new BoxDecoration(
                boxShadow:[ new BoxShadow(
                color: Colors.blueGrey,
                blurRadius: 2.0,
          ),
          ]),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: <Widget>[ 
                    Text(
                      'License Plate Number',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 10.0),
                Text(
                    widget.ticket.licensePlate,
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 2.0,
                    ),
                ),
                SizedBox(height: 15.0),
                Text(
                    'Driving License Number',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold
                    ),
                ),
                SizedBox(height: 10.0),
                Text(
                    widget.ticket.licenseNumber,
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 2.0,
                    ),
                ),
                SizedBox(height: 15.0),
                Text(
                    'Date and Time',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold
                    ),
                ),
                SizedBox(height: 10.0),
                Text(
                    '${widget.ticket.date} : ${widget.ticket.time}',
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 2.0,
                    ),
                ),
                SizedBox(height: 15.0),
                Text(
                  'Area',
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                    // widget.ticket.area,
                    widget.ticket.area,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 2.0,
                    ),
                ),
                SizedBox(height: 15.0),
                Text(
                  'Type Of Vehicle',
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold
                  ),
              ),
                SizedBox(height: 10.0),
                Text(
                    widget.ticket.vehicle,
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 2.0,
                    ),
                ),
                SizedBox(height: 15.0),
                Text(
                    'Commited Offences',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 17
                    ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width*0.9,

                      child: getTextWidgets(),
                      // Text(
                      //   '10years from manufacture',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     color: Colors.red[900],
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 16.0,
                      //     letterSpacing: 2.0,
                      //   ),
                      // ),
                  ),
                ),         
                SizedBox(height: 7.0),
                Text(
                    'Fine Amount',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 17
                    ),
                ),
                SizedBox(height: 10.0),
                Text(
                    '${widget.ticket.fineAmount}',
                    style: TextStyle(
                      color: Colors.red[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      letterSpacing: 2.0,
                    ),
                ),
                ],),
                  )
                ),
              ),
              Divider(
                color: Colors.grey[800],
                height: 23.0,
              ),
              created? Center(
                child: RaisedButton( 
                  onPressed: () {Navigator.popUntil(context, ModalRoute.withName("Process"));},
                  color: Colors.cyan[900],
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Close Ticket',
                      style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
            ),
                      ),
                  ),),
              ) : ButtonBar(
                mainAxisSize: MainAxisSize.max,
                children:<Widget>[
                  RaisedButton(
                    onPressed: () => showContent(userUID),
                    color: Colors.cyan[900],
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Create Ticket',
                        style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                ),
                        ),
                    ),
                    // backgroundColor: Colors.cyan[900],
                  ),
                  RaisedButton(
                    onPressed: (){
                      widget.ticket.offences = null;
                      widget.ticket.fineAmount = null;
                      widget.ticket.vehicle = null;
                      //Navigator.popUntil(context, ModalRoute.withName("Process"));
                      Navigator.pop(context);
                    },
                    color: Colors.cyan[900],
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Cancel Ticket',
                        style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                ),
                        ),
                    ),
                    // backgroundColor: Colors.cyan[900],
                  ),
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}