import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/services/database/billsServices.dart';
import 'package:lester_apartments/services/database/shoppingListServices.dart';
import 'package:lester_apartments/services/database/userServices.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';
import 'package:provider/provider.dart';
import 'AddGroceryItemButton.dart';
import 'groceryLists/FilteredGroceryList.dart';
import 'groceryLists/UnfliteredGroceryList.dart';

class ShoppingListWidget extends StatefulWidget {


  @override
  _ShoppingListWidgetState createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {

  TextEditingController searchController;

  String searchText;
  bool hasApartment;


  @override
  void initState(){
    super.initState();
    hasApartment = false;
    searchController = TextEditingController();
    searchText = "";
    searchController.addListener(() {

      if(searchController.text.isEmpty){
        searchText = "";
      }
      else{
        searchText = searchController.text;
      }

      setState(() {
        print(searchText);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //var screenSize = MediaQuery.of(context).size;
    final currentUser = Provider.of<FirebaseUser>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,

        centerTitle: true,

      ),

      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
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
                          "Please join or create an apartment to start making shared grocery lists",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40,),
                        Icon(
                          Icons.add_shopping_cart,
                          size: 100,
                          color: Theme.of(context).colorScheme.secondaryVariant,
                        )
                      ],
                    )
                ),
              );
            }else{
              setState(() {
                hasApartment = true;
              });
            }


            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.primary
                          ),
                          controller: searchController,
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("Confirm"),
                                  content: Text(
                                      "This will make a bill for everyone in the apartment. "
                                      "You should typically make a bill when you are done shopping for the day."
                                      " Do you want to proceed?"
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () async {
                                        BillsServices.makeBill();
                                        Navigator.pop(context);
                                      },
                                      child: Text("Make Bill"),
                                      color: Theme.of(context).colorScheme.secondaryVariant,
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel"),
                                      color: Theme.of(context).colorScheme.secondaryVariant,
                                    )
                                  ],
                                );
                              }
                            );
                          },
                          icon: FaIcon(FontAwesomeIcons.solidClipboard),
                        ),
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: searchText == "" ?
                  UnfilteredGroceryList(currentUser: currentUser) :
                  FilteredGroceryList(
                    currentUser: currentUser,
                    searchText: searchText.toLowerCase(),
                  ),
                )
              ],
            );
          }
        )
      ),
      floatingActionButton: hasApartment ? AddGroceryItemButton() : null,
      drawer: DrawerWidget()
    );
  }
}



