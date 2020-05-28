import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/database/userServices.dart';
import 'package:provider/provider.dart';

class AmountDueCard extends StatelessWidget {


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
          double totalCost = 0;

          if(billsCollection.length == 0){
            totalCost = 0;
          }
          else if(billsCollection.length == 1){
            for(var bill in billsCollection){
              for(var key in bill.data.keys){
                if(key != 'numItems'){
                  totalCost += bill[key]['itemCost'];
                }
              }
              break;
            }
          }
          else{
            final DocumentSnapshot currentBill = billsCollection.elementAt(collectionLength - 1);

            for(var key in currentBill.data.keys){
              if(key != 'numItems'){
                totalCost += currentBill[key]['itemCost'];
              }
            }
          }

          print(totalCost);


          return Container(
              height: 130,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Amount due", style: TextStyle(color: Colors.black, fontSize: 18),),
                  SizedBox(height: 20,),
                  Text("\$$totalCost", style: TextStyle(color: Colors.black, fontSize: 30),)
                ],
              )
          );

        }catch(error){
          print(error);
          return Container(
              height: 130,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Amount due", style: TextStyle(color: Colors.black, fontSize: 18),),
                  SizedBox(height: 20,),
                  Text("\$0.00", style: TextStyle(color: Colors.black, fontSize: 30),)
                ],
              )
          );;
        }

      }
    );
  }
}