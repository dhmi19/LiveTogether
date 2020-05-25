import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/models/groceryItem.dart';

import '../GroceryItemTile.dart';


class FilteredGroceryList extends StatelessWidget {

  FilteredGroceryList({
    @required this.currentUser,
    @required this.searchText
  });

  final FirebaseUser currentUser;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("groceries").where("roommateList", arrayContains: currentUser.displayName).snapshots(),
      builder: (context, snapshot){

        String apartmentName;

        try{
          List shoppingList = [];

          if(!snapshot.hasData){
            return Text("");
          }

          if(snapshot.hasData){
            final List<DocumentSnapshot> apartments = snapshot.data.documents;
            for(DocumentSnapshot apartment in apartments){
              List<dynamic> tempRoommateList = apartment.data["roommateList"];
              if(tempRoommateList.contains(currentUser.displayName)){
                shoppingList = apartment.data["groceryList"];
                apartmentName = apartment.documentID;
              }
            }
          }

          List filteredShoppingList = List();

          shoppingList.forEach((groceryItem) {
            String itemName = groceryItem['itemName'];
            if(itemName.toLowerCase().contains(searchText)){
              filteredShoppingList.add(groceryItem);
            }
          });

          List<GroceryItemTile> groceryListTextWidgets = List<GroceryItemTile>();

          if(shoppingList == null){

          }else{
            if(filteredShoppingList.isNotEmpty){
              filteredShoppingList.forEach((item) {

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
                    FontAwesomeIcons.frownOpen,
                    size: 150,
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "No matches found",
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primaryVariant
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Try searching for a different item or add this one!",
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

