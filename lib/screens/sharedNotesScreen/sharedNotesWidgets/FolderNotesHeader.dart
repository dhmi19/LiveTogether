import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../FolderNotesScreen.dart';


class FolderNotesHeader extends StatelessWidget {
  const FolderNotesHeader({
    Key key,
    @required this.currentUser,
    @required this.widget,
  }) : super(key: key);

  final FirebaseUser currentUser;
  final FolderNotesScreen widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Hey ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text("${currentUser.displayName},",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  widget.screenTitle.toLowerCase() == "all notes" ? "These are all your notes" :
                  "These are your ${widget.screenTitle.toLowerCase()} notes",
                  style: TextStyle(fontSize: 14),
                ),
              )
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.only(right: 40.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(currentUser.photoUrl),
            radius: 35,
          ),
        )
      ],
    );
  }
}