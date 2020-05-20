import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:tpfs_policeman/shared/constant.dart';

class NinjaCard extends StatefulWidget {
   String userImage;

   NinjaCard({@required this.userImage});
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
    final user = Provider.of<UserData>(context)??UserData(employeeID: '',firstName: '',lastName: '',address: '',phoneNumber: 0,mailID: '');

    return SingleChildScrollView(
      child: changePassword? Container(
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
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
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    user.employeeID,
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'NIC NUMBER ',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: Text(
                    '${user.nicnumber}',
                      style: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
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
                    'NAME : ',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: Text(
                    '${user.firstName} ${user.lastName}',
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
              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'ADDRESS : ',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 15.0,
                      ),
                    ),
                SizedBox(height: 5.0),
                Container(
                  child: isEdit? TextFormField(
                  autofocus: false,
                  decoration: textInputDecoration.copyWith(),
                  validator: (val) => val.isEmpty ? 'Enter address' : null,
                  onChanged: (val){
                    setState(() => address = val.trim());;
                  },
                  initialValue: '${user.address}',
                ): Container(
                    width:MediaQuery.of(context).size.width*0.5 ,
                  child: Text(
                      user.address,
                      style: TextStyle(
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                ),
                ),
                SizedBox(height: 15.0),
                Text(
                  'PHONE NUMBER',
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  child: isEdit? TextFormField(
                    autofocus: false,
                    decoration: textInputDecoration.copyWith(),
                    validator: (val) => val.isEmpty || val.length < 10? 'Enter valid phone number' : null,
                    onChanged: (val){
                      setState(() => phoneNumber = val.trim());
                    },
                    initialValue: '${user.phoneNumber}',
                  ) :Text(
                    '${user.phoneNumber}',
                    style: TextStyle(
                      color: Colors.cyan[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'POLICESTATION : ',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      child: Text(
                        'B2 : Colombo',
                        style: TextStyle(
                          color: Colors.cyan[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Container(
                  child: isEdit? TextFormField(
                  autofocus: false,
                  decoration: textInputDecoration.copyWith(),
                  validator: (val) => val.isEmpty ? 'Enter email address' : null,
                  onChanged: (val){
                     setState(() => email = val.trim());
                  },
                  initialValue: '${user.mailID}',
                ) : Row(
                    children: <Widget>[
                      Icon(
                        Icons.email,
                        color: Colors.cyan[900],
                      ),
                      SizedBox(width: 10.0),
                      Flexible(
                        child: Text(
                        user.mailID,
                          style: TextStyle(
                            color: Colors.cyan[900],
                            fontSize: 20.0,
                            letterSpacing: 1.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                ButtonBar(
                  children: <Widget>[
                    isEdit? Container() : FloatingActionButton.extended(
                    onPressed: ()async{
                      await AuthService().resetPassword(user.mailID);
                      setState(() => changePassword = true);
                    },
                    label: Text('Change Password'),
                    backgroundColor: Colors.cyan[900],
                  ),
                isEdit? FloatingActionButton(
                  onPressed: (){
                    if(_formkey.currentState.validate()){
                      num mobileNumber;
                      if(phoneNumber != null){
                        mobileNumber = int.parse(phoneNumber);
                      }
                      // setState(() => loading = true);
                      DatabaseServicePolicemen(uid: user.userid).updateUserData(
                        phoneNumber: mobileNumber ?? user.phoneNumber,
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