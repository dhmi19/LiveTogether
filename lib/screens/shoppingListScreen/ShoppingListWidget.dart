import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';
import 'package:provider/provider.dart';

import 'AddGroceryItemButton.dart';
import 'GroceryItemTile.dart';

class ShoppingListWidget extends StatefulWidget {


  @override
  _ShoppingListWidgetState createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<FirebaseUser>(context);

    return Container(
      color: Theme.of(context).colorScheme.onBackground,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,

          title: Text("Shopping List", style: TextStyle(color: Colors.black),),

          centerTitle: true,

        ),

        body: SafeArea(
          child: Column(
            children: <Widget>[

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("groceries").where("roommateList", arrayContains: currentUser.displayName).snapshots(),
                  builder: (context, snapshot){

                    String apartmentName;

                    try{
                      List groceryList = [];

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
                            groceryListTextWidgets.add(
                                GroceryItemTile(
                                  item: item['itemName'],
                                  quantity: item['itemCount'],
                                  description: item['description'],
                                  apartmentName: apartmentName,
                                  buyer: item['buyer'],
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
                ),
              )
            ],
          )
        ),
        floatingActionButton: AddGroceryItemButton(),
        drawer: DrawerWidget()
      ),
    );
  }
}




