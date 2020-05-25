import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/services/database/shoppingListServices.dart';
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

  @override
  void initState(){
    super.initState();
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
    var screenSize = MediaQuery.of(context).size;
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: ShoppingListServices.groceriesCollection
                            .where("roommateList", arrayContains: currentUser.displayName)
                            .snapshots(),

                        builder: (context, snapshot) {

                          bool _isGroceryListEmpty = false;

                         try{
                           final List<DocumentSnapshot> documents = snapshot.data.documents;

                           for(var doc in documents){
                             List groceryList = doc.data['groceryList'];
                             if(groceryList == null){

                             }else if (groceryList.isEmpty){
                               _isGroceryListEmpty = true;
                             }

                           }

                           return IconButton(
                             onPressed: () {

                               if(!_isGroceryListEmpty){
                                 showDialog(
                                     context: context,
                                     builder: (BuildContext context){
                                       return AlertDialog(
                                         title: Text("Error", style: TextStyle(color: Colors.black)),
                                         content: Text(
                                             "You can only generate bills once you have bought "
                                                 "or removed all items from the shopping list",
                                           style: TextStyle(fontSize: 18),
                                         ),
                                         actions: <Widget>[
                                           FlatButton(
                                             onPressed: (){
                                               Navigator.pop(context);
                                             },
                                             child: Text("OK", style: TextStyle(color: Colors.blue, fontSize: 20),),
                                           )
                                         ],
                                       );
                                     }
                                 );
                               }

                             },
                             icon: FaIcon(
                               FontAwesomeIcons.clipboardList,
                               size: 30,
                             ),
                             disabledColor: Colors.grey,
                             color: Theme.of(context).colorScheme.primaryVariant,
                           );
                         }
                         catch(error){
                           print(error);
                           return Text("");
                         }
                        }
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
          )
        ),
        floatingActionButton: AddGroceryItemButton(),
        drawer: DrawerWidget()
      ),
    );
  }
}






