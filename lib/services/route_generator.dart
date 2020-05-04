import 'package:lester_apartments/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/authentication/SignInScreen.dart';
import 'package:lester_apartments/authentication/RegisterScreen.dart';
import 'package:lester_apartments/screens/MyProfileScreen.dart';
import 'package:lester_apartments/screens/wrapper.dart';

class RouteGenerator{

  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    print(settings.name);

    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) =>  Wrapper());

      case '/IntroductionScreen':
        if(args is String){
          return MaterialPageRoute(builder: (_) => HomeScreen(userName: args));
        }
        //if args is invalid
        return MaterialPageRoute(builder: (_) => SignInScreen());

      case '/SignInScreen':
        return MaterialPageRoute(builder: (_) => SignInScreen());

      case '/RegisterScreen':
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case '/MyProfileScreen':
        return MaterialPageRoute(builder: (_) => MyProfileScreen());

      default: //If not route is found, go to login
        return MaterialPageRoute(builder: (_) => SignInScreen());
    }
  }
}
