import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/services/database.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';
import 'package:provider/provider.dart';

class ShoppingListWidget extends StatefulWidget {

  final FirebaseUser currentUser;

  const ShoppingListWidget({this.currentUser});

  @override
  _ShoppingListWidgetState createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {

  final AuthService _auth = AuthService();

  Future<String> apartmentName;

  @override
  void initState(){
    super.initState();
    apartmentName = DatabaseService().getCurrentApartmentName();
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

          // FlatButton.icon(onPressed: () => {}, icon: Icon(Icons.menu), label: Text("")),
          title: Text("Shopping List", style: TextStyle(color: Colors.black),),

          centerTitle: true,

        ),

        body: SafeArea(
          child: Column(
            children: <Widget>[

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("groceries").snapshots(),
                  builder: (context, snapshot){

                    List groceryList = [];

                    if(!snapshot.hasData){
                      return Text("Sorry, data was not found");
                    }
                    if(snapshot.hasData){
                      final List<DocumentSnapshot> apartments = snapshot.data.documents;
                      for(DocumentSnapshot apartment in apartments){
                        List<dynamic> tempRoommateList = apartment.data["roommateList"];
                        if(tempRoommateList.contains(currentUser.displayName)){
                          groceryList = apartment.data["groceryList"];
                        }
                      }
                    }

                    List<GroceryItemTile> groceryListTextWidgets = [];

                    groceryList.forEach((element) {
                      groceryListTextWidgets.add(
                        GroceryItemTile(item: element['item'], quantity: element['itemCount'], description: element['description'],)
                      );
                    });

                    return GridView.count(
                      crossAxisCount: 2,
                      padding: EdgeInsets.all(20.0),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: groceryListTextWidgets
                    );
                  },
                ),
              )
            ],
          )
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          child: Icon(Icons.add, size: 40, color: Colors.white,),
        ),
        drawer: DrawerWidget()
      ),
    );
  }
}

class GroceryItemTile extends StatelessWidget {

  final String item;
  final int quantity;
  final String description;

  GroceryItemTile({this.item, this.quantity, this.description});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print("Tapped");
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.bookmark, color: Theme.of(context).colorScheme.secondary, size: 30,),
                  ],
                )
            ),

            Text(item, style: TextStyle(fontSize: 20),),

            SizedBox(height: 10,),

            Text(quantity.toString(), style: TextStyle(fontSize: 20),),

            SizedBox(height: 10,),

            Text("Description: ", style: TextStyle(fontSize: 15),),

            SizedBox(height: 10,),

            Text(description, style: TextStyle(fontSize: 15),),

          ],
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),

      ),
    );
  }
}
