import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/shared/constant.dart';
import 'package:tpfs_policeman/views/CA%20module/takePicture.dart';
import 'package:tpfs_policeman/views/home/HomePage.dart';
import 'package:tpfs_policeman/views/home/searchDriver.dart';
import 'package:tpfs_policeman/views/home/searchVehicle.dart';
import 'package:tpfs_policeman/views/tickets/createTicket.dart';

class FiningProcedure extends StatefulWidget {
  Ticket ticket;
  // UserData user;
  final AuthService auth;
  CameraDescription camera;
  num numOfTickets;
  num numOfTicketsSuccess;


  @override
  FiningProcedure({this.ticket,this.auth,this.camera});
  _FiningProcedureState createState() => _FiningProcedureState();
}

class _FiningProcedureState extends State<FiningProcedure> {
  // final AuthService _auth = AuthService();
  // int counter = DatabaseServicePolicemen();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final DatabaseServicePolicemen policeUser = DatabaseServicePolicemen(uid: user.uid);
    String licenseplate ='';
    String licenseNumber = '';
    String fineAmount = '';
    bool status=false;

    if(widget.ticket.licensePlate!=null){
      licenseplate = widget.ticket.licensePlate;
    }
    if(widget.ticket.licenseNumber!=null){
      licenseNumber = widget.ticket.licenseNumber;
    }
    if(widget.ticket.fineAmount!=null){
      fineAmount = '${widget.ticket.fineAmount}';
    }
    if(widget.ticket.status!=null){
      status = true;
    }

    return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title : Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            'TPFS - POLICEMEN',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 25,
            ),),
        ),
      ),
      backgroundColor: Colors.cyan[900],
      elevation: 10.0,
    ),
    // body: Brewlist(),
    body: 
    Container(
      child: Column(
        children: <Widget>[
//          SizedBox(height:20.0),
//          Text(
//            'SPOT FINING PROCEDURE',
//            style: TextStyle(
//              color: Colors.cyan[900],
//              fontWeight: FontWeight.bold,
//              fontFamily: 'Roboto',
//              letterSpacing: 0.5,
//              fontSize: 23,
//            ),
//            textAlign: TextAlign.start,
//          ),
          Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 0.0),
            child: GridView.count(

              crossAxisCount: 1,
              children: <Widget>[
                buildGridView(
                  'VEHICLE PROFILE',
                   Icons.directions_car,
                   fineAmount != ''? (){} : (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SearchVehicle(ticket: widget.ticket, camera: widget.camera)));
                   } ,licenseplate, '1'),
                buildGridView(
                  'DRIVER PROFILE',
                  Icons.person,
                  status? (){} : (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SearchDriver(ticket: widget.ticket,  camera: widget.camera)));
                  }, licenseNumber, '2'),
                buildGridView(
                  'CRIMINAL ASSESSMENT',
                  Icons.photo_camera,
                  status? (){} : (){Navigator.push(context,MaterialPageRoute(builder: (context) => TakePicture(camera: widget.camera)));
                  }, '' , '3'),
                buildGridView(
                  'CREATE TICKET',
                  Icons.subtitles,
                    status? (){} : ()async{
                    //  print(widget.ticket.licenseNumber);
                    //  print(widget.ticket.licensePlate);
                    Map<String,dynamic> dateAndTime = await CreateTicketNew().fillTicketForm();
                    //Map<String,String> dateAndTime = {'date': '12/12/2014', 'time' :'5:00pm'};
                    // print(widget.ticket.timestamp);
                    String location = await CreateTicketNew().getLocationData();
                    //String location = 'Colombo';
                    Navigator.push(context,MaterialPageRoute(settings: RouteSettings(name: "CreateTicket"),builder: (context) => CreateTicket(dateAndTime: dateAndTime,
                                                ticket: widget.ticket, location: location,camera: widget.camera)));
                  },fineAmount, '4'),
              ],
            ),
        ),
          ),
//            SizedBox(height:20.0)
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: (){
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage()));
      },
      label: Text('End procedure'),
      backgroundColor: Colors.blueGrey,
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//    persistentFooterButtons: <Widget>[
//
//      ButtonBar(
//        alignment: MainAxisAlignment.start,
//        children: <Widget>[
//          FloatingActionButton.extended(
//            onPressed: (){
//              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage()));
//            },
//            label: Text('End procedure'),
//            backgroundColor: Colors.blueGrey,
//          ),
//        ],
//      ),
//    ],
    // bottomNavigationBar: BottomAppBar(
    //   color: Colors.cyan[900],
    //   elevation: 10.0,
    //   child: Container(
    //     child: Row(
    //       mainAxisSize: MainAxisSize.max,
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: <Widget>[
    //         FlatButton.icon(
    //           onPressed: () {
    //              Navigator.push(context,MaterialPageRoute(builder: (context) => Notifications()));
    //           },
    //           icon: Icon(
    //             Icons.notifications,
    //             size: 30.0,
    //             color: Colors.white, ), 
    //           label: Text('')),
          //   new Stack(
          //   children: <Widget>[
          //     new IconButton(icon: Icon(Icons.notifications), onPressed: () {
          //       setState(() {
          //         counter = 0;
          //       });
          //       Navigator.push(context,MaterialPageRoute(builder: (context) => Notifications()));
          //     }),
          //     counter != 0 ? new Positioned(
          //       right: 11,
          //       top: 11,
          //       child: new Container(
          //         padding: EdgeInsets.all(2),
          //         decoration: new BoxDecoration(
          //           color: Colors.red,
          //           borderRadius: BorderRadius.circular(6),
          //         ),
          //         constraints: BoxConstraints(
          //           minWidth: 14,
          //           minHeight: 14,
          //         ),
          //         child: Text(
          //           '$counter',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 8,
          //           ),
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
          //     ) : new Container()
          //   ],
          // ),
      //       FlatButton.icon(
      //         onPressed: () async{
      //           await widget.auth.signOut();
      //         },
      //         icon: Icon(
      //           Icons.settings,
      //           size: 30.0,
      //           color: Colors.white, ), 
      //         label: Text('')),
      //       FlatButton.icon(
      //         icon: Icon(
      //           Icons.person,
      //           size: 30.0,
      //           color: Colors.white,),
      //         label: Text(''),
      //         onPressed: () async {
      //           widget.user = await policeUser.getUserProfile();
      //           showSettingsPanel();
      //           },
      //       )
      //     ],
      //   ),
      // ),     
      // ),
    );
}
}
