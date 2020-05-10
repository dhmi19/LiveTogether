
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';

class RoommateTile extends StatelessWidget {

  final Apartment apartment;
  List roommateList;
  int index;
  RoommateTile({this.apartment, this.roommateList, this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.red,
          ),
          title: Text(roommateList[index]),
        ),
      ),
    );
  }
}
