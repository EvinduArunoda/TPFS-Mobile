import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/driver.dart';
import 'package:tpfs_policeman/services/cameraController.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/db_driver.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/views/tickets/createTicket.dart';
import 'package:tpfs_policeman/views/tickets/ticketHistory.dart';

class NinjaCardD extends StatelessWidget {

  Driver driver;
  Ticket ticket;
  String driverImage;
  CameraDescription camera;
  NinjaCardD({Key key, @required this.driver,@required this.ticket,@required this.driverImage,this.camera}) : super(key: key);

    Widget getTextWidgets(){
    return new Column(crossAxisAlignment: CrossAxisAlignment.start,children: driver.physicalDisabilities.map((item) => Container(
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
              Navigator.push(context,MaterialPageRoute(builder: (context) => TakePictureScreen(camera: camera,ticket:ticket,reason: '3',driver: driver)));
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
      title: Text('Driver Profile'),
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
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage:NetworkImage(driverImage),
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
                  'LICENSE NUMBER :',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Text(
                    driver.licenseNumber,
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      letterSpacing: 2.0,
                    ),
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
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Text(
                    driver.name,
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  'NIC NUMBER :',
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Text(
                    driver.nicnumber,
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 2.0,
                    ),
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
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  
                  width: MediaQuery.of(context).size.width*0.9,
                    child: Text(
                   driver.address,
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              children: <Widget>[
                Text(
                  'PHONE NUMBER :',
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(width: 5.0),
                Text(
                  '${driver.phoneNumber}',
                  style: TextStyle(
                    color: Colors.cyan[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
             Text(
              'PHYSCIAL DISABILITIES',
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
            SizedBox(height: 15.0),
            Text(
              'EMAIL ADDRESS',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.cyan[900],
                ),
                SizedBox(width: 10.0),
                Text(
                  driver.emailAddress,
                  style: TextStyle(
                    color: Colors.cyan[900],
                    fontSize: 16.0,
                    letterSpacing: 1.0,
                  ),
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
              onPressed: (){
                showResult();
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
                List<String> offencesList;
                List<Ticket> result = await DriverCollection().outstandingticketsDetails(driver.licenseNumber);
                List<Ticket>outstandingtickets;
                if(result!=null){
                   outstandingtickets = await CreateTicketNew().getLocationFromCoordinates(result);
                }else{
                  outstandingtickets = result;
                }
                List<Ticket> resultOther = await DriverCollection().paidticketsDetails(driver.licenseNumber);
                List<Ticket>paidTickets;
                if(resultOther!=null){
                   paidTickets = await CreateTicketNew().getLocationFromCoordinates(resultOther);
                }else{
                  paidTickets = resultOther;
                }
                List<Ticket> resultOther2 = await DriverCollection().reportedticketsDetails(driver.licenseNumber);
                List<Ticket>reportedTickets;
                if(resultOther2!=null){
                  reportedTickets = await CreateTicketNew().getLocationFromCoordinates(resultOther2);
                }else{
                  reportedTickets = resultOther2;
                }
                List<String>allFines = await CreateTicketNew().findAllFines();
                Navigator.push(context,MaterialPageRoute(builder: (context) => TicketHistory(outstandingTickets: outstandingtickets,
                      paidTickets: paidTickets,reportedTickets: reportedTickets,offencelist: allFines,
                      permoutstandingTickets: outstandingtickets,permpaidTickets: paidTickets,permreportedTickets: reportedTickets)),
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
            ),
          ],
        ),
      ),
    ),
      );
  }
}