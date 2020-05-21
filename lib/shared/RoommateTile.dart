
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/constants.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:provider/provider.dart';

class RoommateTile extends StatelessWidget {

  final Apartment apartment;
  final List roommateList;
  final int index;
  RoommateTile({this.apartment, this.roommateList, this.index});

  @override
  Widget build(BuildContext context) {

    Color tileColor = kDarkBlue;

    final FirebaseUser currentUser = Provider.of<FirebaseUser>(context);

    String userName = roommateList[index]["displayName"];
    bool isMe = false;

    if(userName == currentUser.displayName){
      isMe = true;
    }

    print(apartment.apartmentName);

    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection("apartments").document(apartment.apartmentName).snapshots(),
      builder: (context, snapshot) {

        try{
          print(snapshot.hasData);
          final DocumentSnapshot documentSnapshot = snapshot.data;
          final data = documentSnapshot.data;
          final List roommateList = data['roommateList'];

          for(var roommate in roommateList){
            if(roommate['displayName'] == currentUser.displayName){
              tileColor = Color(roommate['color']);
            }
          }

          return Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Card(
              color: tileColor,
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
        }catch(error){
          print(error);
          return Text("error");
        }
      }
    );
  }
}
