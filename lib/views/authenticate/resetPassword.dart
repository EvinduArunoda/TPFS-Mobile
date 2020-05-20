import 'package:flutter/material.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/shared/constant.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/authenticate/sign_in.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String message = '';
  bool isMessage = false;
   bool isSuccess = true;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        elevation: 0.0,
        title: Text('Reset Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.only(top:80.0),
              child: Column(
                children: <Widget>[
                  isMessage? Container(
                    child: Column(children: <Widget>[
                        Center(
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red[900] , fontSize: 17.0),
                          ),
                        )
                    ],),
                  ):TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    decoration: textInputDecoration.copyWith(labelText: 'Email'),
                    validator: (val) => val.isEmpty ? 'Enter an email address' : null,
                    onChanged: (val){
                      setState(() => email = val.trim());
                    },
                  ),
                  SizedBox(height: 10.0),
                  isMessage?Container():RaisedButton(
                    color: Colors.cyan[900],
                    child: Text(
                      'Send Email',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async{
                      if(_formkey.currentState.validate()){
                        setState(() => loading = true);
                        isSuccess = await _auth.resetPassword(email);
                        if(isSuccess){
                          setState(() {
                           message = 'An email with reset password link has been sent';
                           isMessage = true;
                           loading = false;
                        });
                        }
                        else{
                          setState(() {
                            message = 'Account Not Found try again';
                            isSuccess = false;
                            loading = false;
                          });
                        }
                      }
                    }
                  ),
                  SizedBox(height: 5.0),
                  isSuccess? Container(): Container(
                    child: Column(children: <Widget>[
                        Center(
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red[900] , fontSize: 15.0),
                          ),
                        )
                    ],),
                  ),
                  SizedBox(height: 20.0),
                  OutlineButton(
                    child: Text(
                      'Return to SIGN IN ?',
                      style: TextStyle(color: Colors.cyan[900] , fontSize: 17.0),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SignIn()));
                    }
                  ),
                ] 
              ),
            ),
          ),
        ),
      ),
    );
  }
}