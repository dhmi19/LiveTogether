import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/user.dart';
import 'package:lester_apartments/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';


  //Create User object given a firebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    if(user != null){
      return User(uid: user.uid);
    }else{
      return null;
    }
  }


  // auth change user stream
  // Gets a FirebaseUser from the stream and then converts it to a custom User
  Stream<User> get user{
    return _auth.onAuthStateChanged.map((FirebaseUser user) => _userFromFirebaseUser(user));
  }



  //Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{

      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(error){
      print(error.toString());
      return null;
    }
  }


  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try{

      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      await user.sendEmailVerification();

      //Create a new document for the registered user:
      await DatabaseService(uid: user.uid).updateUserData(user.email, "hi", "username1", "apartment1");

      return _userFromFirebaseUser(user);
    }catch(error){
      print(error.toString());
      return null;
    }
  }

  // sign  out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(error){
      print("Not able to sign out");
      print(error.toString());
      return null;
    }
  }

  //Reset password:
  Future resetPassword(String email, BuildContext context) async{
    await _auth.sendPasswordResetEmail(email: email);
    showDialog(
      context: context,
        child: AlertDialog(
          title: Text("Email Sent!"),
          content: Text("Please follow the link sent to "+ email),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

}