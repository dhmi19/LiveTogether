import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';

class RoommateTile extends StatelessWidget {
  final Apartment apartment;

  RoommateTile({this.apartment});

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
          title: Text(apartment.apartmentName),
          subtitle: Text(apartment.roommateList.toString()),

        ),
      ),
    );
  }
}
