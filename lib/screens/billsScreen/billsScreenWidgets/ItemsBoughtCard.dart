import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/database/userServices.dart';
import 'package:provider/provider.dart';

class ItemsBoughtCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final FirebaseUser currentUser = Provider.of<FirebaseUser>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: UserServices.userCollection.document(currentUser.uid).collection("bills").snapshots(),
      builder: (context, snapshot) {

        try{

          final QuerySnapshot querySnapshot = snapshot.data;
          final List<DocumentSnapshot> billsCollection = querySnapshot.documents;

          int collectionLength = billsCollection.length;
          int totalItems = 0;

          if(billsCollection.length == 0){
            totalItems = 0;
          }
          else if(billsCollection.length == 1){
            for(var bill in billsCollection){

              final keys = bill.data.keys;
              totalItems = keys.length;

              if(keys.contains('numItems')){
                totalItems -= 1;
              }
              
              if(keys.contains('isPaid')){
                totalItems -= 1;
              }


              if(keys.contains('timeStamp')){
                totalItems -= 1;
              }

              break;
            }
          }
          else{
            final DocumentSnapshot currentBill = billsCollection.elementAt(collectionLength - 1);

            final keys = currentBill.data.keys;

            totalItems = keys.length;

            if(keys.contains('numItems')){
              totalItems -= 1;
            }

            if(keys.contains('isPaid')){
              totalItems -= 1;
            }


            if(keys.contains('timeStamp')){
              totalItems -= 1;
            }

          }

          return Container(
              height: 130,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Items bought", style: TextStyle(color: Colors.black, fontSize: 18),),
                  SizedBox(height: 20,),
                  Text("$totalItems", style: TextStyle(color: Colors.black, fontSize: 30),)
                ],
              )
          );
        }
        catch(error){
          print(error);
          return Container(
              height: 130,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Items bought", style: TextStyle(color: Colors.black, fontSize: 18),),
                  SizedBox(height: 20,),
                  Text("", style: TextStyle(color: Colors.black, fontSize: 30),)
                ],
              )
          );;
        }

      }
    );
  }
}