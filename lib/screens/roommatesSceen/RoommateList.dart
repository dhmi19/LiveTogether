import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:lester_apartments/shared/RoommateTile.dart';
import 'package:provider/provider.dart';


class RoommateList extends StatefulWidget {

  @override
  _RoommateListState createState() => _RoommateListState();
}

class _RoommateListState extends State<RoommateList> {

  List _roommateList = [];
  Apartment _apartment;

  @override
  Widget build(BuildContext context) {

    final user =Provider.of<FirebaseUser>(context);

    final apartments = Provider.of<List<Apartment>>(context);


    if(apartments != null){
      apartments.forEach((apartment) {
        print(apartment.apartmentName);
        print(apartment.roommateList.toString());
        print(user.displayName);
        if(apartment.roommateList.contains(user.displayName)){
          _roommateList = apartment.roommateList;
          _apartment = apartment;
        }
      });
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _roommateList.length,
      itemBuilder: (context, index) {
        return RoommateTile(apartment: _apartment, roommateList: _roommateList, index: index);
      }
    );
  }
}
