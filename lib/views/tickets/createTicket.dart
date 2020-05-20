import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/shared/constant.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/tickets/createTicket2.dart';

class CreateTicket extends StatefulWidget {
  Ticket ticket;
  Map<String,String> dateAndTime;
  String location;
  CameraDescription camera;

  CreateTicket({@required this.dateAndTime, @required this.ticket, @required this.location,this.camera});
  @override
 _CreateTicketState createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  String time = '';
  String date = '';
  bool licenseNumPresent = false;
  bool licensePlatePresent = false;
  bool phoneNumberPresent = false;

  String licenseNum = '';
  String licensePlate = '';
  String phoneNumber = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    if(widget.ticket.licenseNumber != null){
      licenseNumPresent = true;
    }
    if(widget.ticket.licensePlate != null){
      licensePlatePresent = true;
    }
    if(widget.ticket.phoneNumber != null){
      phoneNumberPresent = true;
    }
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        elevation: 0.0,
        title: Text('Create Ticket'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.symmetric(vertical: 23.0, horizontal: 30.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'LOCATION INFORMATION',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    Text(
                      'DATE :',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontSize: 12.0
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '${widget.dateAndTime['date']}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontSize: 18.0
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    Text(
                      'TIME : ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontSize: 12.0
                      ),
                    ),
                  SizedBox(width: 10.0),
                  Text(
                    '${widget.dateAndTime['time']}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontSize: 18.0
                    ),
                  ),
                  ],
                ),
                SizedBox(height: 15.0),
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'AREA :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.cyan[900],
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontSize: 12.0
                        ),
                      ),
                      SizedBox(width: 7.0),
                      Flexible(
                        child: Container(
                          child: Text(
                            '${widget.location}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontSize: 16.0
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                Text(
                  'PERSONAL INFORMATION',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'DRIVING LICENSE NUMBER',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.cyan[900],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 12.0
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  decoration: new BoxDecoration(
                  boxShadow:[ new BoxShadow(
                  color: Colors.white,
                  blurRadius: 10.0,
                ),
                ]),
                  child: licenseNumPresent? 
                  Text(
                  widget.ticket.licenseNumber,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 18.0
                  ),
                ) :TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    decoration: textInputDecoration.copyWith(),
                    validator: (val) => val.isEmpty|| val.length !=8 || val[0].toUpperCase() != 'B' || !isNumeric(val.substring(1))  ? 'Enter valid driving license number' : null,
                    onChanged: (val){
                      setState(() => licenseNum = val.toUpperCase().trim());
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                 Text(
                  'VEHICLE LICENSE NUMBER',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.cyan[900],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 12.0
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  '  Format :* KI-1234',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 13.0
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  decoration: new BoxDecoration(
                  boxShadow:[ new BoxShadow(
                  color: Colors.white,
                  blurRadius: 10.0,
                ),
                ]),
                  child: licensePlatePresent?
                  Text(
                  widget.ticket.licensePlate,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 18.0
                  ),
                ): TextFormField(
                    autofocus: false,
                    decoration: textInputDecoration.copyWith(),
                    validator: (val) => val.isEmpty? 'Enter valid license plate number' : null,
                    onChanged: (val){
                      setState(() => licensePlate = val.toUpperCase().trim());
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'PHONE NUMBER',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.cyan[900],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 12.0
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  decoration: new BoxDecoration(
                  boxShadow:[ new BoxShadow(
                  color: Colors.white,
                  blurRadius: 10.0,
                ),
                ]),
                  child: phoneNumberPresent?
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                        '${widget.ticket.phoneNumber}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontSize: 18.0
                        ),
                      ),
                        SizedBox(width:35.0),
                        RaisedButton(
                          color: Colors.cyan[900],
                          child: Text(
                            'Change',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            widget.ticket.phoneNumber = null;
                            setState(() => phoneNumberPresent = false);
                          }
                        ),
                      ],
                    ),
                  ): TextFormField(
                    autofocus: false,
                    decoration: textInputDecoration.copyWith(),
                    validator: (val) => val.isEmpty || val.length != 10 || val.substring(0,2) != '07'? 'Enter a valid phone number' : null,
                    onChanged: (val){
                      setState(() => phoneNumber = val.trim());
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                  color: Colors.cyan[900],
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async{
                    Navigator.popUntil(context, ModalRoute.withName("Process"));
                  }
                ),
                    RaisedButton(
                      color: Colors.cyan[900],
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async{
                        if(_formkey.currentState.validate()){
                          // if(result == null){
                          //   setState(() => error = 'Could not sign in with those credentials');
                          //   setState(() => loading = false);
                          // }
                          if(widget.ticket.licenseNumber== null){
                            widget.ticket.licenseNumber = licenseNum;
                          }
                          if(widget.ticket.licensePlate == null){
                            widget.ticket.licensePlate = licensePlate;
                            print(widget.ticket.licensePlate.substring(0,2));
                            print(widget.ticket.licensePlate.substring(3));
                          }
                          if(widget.ticket.phoneNumber == null){
                            widget.ticket.phoneNumber = int.parse(phoneNumber);
                          }
                          widget.ticket.date = widget.dateAndTime['date'];
                          widget.ticket.time = widget.dateAndTime['time'];
                          widget.ticket.area = widget.location;
                          
                          // print(widget.ticket.phoneNumber);
                          widget.ticket.vehicle = 'Car';
                         // widget.ticket.prevOffences = await CreateTicketNew().getPreviousTickets(widget.ticket.licenseNumber, widget.ticket.licensePlate);
                          Navigator.push(context,MaterialPageRoute(settings: RouteSettings(name: "CreateTicketPage2"),builder: (context) => CreateTicketPage2(ticket: widget.ticket,camera: widget.camera)));
                        }
                      }
                    ),
                    ]
                ),
            ] 
            ),
          ),
        ),
      ),
    );
  }
}