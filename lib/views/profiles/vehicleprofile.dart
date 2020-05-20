import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/vehicle.dart';
import 'package:tpfs_policeman/services/cameraController.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/db_vehicle.dart';
import 'package:tpfs_policeman/views/tickets/createTicket.dart';
import 'package:tpfs_policeman/views/tickets/ticketHistory.dart';

class NinjaCardV extends StatelessWidget {

  Vehicle vehicle;
  Ticket ticket;
  CameraDescription camera;
  NinjaCardV({Key key, @required this.vehicle, @required this.ticket,this.camera}) : super(key: key);

 Widget getTextWidgets(){
    return new Column(crossAxisAlignment: CrossAxisAlignment.start,children: vehicle.conditionAndClass.map((item) => Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom:3.0),
        child: new Text(
                  '$item',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.cyan[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    letterSpacing: 2.0,
                  ),
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
            child: Text('Continue',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => TakePictureScreen(camera: camera,ticket:ticket,reason: '2',vehicle: vehicle)));
            },
          ),
          FlatButton(
            child: Text('Cancel',
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Vehicle Profile'),
        centerTitle: true,
        backgroundColor: Colors.cyan[900],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(
                color: Colors.grey[800],
                height: 60.0,
              ),
              Text(
                'License Plate Number',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                vehicle.licensePlate,
                style: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'Make and Model',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                vehicle.makeAndModel,
                style: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'Registered Owner',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                vehicle.regOwner,
                style: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'Registration Number',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                vehicle.regownerNumber,
                style: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'Owner NIC Number',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                vehicle.regNICNumber,
                style: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'Insurance Number',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                vehicle.insuranceNumber,
                style: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                'Vehicle Conditions and Class',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
                ),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                      children : <Widget>[
                        Icon(
                          Icons.add_box,
                          color: Colors.white,
                          size: 25.0,
                          ),
                        Text(
                        'Add to Ticket',
                        style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                ),
                        )
                      ]
                        ),
                    ),
                    // backgroundColor: Colors.cyan[900],
                  ),
                  RaisedButton(
                    onPressed: () async{
                       List<Ticket> result = await VehicleCollection().outstandingticketsDetails(vehicle.licensePlate);
                      //  print(result);
                       List<Ticket>tickets;
                       if(result != null){
                         tickets = await CreateTicketNew().getLocationFromCoordinates(result);
                       }
                       else{
                         tickets = result;
                       }
                       List<Ticket> resultOther = await VehicleCollection().paidticketsDetails(vehicle.licensePlate);
                      List<Ticket>paidTickets;
                      if(resultOther!=null){
                        paidTickets = await CreateTicketNew().getLocationFromCoordinates(resultOther);
                      }else{
                        paidTickets = resultOther;
                      }

                      List<Ticket> resultOther2 = await VehicleCollection().reportedticketsDetails(vehicle.licensePlate);
                      List<Ticket>reportedTickets;
                      if(resultOther2!=null){
                        reportedTickets = await CreateTicketNew().getLocationFromCoordinates(resultOther2);
                      }else{
                        reportedTickets = resultOther2;
                      }
                      List<String>allFines = await CreateTicketNew().findAllFines();
                      // print(allFines);
                      Navigator.push(context,MaterialPageRoute(builder: (context) => TicketHistory(outstandingTickets: tickets,
                                    paidTickets: paidTickets,reportedTickets: reportedTickets,offencelist: allFines,
                                    permoutstandingTickets: tickets,permpaidTickets: paidTickets,permreportedTickets: reportedTickets,)),
                      );
                    },
                    color: Colors.cyan[900],
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                      children : <Widget>[
                        Icon(
                          Icons.subtitles,
                          color: Colors.white,
                          size: 25.0,
                          ),
                        Text(
                          'View Tickets',
                          style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0
                ),
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