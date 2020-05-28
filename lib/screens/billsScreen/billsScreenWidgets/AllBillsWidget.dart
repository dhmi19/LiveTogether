import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/bill.dart';
import 'package:lester_apartments/models/billItem.dart';
import 'package:lester_apartments/services/database/userServices.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'BillTile.dart';

class AllBillsWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final FirebaseUser currentUser = Provider.of<FirebaseUser>(context);

    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: UserServices.userCollection.document(currentUser.uid).collection("bills").snapshots(),
        builder: (context, snapshot) {

          try{

            QuerySnapshot querySnapshot = snapshot.data;

            if(querySnapshot == null){
              return Text("");
            }

            List<DocumentSnapshot> documents = querySnapshot.documents;

            List<Bill> bills = List<Bill>();

            List<BillTile> billTiles = List<BillTile>();

            for(DocumentSnapshot document in documents){
              Map data = document.data;

              List<BillItem> _items = List<BillItem>();

              for(var key in data.keys){
                if(key != 'isPaid' && key != 'timeStamp'){
                  BillItem billItem = BillItem(
                    itemName: key.toString(),
                    itemCount: data[key]['itemCount'],
                    itemCost: data[key]['itemCost']
                  );
                  _items.add(billItem);
                }
              }

              print("hiiiiiii");

              Timestamp timeStamp = data['timeStamp'];
              DateTime myDateTime = timeStamp.toDate();

              String timeStampString = DateFormat.yMMMd().format(myDateTime);

              Bill bill = Bill(
                title: document.documentID,
                items: _items,
                isSettled: true,
                timeStamp: timeStampString
              );
              bills.add(bill);
            }

            if(bills != null){
              bills.forEach((bill) {
                billTiles.add(
                  BillTile(bill: bill,)
                );
              });
            }

            if(billTiles.length == 0){

              return Center(
                child: Text(
                  "Add bills with your apartment to see your bills here"
                ),
              );
            }
            else{
              return ListView(
                children: billTiles,
              );
            }

          }catch(error){
            print(error);
            return Text("Generate a bill with your apartment to see all your bills");
          }

        }
      ),
    );
  }
}


