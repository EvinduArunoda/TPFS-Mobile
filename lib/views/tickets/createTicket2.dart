import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/driver.dart';
import 'package:tpfs_policeman/models/fine.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/models/validate.dart';
import 'package:tpfs_policeman/models/vehicle.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/services/cameraController.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/firebaseStorage.dart';
import 'package:tpfs_policeman/services/validateTicket.dart';
import 'package:tpfs_policeman/shared/constant.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/tickets/createTicket.dart';
import 'package:tpfs_policeman/views/tickets/fineList.dart';
import 'package:tpfs_policeman/views/tickets/validateResult.dart';

class CreateTicketPage2 extends StatefulWidget {
  Ticket ticket;
  CameraDescription camera;

  CreateTicketPage2({@required this.ticket,this.camera});
  @override
 _CreateTicketPage2State createState() => _CreateTicketPage2State();
}

class _CreateTicketPage2State extends State<CreateTicketPage2> {
  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: 'validateTicket');
  final HttpsCallable callablethird = CloudFunctions.instance.getHttpsCallable(functionName: 'CriminalDataset');


  final AuthService _auth = AuthService();
  bool loading = false;
  var _vehicles = ['Car', 'Auto' , 'Motor Cycle' , 'Heavy weighted vehicle'];
  var _selectedValue = 'Car';
  bool isVehicleImage = false;
  bool isDriverImage = false;
  bool isValidate = false;
  var licensePlate = '';
  final time = DateTime.now();
  
  @override
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

   void showModal(message){
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
              if(message == 'The license plate image does not match with the form data entered. Cancelling ticket'){
                Navigator.popUntil(context, ModalRoute.withName("Process"));
              }
              else{
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
  }

  Widget build(BuildContext context) {
    final userUID = Provider.of<User>(context);
    final filepath = '${userUID.uid}:$time';
    ValidateTicket validateticket = ValidateTicket(filepath: filepath);
    if(widget.ticket.vehicleImagePath != null){
      setState(() => isVehicleImage = true);
    }
    if(widget.ticket.driverImagePath != null){
      setState(() => isDriverImage = true);
    }
    return loading ? Loading() : StreamProvider<Validate>.value(
      value: validateticket.ticketValidation,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.cyan[900],
          elevation: 0.0,
          title: Text('Create Ticket'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 42.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10.0),
                 Text(
                  'TYPE OF VEHICLE',
                  style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0
                ),
                ),
                SizedBox(height: 15.0),
                Container(
                  decoration: new BoxDecoration(
                    border:  Border.all(
                      color: Colors.blueGrey,
                      width: 2,
                )),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButton<String>(
                      items: _vehicles.map((String dropDownStringItem){
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),

                      onChanged: (String newValueSelected){
                        setState(() {
                          this._selectedValue = newValueSelected;
                          widget.ticket.vehicle = this._selectedValue;
                        });
                      },
                      value: _selectedValue,
                    ),
                  )
                ),
                Divider(
                  color: Colors.black,
                  height: 60.0,
                ),
                isVehicleImage? Container(height:250,child: Center(child: Image.file(File(widget.ticket.vehicleImagePath)))) :
                Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(child:Column(crossAxisAlignment: CrossAxisAlignment.stretch,children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.file_upload,
                          color: Colors.cyan[900],
                          size: 50,
                          ),
                        onPressed: (){
                           Navigator.push(context,MaterialPageRoute(builder: (context) => TakePictureScreen(camera: widget.camera,ticket:widget.ticket,reason: '2',vehicle: Vehicle(licensePlate: widget.ticket.licensePlate))));
                        }
                        ),
                      SizedBox(height: 15.0),
                      Center(
                        child: Text('Upload Image of Vehicle'.toUpperCase(),style: TextStyle(
                              // color: Colors.black,
                              // fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontSize: 15.0,                        
                            )),
                      )
                    ],),),
                  ),
                ),
                SizedBox(height: 10.0),
                isDriverImage? Container(height:250,child: Center(child: Image.file(File(widget.ticket.driverImagePath)))) :
                Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(child:Column(crossAxisAlignment: CrossAxisAlignment.stretch,children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.file_upload,
                          color: Colors.cyan[900],
                          size: 60,
                          ),
                        onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => TakePictureScreen(camera:widget.camera,ticket:widget.ticket,reason: '3',driver: Driver(licenseNumber: widget.ticket.licenseNumber))));
                        }
                        ),
                      SizedBox(height: 15.0),
                      Center(
                        child: Text('Upload Image of License'.toUpperCase(),style: TextStyle(
                              letterSpacing: 2.0,
                              fontSize: 15.0,                        
                            )),
                      )
                    ],),),
                  ),
                ),
                SizedBox(height: 15.0),
                isValidate ? ValidateResult(filepath: filepath,ticketvalidate: validateticket,ticket: widget.ticket):Container() ,
                SizedBox(height: 5.0),
                isValidate ? Container() :ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.black,
                      child: Text(
                        'Validate Images',
                        style: TextStyle(color: Colors.white,fontSize: 15.0,),
                      ),
                      onPressed: () async{
                        if(isVehicleImage == false){
                            showModal('Upload the vehicle image for validation');
                          }
                          else if(isDriverImage == false){
                            showModal('Upload the driver image for validation');
                          }
                          else{
//                            print(time);
//                            // print(filepath);
////                            String licenseNumberLocation = await Storage().uploadDriverTicketImage(widget.ticket.driverImagePath,widget.ticket.licenseNumber,filepath);
////                            print(licenseNumberLocation);
////                            String licensePlateLocation = await Storage().uploadVehicleTicketImage( widget.ticket.vehicleImagePath, widget.ticket.licensePlate,filepath);
////                            print(licensePlateLocation);
//                             String licenseNumberLocation = 'Tickets/oepQFl1ByeM4MpR4dteACrcZYEx1:2020-05-11 14:31:30.830531/53388233bh.jpg';
//                             String licensePlateLocation = 'Tickets/oepQFl1ByeM4MpR4dteACrcZYEx1:2020-05-11 14:31:30.830531/KI-8407.jpg';
//                             print(licenseNumberLocation);
//                             print(licensePlateLocation);
//                           await callable.call(
//                             <String, dynamic>{
//                               'platefilePath':licensePlateLocation,
//                               'numberfilePath' : licenseNumberLocation,
//                               'uid' : filepath,
//                               'id' : userUID.uid
//                             },
//                           );
//                            setState(()=> isValidate = true);
                          }
                      }
                  )
                  ],
                ),
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
                        widget.ticket.vehicle = null;
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
                          if(widget.ticket.validatedTextScore != null && widget.ticket.validatedText !=null){
                            showModal('Validate Images to Continue Procedure');
                          }
                          else{
                            print(validateticket.licenseplate);
                            print(widget.ticket.licensePlate);
                            String checkMatchLicensePlate = widget.ticket.licensePlate.replaceAll('-', ' ');
                            print(checkMatchLicensePlate);
                            if(validateticket.licenseplate.contains(checkMatchLicensePlate)){
                              setState(() => loading = true);
                              List<Fine> fines = await CreateTicketNew().getSuitableFine(widget.ticket.vehicle);
                              print(fines);
                              setState(() => loading = false);
                              Navigator.push(context,MaterialPageRoute(builder: (context) => FineList(ticket: widget.ticket,
                                  fines: fines)));
                            }
                            else{
                              widget.ticket.status = 'cancelled';
                              showModal('The license plate image does not match with the form data entered. Cancelling ticket');
                            }
                         }
                        }
                    ),
                  ],
                ),
              ] 
            ),
          ),
        ),
      ),
    );
  }
}