import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:provider/provider.dart';
import 'ProfileScreenWidget.dart';

class MyProfileScreen extends StatefulWidget {

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  @override
  Widget build(BuildContext context) {

    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: ProfileScreenWidget()
    );
  }
}
