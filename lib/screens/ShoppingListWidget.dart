import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';

class ShoppingListWidget extends StatefulWidget {

  final FirebaseUser currentUser;

  const ShoppingListWidget({this.currentUser});

  @override
  _ShoppingListWidgetState createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,

          // FlatButton.icon(onPressed: () => {}, icon: Icon(Icons.menu), label: Text("")),
          title: Text("Shopping List", style: TextStyle(color: Colors.black),),

          centerTitle: true,

        ),


        body: SafeArea(
          child: Container(
            color: Colors.transparent,
          ),
        ),

        drawer: DrawerWidget()
      ),
    );
  }
}
