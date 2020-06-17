import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/services/database/userServices.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';
import 'package:provider/provider.dart';

import 'billsScreenWidgets/AllBillsWidget.dart';
import 'billsScreenWidgets/BillActionWidget.dart';
import 'billsScreenWidgets/CurrentBillHeader.dart';

const headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

class BillsScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    FirebaseUser currentUser = Provider.of<FirebaseUser>(context);

    return StreamBuilder<Object>(
      stream: UserServices.userCollection.document(currentUser.uid).snapshots(),
      builder: (context, snapshot) {

        String apartmentName = '';

        DocumentSnapshot documentSnapshot = snapshot.data;

        if(documentSnapshot != null && documentSnapshot.data != null){
          apartmentName = documentSnapshot.data['apartment'];
        }


        if(apartmentName == ''){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Please join or create an apartment to make and view bills",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40,),
                    FaIcon(
                      FontAwesomeIcons.moneyBillAlt,
                      size: 100,
                      color: Theme.of(context).colorScheme.secondaryVariant,
                    )
                  ],
                )
            ),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onBackground,

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,

            centerTitle: true,
          ),

          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text("Current Bill", style: headerStyle,),
                  SizedBox(height: 10,),

                  CurrentBillHeader(),

                  SizedBox(height: 30,),

                  Text("Previous Bills", style: headerStyle),
                  SizedBox(height: 10,),

                  AllBillsWidget()
                ],
              ),
            )
          ),

          drawer: DrawerWidget()
        );
      }
    );
  }
}









