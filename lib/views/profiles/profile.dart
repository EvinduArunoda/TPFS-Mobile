import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:tpfs_policeman/shared/constant.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/authenticate/sign_in.dart';

class AddressFieldValidator {
  static String validate(String val) {
    return val.isEmpty ? 'Enter address' : null;
  }
}

class PhoneNumberFieldValidator {
  static String validate(String val) {
    return val.isEmpty || val.length != 10? 'Enter valid phone number' : null;
  }
}

class EmailAddressFieldValidator {
  static String validate(String val) {
    return val.isEmpty ? 'Enter email address' : null;
  }
}

class NinjaCard extends StatefulWidget {
   String userImage;
   DatabaseServicePolicemen databaseServicePolicemen;
   AuthService authservice;

   NinjaCard({@required this.userImage,@required this.databaseServicePolicemen,Key key,@required this.authservice}) : super(key:key);
  @override
  _NinjaCardState createState() => _NinjaCardState();
}

class _NinjaCardState extends State<NinjaCard> {
  bool isEdit = false;
  final _formkey = GlobalKey<FormState>();
  String phoneNumber;
  String email;
  String address;
  bool changePassword = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context)??UserData(employeeID: '',firstName: '',lastName: '',address: '',phoneNumber: '',mailID: '');
    bool loading = false;

    return loading ? LoadingAnother() : SingleChildScrollView(
      child: changePassword? Container(
        key: Key('HasChangePassword'),
        child:Column(
          children: <Widget>[
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Container(
                child: Text(
                  'An email with reset password link has been sent to the registered email address for this account',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[900] , fontSize: 18.0),
                ),
              ),
            ),
            OutlineButton(
              key: Key('ReturnProfileButton'),
              child: Text(
                'Return to Profile',
                style: TextStyle(color: Colors.cyan[900] , fontSize: 17.0),
              ),
              onPressed: () {
                setState(()=>changePassword = false);
              }
            )
          ],
        ),
      ):Container(
        key: Key('NotChangePassword'),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                key: Key('PolicemenImage'),
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage: NetworkImage(widget.userImage),
                ),
              ),
              Divider(
                color: Colors.grey[800],
                height: 40.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'ID-NUMBER : ',
                    style:GoogleFonts.specialElite(
                        textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 18.0,
                    )),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    user.employeeID,
                    style:GoogleFonts.rambla(
                        textStyle: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                    )),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'NIC NUMBER ',
                    style:GoogleFonts.specialElite(
                        textStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 18.0,
                    )),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: Text(
                    '${user.nicnumber}',
                      style:GoogleFonts.rambla(
                        textStyle: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                      )),
                    ),
                  ), 
                ],
              ),
              SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'NAME : ',
                    style: GoogleFonts.specialElite(
                        textStyle:TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 18.0,
                    )),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: Text(
                    '${user.firstName} ${user.lastName}',
                      style:GoogleFonts.rambla(
                        textStyle: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        letterSpacing: 2.0,
                      )),
                    ),
                  ), 
                ],
              ),
              SizedBox(height: 10.0),
              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'ADDRESS : ',
                      style: GoogleFonts.specialElite(
                        textStyle:TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 18.0,
                      )),
                    ),
                SizedBox(height: 5.0),
                Container(
                  child: isEdit? TextFormField(
                  key: Key('userAddress'),
                  autofocus: false,
                  decoration: textInputDecoration.copyWith(),
                  validator: AddressFieldValidator.validate,
                  onChanged: (val){
                    setState(() => address = val.trim());;
                  },
                  initialValue: '${user.address}',
                ): Container(
                    key: Key('HasUserAddress'),
                    width:MediaQuery.of(context).size.width*0.6 ,
                  child: Text(
                      user.address,
                      style:GoogleFonts.rambla(
                        textStyle: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                      )),
                    ),
                ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'PHONE NUMBER',
                  style:GoogleFonts.specialElite(
                    textStyle: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontSize: 18.0,
                  )),
                ),
                SizedBox(height: 5.0),
                Container(
                  child: isEdit? TextFormField(
                    key: Key('PhoneNumber'),
                    autofocus: false,
                    decoration: textInputDecoration.copyWith(),
                    validator: PhoneNumberFieldValidator.validate,
                    onChanged: (val){
                      setState(() => phoneNumber = val.trim());
                    },
                    initialValue: '${user.phoneNumber}',
                  ) :Text(
                    '${user.phoneNumber}',
                    key: Key('HasUserNumber'),
                    style:GoogleFonts.rambla(
                      textStyle: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                    )),
                  ),
                ),
                SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'POLICESTATION ID: ',
                      style:GoogleFonts.specialElite(
                        textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 18.0,
                      )),
                    ),
                    SizedBox(width: 5.0),
                    Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      child: Text(
                        '${user.stationID}',
                        style:GoogleFonts.rambla(
                        textStyle: TextStyle(
                          color: Colors.cyan[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          letterSpacing: 2.0,
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Container(
                  child: isEdit? TextFormField(
                    key: Key('emailAddress'),
                  autofocus: false,
                  decoration: textInputDecoration.copyWith(),
                  validator: EmailAddressFieldValidator.validate,
                  onChanged: (val){
                     setState(() => email = val.trim());
                  },
                  initialValue: '${user.mailID}',
                ) : Row(
                  key: Key('Useremail'),
                    children: <Widget>[
                      Icon(
                        Icons.email,
                        color: Colors.cyan[900],
                      ),
                      SizedBox(width: 10.0),
                      Flexible(
                        child: Text(
                        user.mailID,
                          style:GoogleFonts.rambla(
                          textStyle: TextStyle(
                            color: Colors.cyan[900],
                            fontSize: 20.0,
                            letterSpacing: 1.0,
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                ButtonBar(
                  children: <Widget>[
                    isEdit? Container(key: Key('noreset'),) : FloatingActionButton.extended(
                      key: Key('hasreset'),
                    onPressed: ()async{
                      setState(() => loading = true);
                      await widget.authservice.resetPassword(user.mailID);
                      setState(() => changePassword = true);
                      setState(() => loading = false);
                    },
                    label: Text('Change Password',style:GoogleFonts.bitter()),
                    backgroundColor: Colors.cyan[900],
                  ),
                isEdit? FloatingActionButton(
                  key: Key('editprofile'),
                  onPressed: (){
                    if(_formkey.currentState.validate()){
                      // num mobileNumber;
                      // if(phoneNumber != null){
                      //   mobileNumber = int.parse(phoneNumber);
                      // }
                      // setState(() => loading = true);
                      widget.databaseServicePolicemen.updateUserData(
                        phoneNumber: phoneNumber ?? user.phoneNumber,
                        address: address ?? user.address,
                        email: email ?? user.mailID
                        );
                      setState(() => isEdit = false);
                    }
                  },
                   child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                  children : <Widget>[
                    Icon(
                      Icons.save,
                      color: Colors.white,
                      size: 25.0,
                      ),
                  ]
                    ),
                ),
                  backgroundColor: Colors.cyan[900],
                ) : FloatingActionButton(
                  key: Key('viewprofile'),
                  onPressed: (){
                    setState(() => isEdit = true);
                  },
                   child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                  children : <Widget>[
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 25.0,
                      ),
                  ]
                    ),
                ),
                  backgroundColor: Colors.cyan[900],
                ),
                  ], 
                )
                  ],
                ),
              ),
              ],),
        ),
      ),
    );
  }
}