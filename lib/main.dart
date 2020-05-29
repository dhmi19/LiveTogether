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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          hintColor: Color.fromRGBO(62, 61, 62, 1.0),
          colorScheme: ColorScheme(
            primary: Color.fromRGBO(240, 239, 239, 1.0),
            secondary: Color.fromRGBO(212, 96, 32, 1.0),
            primaryVariant: Color.fromRGBO(62, 61, 62, 1.0),
            secondaryVariant: Color.fromRGBO(216, 137, 84, 1.0),
            surface: Color.fromRGBO(151, 153, 155, 1.0),
            background: Color.fromRGBO(240, 239, 239, 1.0),
            error: Color.fromRGBO(212, 96, 32, 1.0),
            onPrimary: Color.fromRGBO(240, 239, 239, 1.0),
            onSecondary: Color.fromRGBO(216, 137, 84, 0.8),
            onSurface: Color.fromRGBO(151, 153, 155, 1.0),
            onBackground: Color.fromRGBO(151, 153, 155, 0.25),
            onError: Color.fromRGBO(151, 153, 155, 1.0),
            brightness: Brightness.light
          )
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
