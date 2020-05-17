import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';

import 'ImportantNotesRow.dart';
import 'LeisureNotesRow.dart';
import 'ListsRow.dart';

class SharedNotesWidget extends StatefulWidget {

  final FirebaseUser currentUser;

  const SharedNotesWidget({this.currentUser});

  @override
  _SharedNotesWidgetState createState() => _SharedNotesWidgetState();
}

class _SharedNotesWidgetState extends State<SharedNotesWidget> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,

          title: Text("Shared Notes", style: TextStyle(color: Colors.black),),

          centerTitle: true,

        ),


        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Column(
              children: <Widget>[
                Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    height: 100,
                    width: 100,
                    child: Center(child: FaIcon(FontAwesomeIcons.listUl, color: Theme.of(context).colorScheme.onPrimary, size: 60,)),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      SizedBox(height: 20,),

                      Text("Important"),

                      ImportantNotesRow(),

                      SizedBox(height: 150,),

                      Text("Leisure"),

                      LeisureNotesRow(),

                      SizedBox(height: 150,),

                      Text("Lists"),

                      ListsRow(),

                    ],
                  ),
                ),

                /*TabBarView(
                  children: <Widget>[
                    Icon()
                  ],
                )

                 */
              ],
            ),
          )
        ),

        drawer: DrawerWidget()
    );
  }
}
