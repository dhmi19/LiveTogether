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
      stream: UserServices.userCollection.document(currentUser.uid).collection("bills").where("currentBill", isEqualTo: true).snapshots(),
      builder: (context, snapshot) {

        try{
          double totalCost = 0;

          final QuerySnapshot querySnapshot = snapshot.data;

          if(querySnapshot == null){
            return Text("");
          }

          final List<DocumentSnapshot> bills = querySnapshot.documents;

          for(DocumentSnapshot bill in bills){

            final data = bill.data;

            for(var key in data.keys){
              if(key != "currentBill" && key != "isPaid" && key != "timeStamp"){
                totalCost += data[key]['itemCost'];
              }
            }
            break;
          }

          totalCost = double.parse(totalCost.toStringAsFixed(2));

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