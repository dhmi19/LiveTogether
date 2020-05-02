import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';

class ShoppingListWidget extends StatefulWidget {

  @override
  _ShoppingListWidgetState createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          colors: [
            Colors.greenAccent[400],
            Colors.greenAccent[200],
            Colors.greenAccent[100]
          ]
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,

          // FlatButton.icon(onPressed: () => {}, icon: Icon(Icons.menu), label: Text("")),
          title: Text("Shopping List", style: TextStyle(color: Colors.black),),

          centerTitle: true,

          actions: <Widget>[
            FlatButton.icon(onPressed: () async {
              await _auth.signOut();
            }, icon: Icon(Icons.exit_to_app), label: Text(""))
          ],
        ),


        body: SafeArea(
          child: Container(
            color: Colors.transparent,
          ),
        ),

        drawer: Drawer(

          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),

              ListTile(
                title: Text('View my Apartment'),
                trailing: Icon(Icons.people),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
