import 'package:flutter/material.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/shared/constant.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/authenticate/resetPassword.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        elevation: 0.0,
        title: Text('Sign in to TPFS'),
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
                  SizedBox(height: 20.0),
                  TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    decoration: textInputDecoration.copyWith(labelText: 'Email'),
                    validator: (val) => val.isEmpty ? 'Enter an email address' : null,
                    onChanged: (val){
                      setState(() => email = val.trim());
                    },
                  ),
                  SizedBox(height: 30.0),
                  TextFormField(
                    autofocus: false,
                    decoration: textInputDecoration.copyWith(labelText: 'Password'),
                    validator: (val) => val.isEmpty ? 'Enter a password' : null,
                    onChanged: (val){
                      setState(() => password = val.trim());
                    },
                    obscureText: true,
                  ),
                  SizedBox(height: 15.0),
                  OutlineButton(
                    onPressed: (){
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ResetPassword()));
                    },
                    child: Text(
                    'Forget Password ?',
                    style: TextStyle(color: Colors.cyan[900] , fontSize: 16.0),
                  ),
                  ),
                  SizedBox(height: 15.0),
                  RaisedButton(
                    color: Colors.cyan[900],
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async{
                      if(_formkey.currentState.validate()){
                        setState(() => loading = true);
                        dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                        if(result == null){
                          setState(() => error = 'Could not sign in with those credentials');
                          setState(() => loading = false);
                        }
                      }
                    }
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red[900] , fontSize: 13.0),
                  )
                ] 
              ),
            ),
          ),
        ),
      ),
    );
  }
}