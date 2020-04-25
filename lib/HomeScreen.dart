import 'package:lester_apartments/ChoresListWidget.dart';
import 'package:lester_apartments/ShoppingListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';

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

  int _currentIndex = 0;

  final tabs = [
    ShoppingListWidget(),
    ChoresListWidget()
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: tabs[_currentIndex],

      bottomNavigationBar: GradientBottomNavigationBar(

        currentIndex: _currentIndex,
        backgroundColorStart: Colors.orange[400],
        backgroundColorEnd: Colors.orange[100],
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              title: Text("Shopping List"),
              backgroundColor: Colors.blueGrey
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind),
              title: Text("Chores List"),
              backgroundColor: Colors.blueGrey
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

