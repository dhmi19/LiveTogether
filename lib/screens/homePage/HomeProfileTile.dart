
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';

class HomeProfileTile extends StatelessWidget {

  final Apartment apartment;
  List roommateList;
  int index;
  HomeProfileTile({this.apartment, this.roommateList, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      child: CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage(roommateList[index]["profilePictureURL"])
      ),
    );
  }

}
