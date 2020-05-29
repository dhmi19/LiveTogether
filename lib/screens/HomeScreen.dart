import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/screens/homePage/HomeScreenWidget.dart';
import 'package:lester_apartments/screens/roommatesSceen/RoommatesWidget.dart';
import 'package:lester_apartments/screens/sharedNotesScreen/SharedNotesWidget.dart';
import 'package:lester_apartments/screens/shoppingListScreen/ShoppingListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'billsScreen/BillsScreenWidget.dart';

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

  int _currentIndex = 0;

  final tabs = [
    HomeScreenWidget(),
    ShoppingListWidget(),
    BillsScreenWidget(),
    SharedNotesWidget(),
    RoommatesWidget(),
  ];

  @override
  Widget build(BuildContext context) {

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
              icon: FaIcon(FontAwesomeIcons.home, size: 24),
              title: Text("Home"),
              backgroundColor: Theme.of(context).colorScheme.primary
          ),BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.shoppingCart, size: 24,),
              title: Text("Shopping List"),
              backgroundColor: Theme.of(context).colorScheme.primary
          ), BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.wallet, size: 24),
              title: Text("Bills"),
              backgroundColor: Theme.of(context).colorScheme.primary
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.list, size: 24),
              title: Text("Shared Notes"),
              backgroundColor: Theme.of(context).colorScheme.primary
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.users, size: 24),
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

