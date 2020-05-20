import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/driver.dart';
import 'package:tpfs_policeman/models/vehicle.dart';
import 'package:tpfs_policeman/services/cameraController.dart';
import 'package:tpfs_policeman/services/createTicket.dart';


 class TakePictureTicket extends StatefulWidget {
  //  CameraDescription camera;
   String imagePath;
   bool isVehicle;
   Ticket ticket;
   Vehicle vehicle;
   Driver driver;

   TakePictureTicket({this.isVehicle,this.ticket,this.imagePath,this.vehicle,this.driver});
   @override
   _TakePictureTicketState createState() => _TakePictureTicketState();
 }
 
 class _TakePictureTicketState extends State<TakePictureTicket> {

bool isImage = false;

  @override
  Widget build(BuildContext context) {
     void showModal(){
    showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              widget.isVehicle? Text("Vehicle reference has been added to the ticket",style: TextStyle(fontSize: 18),) :
              Text("Driver reference has been added to the ticket",style: TextStyle(fontSize: 18),),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Continue',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            onPressed: () {
              if(widget.isVehicle){
                if(widget.vehicle.insuranceNumber ==null){
                  Navigator.popUntil(context, ModalRoute.withName("CreateTicketPage2"));
                }
                else{
                  Navigator.popUntil(context, ModalRoute.withName("Process"));
                }
              }
              else{
                if(widget.driver.name ==null){
                  Navigator.popUntil(context, ModalRoute.withName("CreateTicketPage2"));
                }
                else{
                  Navigator.popUntil(context, ModalRoute.withName("Process"));
                }
              }
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
  );}
    if(widget.imagePath != null){
      isImage = true;
    }
    return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title : Padding(
        padding: const EdgeInsets.all(10.0),
        child: widget.isVehicle? Text(
          'Add Vehicle image to Ticket',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontFamily: 'Roboto',
            letterSpacing: 0.5,
            fontSize: 20,
          ),) :Text(
          'Add license image to Ticket',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontFamily: 'Roboto',
            letterSpacing: 0.5,
            fontSize: 20,
          ),),
      ),
      backgroundColor: Colors.cyan[900],
      elevation: 10.0,
    ),
    body: SingleChildScrollView(
      child: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 70.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0,5.0,25.0,5.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child:Column(
                      children: <Widget>[
                        Image.file(File(widget.imagePath)),
                        widget.isVehicle? Row(
                          children: <Widget>[
                            Text('License Plate : '.toUpperCase(), style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontSize: 15.0,
                            ),),
                            SizedBox(width:10.0),
                            Text(widget.vehicle.licensePlate, style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontSize: 19.0,
                            ),)
                          ],
                        ) : FittedBox(
                          fit: BoxFit.contain,
                          child: Row(
                            children: <Widget>[
                              Text('License Number : '.toUpperCase(),  style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                fontSize: 15.0,
                              ),),
                              SizedBox(width:10.0),
                              Text(widget.driver.licenseNumber, style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                fontSize: 19.0,
                              ),)
                            ],
                          ),
                        )
                      ],
                    ),
                  ), 
                  SizedBox(height:30.0),
                  FloatingActionButton.extended(
                    onPressed: () async{
                      //add image to ticket
                      if(widget.isVehicle){
                        //use cloud function to ocr read image validate then if validated add
                        widget.ticket.licensePlate = widget.vehicle.licensePlate;
                        widget.ticket.vehicleImagePath = widget.imagePath;
                        print('${widget.vehicle.insuranceNumber}');
                      }
                      else{
                        widget.ticket.licenseNumber = widget.driver.licenseNumber;
                        widget.ticket.phoneNumber = widget.driver.phoneNumber;
                        widget.ticket.driverImagePath = widget.imagePath;
                      }
                      //await CreateTicketNew().validatePicture(widget.imagePath);
                      showModal();
                    },
                    label: Text('Add Image To Ticket', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                    icon: isImage? Icon(Icons.assignment_ind) :Icon(Icons.add_a_photo),
                    backgroundColor: Colors.blueGrey,
                    )
                ]
              ),
            ),
          ),
        ),
      ),
    ),
    
    );
}
}
