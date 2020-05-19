import 'package:lester_apartments/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/authentication/SignInScreen.dart';
import 'package:lester_apartments/authentication/RegisterScreen.dart';
import 'package:lester_apartments/screens/NewNoteScreen.dart';
import 'package:lester_apartments/screens/profileScreen/MyProfileScreen.dart';
import 'package:lester_apartments/screens/sharedNotesScreen/FolderNotesScreen.dart';
import 'package:lester_apartments/screens/sharedNotesScreen/FullNoteScreen.dart';
import 'package:lester_apartments/screens/wrapper.dart';

class RouteGenerator{

  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) =>  Wrapper());

      case '/IntroductionScreen':
        if(args is String){
          return MaterialPageRoute(builder: (_) => HomeScreen());
        }
        //if args is invalid
        return MaterialPageRoute(builder: (_) => SignInScreen());

      case '/SignInScreen':
        return MaterialPageRoute(builder: (_) => SignInScreen());

      case '/RegisterScreen':
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case '/MyProfileScreen':
        return MaterialPageRoute(builder: (_) => MyProfileScreen());

      case '/FolderNotesScreen':
        return MaterialPageRoute(builder: (_) => FolderNotesScreen(screenTitle: args.toString(),));

      case '/FullNoteScreen':
        return MaterialPageRoute(builder: (_) => FullNoteScreen(note: args,));

      case '/NewNoteScreen':
        return MaterialPageRoute(builder: (_) => NewNoteScreen());

      default: //If not route is found, go to Home
        return MaterialPageRoute(builder: (_) => Wrapper());
    }
  }
}
