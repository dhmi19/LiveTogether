import 'package:lester_apartments/screens/HomeScreenWidget.dart';
import 'package:lester_apartments/screens/PeopleWidget.dart';
import 'package:lester_apartments/screens/SharedNotesWidget.dart';
import 'package:lester_apartments/screens/ShoppingListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AlertWidget.dart';

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    )
);

class HomeScreen extends StatefulWidget{

  final String userName;
  HomeScreen({@required this.userName});

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen>{

  int _currentIndex = 1;

  final tabs = [
    ShoppingListWidget(),
    SharedNotesWidget(),
    HomeScreenWidget(),
    AlertWidget(),
    PeopleWidget()
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: tabs[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Colors.black),
        unselectedIconTheme: IconThemeData(color: Colors.red),
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        backgroundColor: Colors.transparent,
        currentIndex: _currentIndex,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              title: Text("Shopping List"),
              backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text("Shared Notes"),
              backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              title: Text("Alerts"),
              backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text("Roommates"),
              backgroundColor: Colors.white
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

