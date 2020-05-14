
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';

class RoommateTile extends StatelessWidget {

  final Apartment apartment;
  List roommateList;
  int index;
  final FirebaseUser currentUser;
  RoommateTile({this.apartment, this.roommateList, this.index, this.currentUser});

  @override
  Widget build(BuildContext context) {

    String userName = roommateList[index]["displayName"];
    bool isMe = false;

    if(userName == currentUser.displayName){
      isMe = true;
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: isMe? Theme.of(context).colorScheme.secondaryVariant: Colors.white70,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(roommateList[index]["profilePictureURL"]),
            ),
            title: Text(userName),
          ),
        ),
      ),
    );
  }
}
