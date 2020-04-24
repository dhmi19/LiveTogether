import 'package:firebase_auth/firebase_auth.dart';
import 'package:lester_apartments/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  //Create User object given a firebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    if(user != null){
      return User(uid: user.uid);
    }else{
      return null;
    }
  }

  //Sign in anonymously
  Future signInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(error){
      print(error.toString());
      return null;
    }
  }


  //Sign in with email and password

  // register with email and password

  // sign out


}