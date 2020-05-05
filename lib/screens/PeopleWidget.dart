import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';

class RommatesWidget extends StatefulWidget {
  @override
  _RommatesWidgetState createState() => _RommatesWidgetState();
}

class _RommatesWidgetState extends State<RommatesWidget> {

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
            title: Text("Roommates", style: TextStyle(color: Colors.black),),

            centerTitle: true,

          ),


          body: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 100,),

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(80)),
                      ),
                    ),
                  ),
                ],
              )
          ),

          drawer: DrawerWidget()
      ),
    );
  }
}
