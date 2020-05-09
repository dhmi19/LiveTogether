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
  @override
  Widget build(BuildContext context) {

    final users =Provider.of<FirebaseUser>(context);

    final apartments = Provider.of<List<Apartment>>(context);
    //print(apartments.documents);

    /*
    for(var doc in apartments.documents){
      print(doc.data);
      print(users.displayName);
    }

     */

    print("RoommateList: "+ apartments.toString());
    apartments.forEach((apartment) {
      print(apartment.apartmentName);
    });

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: apartments.length,
      itemBuilder: (context, index) {
        return RoommateTile(apartment: apartments[index]);
      }
    );
  }
}
