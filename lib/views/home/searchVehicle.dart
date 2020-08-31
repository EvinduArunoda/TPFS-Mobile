import 'package:camera/camera.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/procedure.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:tpfs_policeman/services/db_vehicle.dart';
// import 'package:tpfs_policeman/shared/constant.dart';
// import 'package:tpfs_policeman/shared/loading.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:tpfs_policeman/models/vehicle.dart';
import 'package:tpfs_policeman/views/profiles/vehicleprofile.dart';

class SearchVehicle extends StatefulWidget {
  Ticket ticket; 
  CameraDescription camera;
  ProcedurePolice procedure;
  VehicleCollection vehicleCollection;
  SearchVehicle({this.ticket, this.camera,this.procedure,Key key,@required this.vehicleCollection}) : super(key:key);

  @override
  _SearchVehicleState createState() => _SearchVehicleState();
}

class _SearchVehicleState extends State<SearchVehicle> {
  // final SearchBarController<Vehicle> _searchBarController = SearchBarController();
  List<Vehicle> result;

  Future<List<Vehicle>> _getVehicle(String text) async {

    text = text.toUpperCase().trim();
    await Future.delayed(Duration(seconds: text.length == 7 ? 10 : 1));
    return result = await widget.vehicleCollection.searchLicensePlate(text);
  }

  @override
  Widget build(BuildContext context) {
//    final user = Provider.of<User>(context);
    return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      leading: BackButton(key: Key('goBackVehicle'),),
      key: Key('VehicleSearchAppbar'),
      title : Text(
        'License plate number : * KI-1234',
        key: Key('VehicleSearchApptext'),
        style:GoogleFonts.orbitron(
          textStyle: TextStyle(
          fontWeight: FontWeight.w800,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          fontSize: 14,
        )),),
      backgroundColor: Colors.cyan[900],
      elevation: 10.0,
    ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 0),
        child: SearchBar<Vehicle>(
          // key: Key('SearchBarVehicle'),
          icon: Icon(Icons.search,key: Key('SearchBarVehicle'),),
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _getVehicle,
          textStyle:GoogleFonts.fjallaOne(
            textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            letterSpacing: 2.5,
          )),
          searchBarStyle: SearchBarStyle(
            backgroundColor: Colors.blueGrey,
            padding:EdgeInsets.all(10.0),

          ),
          iconActiveColor: Colors.white,
          cancellationWidget: Text("Cancel",key:Key('CancelWidget'),style:GoogleFonts.orbitron(textStyle: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 0.7))),
          emptyWidget: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "No results Found".toUpperCase(),
              key: Key('NoResultsText'),
              textAlign: TextAlign.right,
               style:GoogleFonts.orbitron(
                 textStyle: TextStyle(color: Colors.red[900] , fontSize: 22.0,fontWeight: FontWeight.bold),
              )),
          ),
          header: Row(
            children: <Widget>[
            ],
          ),
          onCancelled: () {
          },
          crossAxisCount: 1,
          onItemFound:(Vehicle vehicle, int index) {
            return Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Container(
                key: Key('SearchResultTile'),
                decoration: new BoxDecoration(
                boxShadow:[ new BoxShadow(
                color: Colors.white30,
                blurRadius: 10.0,
              ),
                ]),
                child: Card(
                  elevation: 5.0,
                  color: Colors.white,
                  child: ListTile(
                    isThreeLine: true,
                    leading: FittedBox(
                      fit: BoxFit.fill,
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.cyan[900],
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            result[0].licensePlate,
                            style:GoogleFonts.chelseaMarket(
                              textStyle: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2.0,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold
                            )),
                            ),
                        ),
                      ),
                    ),
                    title: FittedBox(
                      fit: BoxFit.fill,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'INSURANCE NUMBER: ',
                            style:GoogleFonts.chelseaMarket(
                            textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2.0,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                            )),
                          ),
                          SizedBox(width: 15.0),
                          Text(
                            '${result[0].insuranceNumber}',
                                style:GoogleFonts.patrickHand(
                                textStyle: TextStyle(
                                  color: Colors.cyan[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                  letterSpacing: 2.0,
                                )),
                          ),
                        ],
                      ),
                    ),
                    subtitle: FittedBox(
                      fit: BoxFit.cover,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(height: 13.0),
                                Text(
                                  'MAKE AND MODEL : ',
                                  style:GoogleFonts.chelseaMarket(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 2.0,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold
                                  )),
                                ),
                                SizedBox(width: 15.0),
                                Text(
                                  result[0].makeAndModel.toUpperCase(),
                                  style:GoogleFonts.patrickHand(
                                  textStyle: TextStyle(
                                    color: Colors.cyan[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                    letterSpacing: 2.0,
                                  )),
                                ),
                              ],
                            ),
                            SizedBox(height: 13.0),
                            Row(
                              children: <Widget>[
                                Text(
                                  'REGISTERED OWNER: ',
                                  style:GoogleFonts.chelseaMarket(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 2.0,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold
                                  )),
                                ),
                                SizedBox(width: 15.0),
                                Text(
                                  '${result[0].regOwner}'.toUpperCase(),
                                      style:GoogleFonts.patrickHand(
                                      textStyle: TextStyle(
                                        color: Colors.cyan[900],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                        letterSpacing: 2.0,
                                      )),
                                ),
                              ],
                            ),
                          ]
                      ),
                    ),
                    onTap: () async{
//                      await DatabaseServicePolicemen(uid: user.uid).updateNumOfVehicleProfiles();
                        widget.procedure.vehicleProfileSearched = result[0].licensePlate;
                      // print(widget.ticket.licensePlate);
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NinjaCardV(ticket: widget.ticket, vehicle: result[0],camera: widget.camera,key: Key('vehicleresult'),),
                      ),
                    );
                    },
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
