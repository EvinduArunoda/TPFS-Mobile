import 'package:camera/camera.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/driver.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/db_driver.dart';
// import 'package:tpfs_policeman/shared/constant.dart';
// import 'package:tpfs_policeman/shared/loading.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:tpfs_policeman/services/firebaseStorage.dart';
import 'package:tpfs_policeman/views/profiles/driverprofile.dart';

class SearchDriver extends StatefulWidget {
  Ticket ticket ; 
  CameraDescription camera;

  SearchDriver({this.ticket, this.camera});
  

  @override
  _SearchDriverState createState() => _SearchDriverState();
}

class _SearchDriverState extends State<SearchDriver> {
  // final SearchBarController<Vehicle> _searchBarController = SearchBarController();
  List<Driver> result;

  Future<List<Driver>> _getDriver(String text) async {

    text = text.toLowerCase().trim();
    await Future.delayed(Duration(seconds: text.length == 7 ? 10 : 1));
    result = await DriverCollection().searchLicensePlate(text);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title : Text(
        'License Number',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          fontSize: 25,
        ),),
      backgroundColor: Colors.cyan[900],
      elevation: 10.0,
    ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 0),
        child: SearchBar<Driver>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _getDriver,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            letterSpacing: 2.0,
          ),
          searchBarStyle: SearchBarStyle(
            backgroundColor: Colors.blueGrey,
            padding:EdgeInsets.all(10.0),

          ),
          iconActiveColor: Colors.white,
          cancellationWidget: Container(
            padding: EdgeInsets.all(7.0),
            child: Text(
              "Cancel"
              ),
          ),
          emptyWidget: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "No results Found",
              textAlign: TextAlign.right,
               style: TextStyle(color: Colors.red[900] , fontSize: 18.0,fontWeight: FontWeight.bold),
              ),
          ),
          header: Row(
            children: <Widget>[
            ],
          ),
          onCancelled: () {
          },
          crossAxisCount: 1,
          onItemFound:(Driver vehicle, int index) {
            return Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Container(
                decoration: new BoxDecoration(
                boxShadow:[ new BoxShadow(
                color: Colors.white30,
                blurRadius: 10.0,
              ),
                ]),
                child: Card(
                  elevation: 5.0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: ListTile(
                      isThreeLine: true,
                      leading: FittedBox(
                        fit: BoxFit.fill,
                        child: CircleAvatar(
                          radius: 60.0,
                          //backgroundImage: AssetImage('assets/krish.jpg'),
                          backgroundColor: Colors.cyan[900],
                            child: Icon(
                              Icons.person,
                              size: 80.0,
                              color: Colors.white, )
                            ),
                      ),
                      title: FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                            children: <Widget>[
                              Text(
                                'License Number : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                result[0].licenseNumber,
                                style: TextStyle(
                                  color: Colors.cyan[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                      ),
                      subtitle: FittedBox(
                        fit: BoxFit.contain,
                        child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Name : ',
                              style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              result[0].name,
                              style: TextStyle(
                                color: Colors.cyan[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                          Row(
                          children: <Widget>[
                            Text(
                              'NIC Number : ',
                              style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              '${result[0].nicnumber}',
                              style: TextStyle(
                                color: Colors.cyan[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                      ]
                    ),
                ),
                      ),
                      onTap: () async{
                      await DatabaseServicePolicemen(uid: user.uid).updateNumOfDriverProfiles();
                       String driverImage = await Storage().getDriverImage(result[0].licenseNumber);
                       Navigator.push(context, MaterialPageRoute(builder: (context) => NinjaCardD(ticket: widget.ticket,driver: result[0],driverImage: driverImage
                                  ,camera: widget.camera),
                        ),
                      );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
