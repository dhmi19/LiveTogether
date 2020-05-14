import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:lester_apartments/screens/roommatesSceen/AddRoommateWidget.dart';
import 'package:lester_apartments/screens/roommatesSceen/NewApartmentWidget.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/services/database.dart';
import 'package:provider/provider.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';

import 'ApartmentNameTitle.dart';
import 'RoommateList.dart';

class RommatesWidget extends StatefulWidget {

  final FirebaseUser currentUser;

  const RommatesWidget({this.currentUser});

  @override
  _RommatesWidgetState createState() => _RommatesWidgetState();
}

class _RommatesWidgetState extends State<RommatesWidget> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {


    return Container(

      color: Theme.of(context).colorScheme.onBackground,

      child: StreamProvider<List<Apartment>>.value(
        value: DatabaseService().apartments,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primaryVariant),
              elevation: 0,

              // FlatButton.icon(onPressed: () => {}, icon: Icon(Icons.menu), label: Text("")),
              title: Text("", style: TextStyle(color: Colors.white),),

              centerTitle: true,

            ),

            body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[

                      SizedBox(height: 20,),

                      ApartmentNameRoommateScreen(),

                      SizedBox(height: 20,),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            height: 400,
                            width: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20,),
                                Text("People in your apartment: ", style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primaryVariant),),
                                Expanded(
                                    child: RoommateList()
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            NewApartmentWidget(currentUser: widget.currentUser,),

                            AddRoommateWidget(currentUser: widget.currentUser,),
                          ],
                        ),
                      ),


                    ],
                  ),
                )
            ),

            drawer: DrawerWidget()
        ),
      ),
    );
  }
}


