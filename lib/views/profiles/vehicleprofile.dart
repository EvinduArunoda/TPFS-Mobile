import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/vehicle.dart';
import 'package:tpfs_policeman/services/cameraController.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/db_vehicle.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/tickets/createTicket.dart';
import 'package:tpfs_policeman/views/tickets/ticketHistory.dart';

class NinjaCardV extends StatefulWidget {

  Vehicle vehicle;
  Ticket ticket;
  CameraDescription camera;
  NinjaCardV({Key key, @required this.vehicle, @required this.ticket,this.camera}) : super(key: key);
  _NinjaCardVState createState() => _NinjaCardVState();
}

class _NinjaCardVState extends State<NinjaCardV> {
  bool loading = false;
 Widget getTextWidgets(){
    return new Column(crossAxisAlignment: CrossAxisAlignment.start,children: widget.vehicle.conditionAndClass.map((item) => Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom:2.0),
        child: new Text(
                  '${item['inWord']}',
                  textAlign: TextAlign.left,
                  style:GoogleFonts.rambla(
                  textStyle: TextStyle(
                    color: Colors.cyan[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                    letterSpacing: 2.5,
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
              Text("Add a picture of the vehicle with the license plate visible to continue",
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
              Navigator.push(context,MaterialPageRoute(builder: (context) => TakePictureScreen(camera: widget.camera,ticket:widget.ticket,reason: '2',vehicle: widget.vehicle,key: Key('TakePictureDriver'),)));
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(key:Key('goBackVehicle')),
        title: Text('Vehicle Profile',style: GoogleFonts.orbitron(letterSpacing: 2.5,fontSize: 20.0),),
        centerTitle: true,
        backgroundColor: Colors.cyan[900],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(
                color: Colors.grey[800],
                height: 60.0,
              ),
              Text(
                'License Plate Number'.toUpperCase(),
                style:GoogleFonts.specialElite(
                  textStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w400
                )),
              ),
              SizedBox(height: 5.0),
              Text(
                widget.vehicle.licensePlate,
                style:GoogleFonts.rambla(
                textStyle:  TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  letterSpacing: 2.5,
                )),
              ),
              SizedBox(height: 15.0),
              Text(
                'Make and Model'.toUpperCase(),
                style:GoogleFonts.specialElite(
                  textStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w400
                )),
              ),
              SizedBox(height: 5.0),
              Text(
                widget.vehicle.makeAndModel,
                style:GoogleFonts.rambla(
                textStyle: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  letterSpacing: 2.5,
                )),
              ),
              SizedBox(height: 15.0),
              Text(
                'Registered Owner'.toUpperCase(),
                style:GoogleFonts.specialElite(
                textStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w400
                )),
              ),
              SizedBox(height: 5.0),
              Text(
                widget.vehicle.regOwner,
                style:GoogleFonts.rambla(
                textStyle: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  letterSpacing: 2.5,
                )),
              ),
              SizedBox(height: 15.0),
              Text(
                'Registration Number'.toUpperCase(),
                style:GoogleFonts.specialElite(
                textStyle:  TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w400
                )),
              ),
              SizedBox(height: 5.0),
              Text(
                widget.vehicle.regownerNumber,
                style:GoogleFonts.rambla(
                textStyle: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  letterSpacing: 2.5,
                )),
              ),
              SizedBox(height: 15.0),
              Text(
                'Owner NIC Number'.toUpperCase(),
                style:GoogleFonts.specialElite(
                textStyle:  TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w400
                )),
              ),
              SizedBox(height: 5.0),
              Text(
                widget.vehicle.regNICNumber,
                style:GoogleFonts.rambla(
                textStyle: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  letterSpacing: 2.5,
                )),
              ),
              SizedBox(height: 15.0),
              Text(
                'Insurance Number'.toUpperCase(),
                style:GoogleFonts.specialElite(
                textStyle:  TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w400
                )),
              ),
              SizedBox(height: 5.0),
              Text(
                widget.vehicle.insuranceNumber,
                style:GoogleFonts.rambla(
                textStyle: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  letterSpacing: 2.5,
                )),
              ),
              SizedBox(height: 15.0),
              Text(
                'Vehicle Conditions and Class'.toUpperCase(),
                style:GoogleFonts.specialElite(
                textStyle:  TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w400
                )),
              ),
              SizedBox(height: 5.0),
              Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: getTextWidgets()
              ),
              Divider(
                color: Colors.grey[800],
                height: 35.0,
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children:<Widget>[
                  RaisedButton(
                    key: Key('DriverAddButton'),
                    onPressed: (){
                      // ticket.licensePlate = vehicle.licensePlate;
                      // print(ticket.licensePlate);
                      showResult();
                      // print(ticket.licensePlate);
                       //Navigator.popUntil(context, ModalRoute.withName("Process"));
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
                    key: Key('ViewOffencesButton'),
                    onPressed: () async{
                      setState(()=> loading = true);
                       List<Ticket> result = await VehicleCollection().outstandingticketsDetails(widget.vehicle.licensePlate);
                      //  print(result);
                       List<Ticket>tickets;
                       if(result != null){
                         tickets = await CreateTicketNew().getLocationFromCoordinates(result);
                       }
                       else{
                         tickets = result;
                       }
                       List<Ticket> resultOther = await VehicleCollection().paidticketsDetails(widget.vehicle.licensePlate);
                      List<Ticket>paidTickets;
                      if(resultOther!=null){
                        paidTickets = await CreateTicketNew().getLocationFromCoordinates(resultOther);
                      }else{
                        paidTickets = resultOther;
                      }

                      List<Ticket> resultOther2 = await VehicleCollection().reportedticketsDetails(widget.vehicle.licensePlate);
                      List<Ticket>reportedTickets;
                      if(resultOther2!=null){
                        reportedTickets = await CreateTicketNew().getLocationFromCoordinates(resultOther2);
                      }else{
                        reportedTickets = resultOther2;
                      }
                      List<String>allFines = await CreateTicketNew().findAllFines();
                      // print(allFines);
                      await Navigator.push(context,MaterialPageRoute(builder: (context) => TicketHistory(outstandingTickets: tickets,key: Key('vehicleOffences'),
                                    paidTickets: paidTickets,reportedTickets: reportedTickets,offencelist: allFines,
                                    permoutstandingTickets: tickets,permpaidTickets: paidTickets,permreportedTickets: reportedTickets,)),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}