import 'package:flutter/material.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/shared/constant.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/authenticate/resetPassword.dart';

class EmailFieldValidator {
  static String validate(String val) {
    return val.isEmpty ? 'Enter an email address' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String val) {
    return val.isEmpty ? 'Enter a password' : null;
  }
}

class SignIn extends StatefulWidget {
  final AuthService auth;

  SignIn({Key key,this.auth}) : super(key:key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  // final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  Future<void> onSignInTapped() async{
    if(_formkey.currentState.validate()){
      setState(() => loading = true);
      dynamic result = await widget.auth.signInWithEmailAndPassword(email, password);
      if(result == null){
        setState(() => error = 'Could not sign in with those credentials');
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading(key: Key('Loading')) : Scaffold(
      key: Key('SignInAuthenticate'),
      backgroundColor: Colors.white,
      appBar: AppBar(
        key: Key('SignInAppbar'),
        backgroundColor: Colors.cyan[900],
        elevation: 0.0,
        title: Text('Sign in to TPFS',key: Key('SignInAppText'),),
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
                    key: Key('SignInEmail'),
                    maxLines: 1,
                    autofocus: false,
                    decoration: textInputDecoration.copyWith(labelText: 'Email'),
                    validator: EmailFieldValidator.validate,
                    onChanged: (val){
                      setState(() => email = val.trim());
                    },
                  ),
                  SizedBox(height: 30.0),
                  TextFormField(
                    key: Key('SignInPassword'),
                    autofocus: false,
                    decoration: textInputDecoration.copyWith(labelText: 'Password'),
                    validator: PasswordFieldValidator.validate,
                    onChanged: (val){
                      setState(() => password = val.trim());
                    },
                    obscureText: true,
                  ),
                  SizedBox(height: 15.0),
                  OutlineButton(
                    key: Key('ForgetPasswordButton'),
                    onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ResetPassword(key: Key('ResetPassword'),auth: widget.auth)));
                    },
                    child: Text(
                    'Forget Password ?',
                    style: TextStyle(color: Colors.cyan[900] , fontSize: 16.0),
                  ),
                  ),
                  SizedBox(height: 15.0),
                  RaisedButton(
                    key: Key('SignInButton'),
                    color: Colors.cyan[900],
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: ()async{
                      await onSignInTapped();
                    }
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    error,
                    key: Key('SignInErrorText'),
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