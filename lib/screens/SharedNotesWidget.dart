import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';

class SharedNotesWidget extends StatefulWidget {
  @override
  _SharedNotesWidgetState createState() => _SharedNotesWidgetState();
}

class _SharedNotesWidgetState extends State<SharedNotesWidget> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.redAccent[400],
                Colors.redAccent[200],
                Colors.redAccent[100]
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
            title: Text("Shared Notes", style: TextStyle(color: Colors.black),),

            centerTitle: true,

            actions: <Widget>[
              FlatButton.icon(onPressed: () async {
                await _auth.signOut();
              }, icon: Icon(Icons.exit_to_app), label: Text(""))
            ],
          ),


          body: SafeArea(
            child: Container(child: Column(
              children: <Widget>[
                SizedBox(height: 100,),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(80)),
                    ),
                  ),
                ),
              ],
            )
            ),
          ),

          drawer: DrawerWidget()
      ),
    );
  }
}
