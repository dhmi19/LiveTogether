import 'package:firebase_auth/firebase_auth.dart';
import 'package:lester_apartments/screens/homePage/HomeScreenWidget.dart';
import 'package:lester_apartments/screens/roommatesSceen/RoommatesWidget.dart';
import 'package:lester_apartments/screens/SharedNotesWidget.dart';
import 'package:lester_apartments/screens/shoppingListScreen/ShoppingListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AlertWidget.dart';

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    )
);

class HomeScreen extends StatefulWidget{

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>{

  int _currentIndex = 2;

  static FirebaseUser currentUser;

  final tabs = [
    ShoppingListWidget(currentUser: currentUser),
    SharedNotesWidget(currentUser: currentUser),
    HomeScreenWidget(currentUser: currentUser),
    AlertWidget(currentUser: currentUser),
    RommatesWidget(currentUser: currentUser),
  ];

  @override
  Widget build(BuildContext context) {

    currentUser = Provider.of<FirebaseUser>(context);
    print("At homescreen, the current user is: " + currentUser.toString());

    return Scaffold(
      body: tabs[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primaryVariant),
        unselectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondaryVariant),
        selectedItemColor: Theme.of(context).colorScheme.primaryVariant,
        type: BottomNavigationBarType.shifting,
        backgroundColor: Colors.transparent,
        currentIndex: _currentIndex,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              title: Text("Shopping List"),
              backgroundColor: Theme.of(context).colorScheme.primary
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text("Shared Notes"),
              backgroundColor: Theme.of(context).colorScheme.primary
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              backgroundColor: Theme.of(context).colorScheme.primary
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              title: Text("Alerts"),
              backgroundColor: Theme.of(context).colorScheme.primary
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text("Roommates"),
              backgroundColor: Theme.of(context).colorScheme.primary
          ),

        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

}

