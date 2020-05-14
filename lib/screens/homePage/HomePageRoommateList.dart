import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:lester_apartments/services/database.dart';
import 'package:provider/provider.dart';

import 'HomeProfileTile.dart';

class HomePageRoommateList extends StatefulWidget {
  @override
  _HomePageRoommateListState createState() => _HomePageRoommateListState();
}

class _HomePageRoommateListState extends State<HomePageRoommateList> {

  List _roommateList = [];
  Apartment _apartment;


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseUser>(context);

    final apartments = Provider.of<List<Apartment>>(context);

    if(apartments != null){
      apartments.forEach((apartment) {
        print(apartment.apartmentName);
        print(apartment.roommateList.toString());
        print(user.displayName);

        for(var roommate in apartment.roommateList){
          if(roommate["displayName"] == user.displayName){
            _roommateList = apartment.roommateList;
            _apartment = apartment;
            break;
          }
        }
      });
    }

    return StreamBuilder<List<Apartment>>(
      stream: DatabaseService().apartments,

      builder: (context, snapshot) {

        List<CircleAvatar> profilePictureList = [];

        for(var roommate in _roommateList){
          print("Inside streambuilder: "+ roommate.toString());

          final roommateCircleAvatar = CircleAvatar(
            radius: 50.0,
            backgroundImage: NetworkImage(roommate["profilePictureURL"]),
          );
          profilePictureList.add(roommateCircleAvatar);
        }

        return Container(
          height: 120,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            children: profilePictureList,
          ),
        );
      },
    );

    /*
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: _roommateList.length,
        itemBuilder: (context, index) {
          return HomeProfileTile(apartment: _apartment, roommateList: _roommateList, index: index);
        }
    );

     */
  }
}
