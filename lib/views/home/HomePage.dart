import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/notification.dart';
import 'package:tpfs_policeman/models/procedure.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:tpfs_policeman/services/firebaseStorage.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/home/Notification_list.dart';
import 'package:tpfs_policeman/views/home/finingProcedure.dart';
import 'package:tpfs_policeman/views/profiles/profile.dart';

class HomePage extends StatefulWidget {
  List<CameraDescription> camera;
  Storage storage;
  DatabaseServicePolicemen policeUser;

  HomePage({this.camera,Key key,@required this.storage,@required this.policeUser}) : super(key : key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  final AuthService _auth = AuthService();
  String userImage;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // final DatabaseServicePolicemen policeUser = DatabaseServicePolicemen(uid: user.uid);

    void showSignOutModal(){
      showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            key: Key('signoutModal'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Are you sure you want to sign out of TPFS",style: TextStyle(fontSize: 18),)
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                key: Key('signoutcontinuebutton'),
                child: Text('Continue',
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _auth.signOut();
                },
              ),
              FlatButton(
                key: Key('signoutcancelbutton'),
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

    void onTabTapped(int index) async{
      if(index == 2){
        userImage = await widget.storage.getUserImage(user.uid);
      }
    setState(() {
      _currentIndex = index;
    });
    }

    final List<Widget> _children = [
      StreamProvider<List<NotificationPresent>>.value(value:widget.policeUser.notificationPresent,child: Notificationlist(key: Key('NotificationList'),)),
      Home(camera: widget.camera,policeUser: widget.policeUser,key: Key('Home'),),
      NinjaCard(userImage: userImage,databaseServicePolicemen: widget.policeUser,key: Key('UserProfileTab'),authservice: AuthService())
  ];
  
    // void showSettingsPanel(){
    //   showModalBottomSheet(context: context, builder: (context){
    //     return StreamProvider<UserLog>.value(
    //       value: policeUser.userLog,
    //         child: SingleChildScrollView(
    //           child: Container(
    //           padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
    //           child: FittedBox(
    //             fit: BoxFit.fill,
    //             child: Settings()),
    //         ),
    //       ),
    //     );
    //   });
    // }
  return StreamProvider<UserData>.value(
    value: widget.policeUser.userData,
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        key: Key('HomeAppbar'),
        title : Container(
          child: Text(
            'Traffic Police'.toUpperCase(),
            key: Key('HomeApptext'),
            style:GoogleFonts.orbitron(
              textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: 23.0,
            ),),),
        ),
        actions: <Widget>[
          // IconButton(
          //   onPressed: () {
          //     showSettingsPanel();
          //   },
          //   icon: Icon(
          //     Icons.settings,
          //     size: 30.0,
          //     color: Colors.white, )),
             Padding(
               padding: const EdgeInsets.all(10.0),
               child: IconButton(
                 key: Key('SignoutButton'),
            onPressed: () async{
              showSignOutModal();
            },
            icon: Icon(
                Icons.person_outline,
                size: 30.0,
                color: Colors.white, )),
             ),
          SizedBox(width: 5)
        ],
        backgroundColor: Colors.cyan[900],
        elevation: 10.0,
      ),
      body:  _children[_currentIndex],
       bottomNavigationBar: BottomNavigationBar(
         key: Key('BottomNavigation'),
         backgroundColor: Colors.cyan[900],
         selectedItemColor: Colors.orange,
         unselectedItemColor: Colors.white,
         onTap: onTabTapped, // new
         currentIndex: _currentIndex, // this will be set when a new tab is tapped
         items: [
           BottomNavigationBarItem(
             icon: new Icon(
               Icons.mail),
             title: new Text('MESSAGES',style:GoogleFonts.patrickHand(textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,letterSpacing: 1.0))),
           ),
            BottomNavigationBarItem(
             icon: new Icon(Icons.home),
             title: new Text('HOME',style: GoogleFonts.patrickHand(textStyle:TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,letterSpacing: 1.0))),
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.person),
             title: Text('PROFILE',style: GoogleFonts.patrickHand(textStyle:TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,letterSpacing: 1.0)))
           )
         ],
       ),
      ),
    );
}
}

class Home extends StatefulWidget {
  List<CameraDescription> camera;
  DatabaseServicePolicemen policeUser;

  Home({this.camera, this.policeUser, Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool loading = false;

  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context) ?? UserData(employeeID: '',
        firstName: '',
        lastName: '',
        address: '',
        phoneNumber: '',
        mailID: '');

    return loading? LoadingAnother() : Container(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 70.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35.0, 20.0, 35.0, 5.0),
                child: Center(
                  child: Column(
                      key: Key('MainInfoHome'),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: IconButton(
                              key: Key('TicketIconHome'),
                              alignment: Alignment.center,
                              icon: Icon(
                                FontAwesomeIcons.ticketAlt,
                                color: Colors.cyan[900],
                              ),
                              iconSize: 200.0,
                              onPressed: null
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                            'CREATE NEW TICKET',
                            key: Key('CreateTicketText'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fjallaOne(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontSize: 23.0,
                              ),)
                        ),
                        SizedBox(height: 14.0),
                        Text(
                            'Click to start new spot fining procedure',
                            key: Key('StartProcedureText'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.specialElite(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                fontSize: 18.0,
                              ),)
                        ),
                        SizedBox(height: 30.0),
                        FloatingActionButton.extended(
                          key: Key('StartProcedureButton'),
                          onPressed: () async {
                            setState(() => loading = true);
                            Ticket ticketNew = new Ticket(licenseNumber: null,
                                licensePlate: null,
                                vehicle: null,
                                fineAmount: null,
                                status: null,
                                policemenemployeeID: userData.employeeID,
                                policemenstationID: userData.stationID);
                            ProcedurePolice procedureNew = new ProcedurePolice(
                                startTime: FieldValue.serverTimestamp(),
                                driverProfileSearched: null,
                                vehicleProfileSearched: null,
                                plateValidate: null,
                                ticket: null,
                                criminalAssessment: null,
                                ticketCreated: null,
                                employeeID: userData.employeeID);
                            DocumentReference id = await widget.policeUser
                                .createProcedure(procedureNew);
                            procedureNew.documentID = id;
//                        await policeUser.updateNumOfProcedures();
                            await Navigator.push(context, MaterialPageRoute(
                                settings: RouteSettings(name: "Process"),
                                builder: (context) =>
                                    FiningProcedure(key: Key('FineProcedure'),
                                        ticket: ticketNew,
                                        camera: widget.camera,
                                        procedure: procedureNew,
                                        policeUser: widget.policeUser,
                                        ticketCreation: CreateTicketNew())));
                            setState(() => loading = false);
                          },
                          label: Text('Begin procedure'.toUpperCase(),
                              style: GoogleFonts.bitter(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  fontSize: 19.0,
                                ),)),
                          icon: Icon(Icons.add_box),
                          backgroundColor: Colors.blueGrey,
                        )
                      ]
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

