import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/models/groceryItem.dart';

import '../GroceryItemTile.dart';

class UnfilteredGroceryList extends StatelessWidget {
  const UnfilteredGroceryList({
    Key key,
    @required this.currentUser,
  }) : super(key: key);

  final FirebaseUser currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("groceries").where("roommateList", arrayContains: currentUser.displayName).snapshots(),
      builder: (context, snapshot){

        String apartmentName;

        try{
          List groceryList = [];

          if(snapshot == null){
            throw "Snapshot was null";
          }

          if(!snapshot.hasData){
            return Text("");
          }

          if(snapshot.hasData){
            final List<DocumentSnapshot> apartments = snapshot.data.documents;
            for(DocumentSnapshot apartment in apartments){
              List<dynamic> tempRoommateList = apartment.data["roommateList"];
              if(tempRoommateList.contains(currentUser.displayName)){
                groceryList = apartment.data["groceryList"];
                apartmentName = apartment.documentID;
              }
            }
          }

          List<GroceryItemTile> groceryListTextWidgets = List<GroceryItemTile>();

          if(groceryList == null){

          }else{
            if(groceryList.isNotEmpty){
              groceryList.forEach((item) {

                GroceryItem groceryItem = GroceryItem(
                    itemName: item['itemName'],
                    itemCount: item['itemCount'],
                    description: item['description'],
                    buyers: item['buyer']
                );

                groceryListTextWidgets.add(
                    GroceryItemTile(
                      apartmentName: apartmentName,
                      groceryItem: groceryItem,
                    )
                );
              });
            }
          }

          if(groceryListTextWidgets.isEmpty){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.cartPlus,
                    size: 150,
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "Your shopping list is currently empty.",
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primaryVariant
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Try adding a few items!",
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primaryVariant
                    ),
                  )
                ],
              ),
            );
          }else{
            return GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(20.0),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: groceryListTextWidgets
            );
          }
        }
        catch(error){
          print(error);
          return Center(
            child: Text("Sorry, an error occurred"),
          );
        }

      },
    );
  }
}
