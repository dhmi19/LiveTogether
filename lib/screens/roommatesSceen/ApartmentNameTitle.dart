
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:provider/provider.dart';

class ApartmentNameRoommateScreen extends StatelessWidget {

  String _apartmentName;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseUser>(context);
    final apartments = Provider.of<List<Apartment>>(context);

    if(apartments != null){
      apartments.forEach((apartment) {
        for(var roommate in apartment.roommateList){
          if(roommate["displayName"] == user.displayName){
            _apartmentName = apartment.apartmentName;
          }
        }
      });
    }
    return Text(_apartmentName != null ? _apartmentName: "Your Apartment", style: TextStyle(fontSize: 30, color: Theme.of(context).colorScheme.primaryVariant));
  }
}