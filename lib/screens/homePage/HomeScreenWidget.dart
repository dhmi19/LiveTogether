import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';

import 'HomePageSlideShow.dart';

class HomeScreenWidget extends StatefulWidget {

  final FirebaseUser currentUser;

  const HomeScreenWidget({this.currentUser});

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {

  final PageController ctrl = PageController();

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

        color: Theme.of(context).colorScheme.onBackground,

        /*
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Colors.red[700],
            Colors.red[500],
            Colors.red[200]
          ]
        )
            */
      ),
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
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),

              Text("Welcome Home", style: TextStyle(fontSize: 40, color: Theme.of(context).colorScheme.primaryVariant),),

              SizedBox(height: 30,),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),

                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2734&q=80"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1545167622-3a6ac756afa4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=712&q=80"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1569443693539-175ea9f007e8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=620&q=80"),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80"),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20,),

                        Text(
                          "My Home:",
                          style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primaryVariant),
                          textAlign: TextAlign.left,
                        ),

                        SizedBox(
                          height: 350,
                          width: 350,
                          //child: HomePageSlideShow(currentUser),
                        ),

                        SizedBox(height: 20,),

                      ],
                    ),
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
