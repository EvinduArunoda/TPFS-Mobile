import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/views/authenticate/sign_in.dart';
import 'package:tpfs_policeman/views/home/HomePage.dart';

class CheckType extends StatefulWidget {
  @override
  _CheckTypeState createState() => _CheckTypeState();
}

class _CheckTypeState extends State<CheckType> {

  @override
 Widget build(BuildContext context) {
   
  final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Colors.cyan[900],
      body: Center(
        child: RaisedButton(
          hoverColor: Colors.red,
          elevation: 15.0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'TWO STEP AUTHENTICATION',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17.0),
            ),
          ),
          onPressed: () async{
            bool isPoliceMen = await AuthService().checkIfCorrectType(user);
            if(isPoliceMen){
               Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage()));
            }
            else{
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SignIn()));
            }
          
          }
        ),
      ),

      );
  }
}