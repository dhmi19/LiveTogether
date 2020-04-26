import 'package:flutter/material.dart';
import 'package:lester_apartments/authentication/SignInScreen.dart';
import 'package:lester_apartments/authentication/RegisterScreen.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignInScreen(toggleView: toggleView);
    }else{
      return RegisterScreen(toggleView: toggleView);
    }
  }
}
