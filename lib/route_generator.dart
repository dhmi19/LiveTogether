import 'package:lester_apartments/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/main.dart';

class RouteGenerator{

  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/IntroductionScreen':
        if(args is String){
          return MaterialPageRoute(builder: (_) => HomeScreen(userName: args));
        }
        //if args is invalid
        return MaterialPageRoute(builder: (_) => LoginPage());

      default: //If not route is found, go to login
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
