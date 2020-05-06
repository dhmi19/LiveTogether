import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/user.dart';
import 'package:lester_apartments/services/route_generator.dart';
import 'package:lester_apartments/screens/wrapper.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(

  MyApp()
  /*
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    )
   */
);

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user, //Listens to the Auth User stream to provide data to the rest of the widget tree
      child: MaterialApp(
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}