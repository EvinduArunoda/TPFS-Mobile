import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:tpfs_policeman/services/firebaseStorage.dart';
import 'package:tpfs_policeman/services/pushNotification.dart';
import 'package:tpfs_policeman/views/home/Notification_list.dart';
import 'package:tpfs_policeman/views/home/finingProcedure.dart';
import 'package:tpfs_policeman/views/home/settings.dart';
import 'package:tpfs_policeman/views/profiles/profile.dart';

class HomePage extends StatefulWidget {
  CameraDescription camera;

  HomePage({this.camera});
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
    final DatabaseServicePolicemen policeUser = DatabaseServicePolicemen(uid: user.uid);

    void onTabTapped(int index) async{
      if(index == 2){
        userImage = await Storage().getUserImage(user.uid);
      }
    setState(() {
      _currentIndex = index;
    });
    }

    final List<Widget> _children = [
      Notificationlist(),
      Home(camera: widget.camera,policeUser: policeUser),
      NinjaCard(userImage: userImage)
  ];
  
    void showSettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return StreamProvider<UserLog>.value(
          value: policeUser.userLog,
            child: SingleChildScrollView(
              child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
              child: FittedBox(
                fit: BoxFit.fill,
                child: Settings()),
            ),
          ),
        );
      });
    }
  return StreamProvider<UserData>.value(
    value: policeUser.userData,
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title : Container(
          child: Text(
            'TPFS - Traffic Police',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 1.5,
              fontSize: 25,
              color: Colors.orange
            ),),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSettingsPanel();
            },
            icon: Icon(
              Icons.settings,
              size: 30.0,
              color: Colors.white, )),
             IconButton(
            onPressed: () async{
               await _auth.signOut();
            },
            icon: Icon(
              Icons.person_outline,
              size: 30.0,
              color: Colors.white, )),
          SizedBox(width: 5)
        ],
        backgroundColor: Colors.cyan[900],
        elevation: 10.0,
      ),
      body:  _children[_currentIndex],
       bottomNavigationBar: BottomNavigationBar(
         backgroundColor: Colors.cyan[900],
         selectedItemColor: Colors.orange,
         unselectedItemColor: Colors.white,
         onTap: onTabTapped, // new
         currentIndex: _currentIndex, // this will be set when a new tab is tapped
         items: [
           BottomNavigationBarItem(
             icon: new Icon(
               Icons.mail),
             title: new Text('MESSAGES',style: TextStyle(fontWeight: FontWeight.bold)),
           ),
            BottomNavigationBarItem(
             icon: new Icon(Icons.home),
             title: new Text('HOME',style: TextStyle(fontWeight: FontWeight.bold)),
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.person),
             title: Text('PROFILE',style: TextStyle(fontWeight: FontWeight.bold))
           )
         ],
       ),
      ),
    );
}
}

class Home extends StatelessWidget {
  CameraDescription camera;
  DatabaseServicePolicemen policeUser;
  Home({this.camera,this.policeUser});
  @override
  Widget build(BuildContext context) {
    return Container(
    child: SingleChildScrollView(
      child: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 70.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35.0,20.0,35.0,5.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: IconButton(
                        alignment: Alignment.center,
                        icon: Icon(
                          FontAwesomeIcons.ticketAlt,
                          color: Colors.cyan[900],
                          ),
                        iconSize: 200.0,
                        onPressed: null
                        ),
                    ),
                    SizedBox(height:10.0),
                    Text(
                      'CREATE NEW TICKET',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        fontSize: 23.0,
                      ),
                    ),
                    SizedBox(height:14.0),
                    Text(
                      'Click to start new spot fining procedure',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height:30.0),
                    FloatingActionButton.extended(
                      onPressed: ()async{
                        Ticket ticketNew = new Ticket(licenseNumber: null,licensePlate: null,vehicle: null,fineAmount: null,status: null);
                        await policeUser.updateNumOfProcedures();
                        Navigator.pushReplacement(context,MaterialPageRoute(settings: RouteSettings(name: "Process"),builder: (context) => FiningProcedure(ticket: ticketNew,camera: camera)));
                      },
                      label: Text('Begin procedure'),
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

