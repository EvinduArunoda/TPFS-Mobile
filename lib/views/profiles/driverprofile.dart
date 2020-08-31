import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/driver.dart';
import 'package:tpfs_policeman/services/cameraController.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/db_driver.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/tickets/createTicket.dart';
import 'package:tpfs_policeman/views/tickets/ticketHistory.dart';

class NinjaCardD extends StatefulWidget {

  Driver driver;
  Ticket ticket;
  String driverImage;
  CameraDescription camera;
  DriverCollection driverCollection;
  CreateTicketNew creatingTicket;
  NinjaCardD({Key key, @required this.driver,@required this.ticket,@required this.driverImage,this.camera,@required this.driverCollection,
                                  @required this.creatingTicket}) : super(key: key);
  _NinjaCardDState createState() => _NinjaCardDState();
}

class _NinjaCardDState extends State<NinjaCardD> {
    bool loading = false;

    Widget getTextWidgets(){
    return new Column(key: Key('TextWidgets'),crossAxisAlignment: CrossAxisAlignment.start,children: widget.driver.physicalDisabilities.map((item) => Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom:1.0),
        child: new Text(
                  '${item['inWord']}',
                  textAlign: TextAlign.left,
                  style:GoogleFonts.rambla(
                  textStyle: TextStyle(
                    color: Colors.cyan[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                    letterSpacing: 2.0,
                  )),
                  ),
      ),
    )).toList());
  }

  @override
  Widget build(BuildContext context) {

    void showResult(){
      showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          key: Key('AddPictureLicensePlate'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Add a clear picture of the license of the driver to continue",
                            style: TextStyle(fontSize: 18),),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Continue',key: Key('DriverAddContinue'),
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context,MaterialPageRoute(builder: (context) => TakePictureScreen(camera: widget.camera,ticket:widget.ticket,reason: '3',driver: widget.driver,key: Key('TakePictureDriver'),)));
              },
            ),
            FlatButton(
              child: Text('Cancel',key: Key('DriverAddCancel'),
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              onPressed: () {
                  Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
        
    return loading ? LoadingAnother() :Scaffold(
      key: Key('DriverProfilePage'),
      backgroundColor: Colors.white,
      appBar: AppBar(
        key:Key('DriverProfileAppBar'),
        title: Text('Driver Profile',key:Key('DriverProfileAppText'),style: GoogleFonts.orbitron(letterSpacing: 2.5,fontSize: 20.0),),
        centerTitle: true,
        backgroundColor: Colors.cyan[900],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                key: Key('DriverImage'),
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage:NetworkImage(widget.driverImage),
                ),
              ),
              Divider(
                color: Colors.grey[800],
                height: 40.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'LICENSE NUMBER :'.toUpperCase(),
                    key: Key('DriverProfileText'),
                    style:GoogleFonts.specialElite(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                    )),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: Text(
                      widget.driver.licenseNumber,
                      key: Key('DriverProfileField'),
                      style:GoogleFonts.rambla(
                      textStyle: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'NAME :',
                    key: Key('DriverProfileText2'),
                    style:GoogleFonts.specialElite(
                    textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    )),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: Text(
                      widget.driver.name,
                      key: Key('DriverProfileField2'),
                      style:GoogleFonts.rambla(
                      textStyle: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        letterSpacing: 2.0,
                      )),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    'NIC NUMBER :',
                    key: Key('DriverProfileText3'),
                    style:GoogleFonts.specialElite(
                    textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    )),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: Text(
                      widget.driver.nicnumber,
                      key: Key('DriverProfileField3'),
                      style:GoogleFonts.rambla(
                      textStyle: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        letterSpacing: 2.0,
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'ADDRESS : ',
                    key: Key('DriverProfileText4'),
                    style:GoogleFonts.specialElite(
                    textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400
                    )),
                  ),
                  SizedBox(height: 5.0),
                  Container(     
                    width: MediaQuery.of(context).size.width*0.9,
                      child: Text(
                    widget.driver.address,
                    key: Key('DriverProfileField4'),
                      style:GoogleFonts.rambla(
                      textStyle: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        letterSpacing: 2.0,
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Text(
                    'PHONE NUMBER :',
                    key: Key('DriverProfileText5'),
                    style:GoogleFonts.specialElite(
                    textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400
                    )),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    '${widget.driver.phoneNumber}',
                    key: Key('DriverProfileField5'),
                    style:GoogleFonts.rambla(
                    textStyle: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      letterSpacing: 2.0,
                    )),
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Text(
                'PHYSCIAL DISABILITIES',
                key: Key('DriverProfileText6'),
                style:GoogleFonts.specialElite(
                    textStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w400
                )),
              ),
              SizedBox(height: 5.0),
              Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: getTextWidgets()
              ),
              SizedBox(height: 15.0),
              Text(
                'EMAIL ADDRESS',
                key: Key('DriverProfileText7'),
                style:GoogleFonts.specialElite(
                    textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.0,
                )),
              ),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.email,
                    key: Key('DriverProfileIcon'),
                    color: Colors.cyan[900],
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    widget.driver.emailAddress,
                    key: Key('DriverProfileField7'),
                    style:GoogleFonts.rambla(
                    textStyle: TextStyle(
                      color: Colors.cyan[900],
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                    )),
                  )
                ],
              ),
              Divider(
                color: Colors.grey[800],
                height: 30.0,
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                    key: Key('DriverAddButton'),
                onPressed: (){
                  showResult();
                },
                color: Colors.cyan[900],
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                  children : <Widget>[
                    Icon(
                      Icons.add_box,
                      color: Colors.white,
                      size: 25.0,
                      ),
                    Text(
                      'Add to Ticket',
                      style:GoogleFonts.bitter(
                      textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
                    )),
                      )
                  ]
                    ),
                ),
                // backgroundColor: Colors.cyan[900],
              ),
              RaisedButton(
                key: Key('DriverViewButton'),
                onPressed: () async{
                  setState(()=> loading = true);
                  // List<String> offencesList;
                  List<Ticket> result = await widget.driverCollection.outstandingticketsDetails(widget.driver.licenseNumber);
                  List<Ticket>outstandingtickets;
                  if(result!=null){
                    outstandingtickets = await widget.creatingTicket.getLocationFromCoordinates(result);
                  }else{
                    outstandingtickets = result;
                  }
                  List<Ticket> resultOther = await widget.driverCollection.paidticketsDetails(widget.driver.licenseNumber);
                  List<Ticket>paidTickets;
                  if(resultOther!=null){
                    paidTickets = await widget.creatingTicket.getLocationFromCoordinates(resultOther);
                  }else{
                    paidTickets = resultOther;
                  }
                  List<Ticket> resultOther2 = await widget.driverCollection.reportedticketsDetails(widget.driver.licenseNumber);
                  List<Ticket>reportedTickets;
                  if(resultOther2!=null){
                    reportedTickets = await widget.creatingTicket.getLocationFromCoordinates(resultOther2);
                  }else{
                    reportedTickets = resultOther2;
                  }
                  List<String>allFines = await widget.creatingTicket.findAllFines();
                  await Navigator.push(context,MaterialPageRoute(builder: (context) => TicketHistory(key:Key('TicketHistoryKey'),outstandingTickets: outstandingtickets,
                        paidTickets: paidTickets,reportedTickets: reportedTickets,offencelist: allFines,
                        permoutstandingTickets: outstandingtickets,permpaidTickets: paidTickets,permreportedTickets: reportedTickets)),
    );
                  setState(()=> loading = false);
                },
                color: Colors.cyan[900],
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                  children : <Widget>[
                    Icon(
                      Icons.subtitles,
                      color: Colors.white,
                      size: 25.0,
                      ),
                    Text(
                      'View Tickets',
                      style:GoogleFonts.bitter(
                      textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0
                      )),
                      )
                  ]
                    ),
                ),
                // backgroundColor: Colors.cyan[900],
              ),
              
                ] 
              ),
            ],
          ),
        ),
      ),
      );
  }
}