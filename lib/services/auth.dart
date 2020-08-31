import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


User _userFromFirebaseUser(FirebaseUser user){
  return user != null ? User(uid : user.uid) : null;
}

Stream<User> get user {
  return _auth.onAuthStateChanged
      .map(_userFromFirebaseUser);
}

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      FirebaseUser user = result.user;
        return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // Future<bool> checkIfCorrectType(User user) async{
  //    DocumentSnapshot userPresent = await Firestore.instance.collection('PoliceMen').document(user.uid).get();
  //     if(userPresent.data != null){
  //       return true;
  //     }
  //     else{
  //       return false;
  //     }
  // }

  Future<bool> resetPassword(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    }catch(e){
       print(e.toString());
       return false;
      }
    }
    

  // sign out
  Future signOut() async {
    try{
       await _auth.signOut();
      //  _auth.currentUser();

    } catch(e){
      print(e.toString());
       return null;

    }
  }

  

}