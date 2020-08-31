import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/procedure.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/services/db_vehicle.dart';
import 'package:tpfs_policeman/shared/constant.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/CA%20module/takePicture.dart';
import 'package:tpfs_policeman/views/home/searchDriver.dart';
import 'package:tpfs_policeman/views/home/searchVehicle.dart';
import 'package:tpfs_policeman/views/tickets/createTicket.dart';

class FiningProcedure extends StatefulWidget {
  Ticket ticket;
  ProcedurePolice procedure;
  // final AuthService auth;
  List<CameraDescription> camera;
  num numOfTickets;
  num numOfTicketsSuccess;
  // UserData userdata;
  DatabaseServicePolicemen policeUser;
  CreateTicketNew ticketCreation;


  @override
  FiningProcedure({this.ticket,this.camera,this.procedure,Key key,@required this.policeUser,@required this.ticketCreation}) : super(key : key);
  _FiningProcedureState createState() => _FiningProcedureState();
}

class _FiningProcedureState extends State<FiningProcedure> {
  // final AuthService _auth = AuthService();
  // int counter = DatabaseServicePolicemen();
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    // final DatabaseServicePolicemen policeUser = DatabaseServicePolicemen(uid: user.uid);
    String licenseplate ='';
    String licenseNumber = '';
//    String fineAmount = '';
    bool vehicleProfileSearched = false;
    bool driverProfileSearched = false;
    bool status=false;
    bool loading = false;
    String statusName = '';

    if(widget.ticket.licensePlate!=null){
      licenseplate = widget.ticket.licensePlate;
    }
    if(widget.ticket.licenseNumber!=null){
      licenseNumber = widget.ticket.licenseNumber;
    }
    if(widget.procedure.driverProfileSearched !=null){
      driverProfileSearched = true;
    }
    if(widget.procedure.vehicleProfileSearched != null){
      vehicleProfileSearched = true;
    }
    if(widget.ticket.status!=null){
      statusName = widget.ticket.status;
      status = true;
    }

    return loading ? LoadingAnother() : Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      key: Key('ProcedureAppBar'),
      automaticallyImplyLeading: false,
      title : Center(
        child: Text(
          'TPFS - POLICEMEN',
          key: Key('ProcedureAppText'),
          textAlign: TextAlign.center,
          style: GoogleFonts.orbitron(
            textStyle:TextStyle(
            fontWeight: FontWeight.w800,
            fontFamily: 'Roboto',
            letterSpacing: 1.0,
            fontSize: 26,
          )),),
      ),
      backgroundColor: Colors.cyan[900],
      elevation: 10.0,
    ),
    // body: Brewlist(),
    body: 
    Container(
      child: Column(
        key: Key('ProcedureSteps'),
        children: <Widget>[
          Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 0.0),
            child: GridView.count(
              key: Key('ProcedureGrids'),
              crossAxisCount: 1,
              children: <Widget>[
                buildGridView(
                  'VEHICLE PROFILE',
                   Icons.directions_car,
                    (vehicleProfileSearched || status) ? (){} : (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SearchVehicle(ticket: widget.ticket, camera: widget.camera.first,procedure: widget.procedure,
                                                                                              key: Key('SearchVehicle'),vehicleCollection: VehicleCollection(),)));
                   } ,licenseplate, '1',Key('VehcileProfile')),
                buildGridView(
                  'DRIVER PROFILE',
                  Icons.person,
                    (driverProfileSearched || status) ? (){} : (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SearchDriver(ticket: widget.ticket,  camera: widget.camera.first,procedure: widget.procedure,
                                                                                      key: Key('SearchDriver'),)));
                  }, licenseNumber, '2',Key('DriverProfile')),
                buildGridView(
                  'CRIMINAL ASSESSMENT',
                  Icons.photo_camera,
                  status? (){} : (){Navigator.push(context,MaterialPageRoute(builder: (context) => TakePicture(camera: widget.camera.last,procedure: widget.procedure,
                                                                                                key: Key('TakePicture'),)));
                  }, '' , '3',Key('CA')),
                buildGridView(
                  'CREATE TICKET',
                  Icons.subtitles,
                    status? (){} : ()async{
                    setState(()=> loading = true);
                    //  print(widget.ticket.licenseNumber);
                    //  print(widget.ticket.licensePlate);
                    Map<String,dynamic> dateAndTime = await widget.ticketCreation.fillTicketForm();
                    //Map<String,String> dateAndTime = {'date': '12/12/2014', 'time' :'5:00pm'};
                    // print(widget.ticket.timestamp);
                    String location = await widget.ticketCreation.getLocationData();
                    //String location = 'Colombo';
                    await Navigator.push(context,MaterialPageRoute(settings: RouteSettings(name: "CreateTicket"),builder: (context) => CreateTicket(dateAndTime: dateAndTime,
                                                ticket: widget.ticket, location: location,camera: widget.camera.first,procedure: widget.procedure,key: Key('CreateTicketPage'),)));
                    setState(()=> loading = false);
                    },statusName.toUpperCase(), '4',Key('TicketCreation')),
              ],
            ),
        ),
          ),
//            SizedBox(height:20.0)
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      key: Key('EndProcedureButton'),
      onPressed: ()async{
        widget.procedure.endTime = FieldValue.serverTimestamp();
        await widget.policeUser.updateProcedureCreated(widget.procedure);
        Navigator.pop(context);
      },
      label: Text('End procedure'.toUpperCase(),
      style:GoogleFonts.bitter(
        textStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.0,
        fontSize: 20.0,
      ),)),
      backgroundColor: Colors.blueGrey,
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
}
}
