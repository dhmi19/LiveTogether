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
      stream: UserServices.userCollection.document(currentUser.uid).collection("bills").where("currentBill", isEqualTo: true).snapshots(),
      builder: (context, snapshot) {

        try{
          int totalItems = 0;

          final QuerySnapshot querySnapshot = snapshot.data;

          if(querySnapshot == null){
            return Text("");
          }

          final List<DocumentSnapshot> bills = querySnapshot.documents;

          for(DocumentSnapshot bill in bills){
            
            final data = bill.data;
            
            int items = data.length;
            
            if(data.containsKey("currentBill")){
              items --;
            }

            if(data.containsKey("isPaid")){
              items --;
            }

            if(data.containsKey("timeStamp")){
              items --;
            }
            totalItems = items;
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