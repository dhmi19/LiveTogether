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
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        leading: Builder(
             builder: (BuildContext context) {
               return IconButton(
                 icon: const Icon(Icons.menu),
                 onPressed: () { Scaffold.of(context).openDrawer(); },
                 tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
               );
             },
           ),
        // FlatButton.icon(onPressed: () => {}, icon: Icon(Icons.menu), label: Text("")),
        title: Text("Shopping List"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton.icon(onPressed: () async {
            await _auth.signOut();
          }, icon: Icon(Icons.exit_to_app), label: Text(""))
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.redAccent,
                ),
                child: Text("Hi", textAlign: TextAlign.center,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
