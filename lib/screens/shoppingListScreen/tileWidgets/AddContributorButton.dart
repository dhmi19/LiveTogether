import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/models/groceryItem.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';
import 'package:lester_apartments/services/database/shoppingListServices.dart';

import '../GroceryItemTile.dart';
import 'ContributorTile.dart';


class AddContributorButton extends StatelessWidget {

  AddContributorButton({@required this.widget,});

  final GroceryItemTile widget;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot>(
        stream: ApartmentServices.apartmentCollection.document(widget.apartmentName).snapshots(),
        builder: (context, snapshot) {

          try{
            final DocumentSnapshot documentSnapshot = snapshot.data;
            final data = documentSnapshot.data;
            final List roommateList = data['roommateList'];

            List roommateUserNames = List();

            for(var roommate in roommateList){
              roommateUserNames.add(roommate);
            }

            return IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return ChooseContributorAlertBox(
                        groceryItem: widget.groceryItem,
                        roommateUserNames: roommateUserNames
                      );
                    }
                );
              },
              icon: FaIcon(
                Icons.person,
                color: Colors.black,
                size: 20,
              ),
            );

          }
          catch(error){
            print(error);
            return Text("");
          }
        }
    );
  }
}


class ChooseContributorAlertBox extends StatefulWidget {

  final GroceryItem groceryItem;
  final List roommateUserNames;

  ChooseContributorAlertBox({
    @required this.groceryItem,
    @required this.roommateUserNames
  });

  @override
  _ChooseContributorAlertBoxState createState() => _ChooseContributorAlertBoxState();
}

class _ChooseContributorAlertBoxState extends State<ChooseContributorAlertBox> {

  final List<Widget> contributorTile = List<Widget>();
  List finalBuyers = List();
  String error = '';

  void toggleContributor(String displayName){
    if(finalBuyers.contains(displayName)){
      finalBuyers.remove(displayName);
      print("hi");
      print(finalBuyers.toString());
    }
    else{
      finalBuyers.add(displayName);
      print(finalBuyers.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    finalBuyers = widget.groceryItem.buyers.split(",");
  }

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;

    widget.roommateUserNames.forEach((roommate) {
      contributorTile.add(
          ContributorTile(
            roommate: roommate,
            toggleSelect: toggleContributor,
            groceryItem: widget.groceryItem
          )
      );
    });

    return AlertDialog(
      title: Text("Add Contributor"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Who is contributing to ${widget.groceryItem.itemName}?"),
          SizedBox(height: 10,),
          Container(
            height: 200,
            width: screenSize.width * 0.8,
            child: ListView(
              children: contributorTile,
              shrinkWrap: true,
            )
          ),
          Text(error, style: TextStyle(color: Colors.red),)
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            String finalBuyersString = '';
            finalBuyers.forEach((contributor) {
              if(finalBuyersString.length == 0){
                finalBuyersString += '$contributor';
              }else{
                finalBuyersString += ',$contributor';
              }
            });
            if(finalBuyersString == ''){
              setState(() {
                error = "You can not have no buyers, please delete the item instead";
              });
            }else{
              ShoppingListServices.updateBuyers(widget.groceryItem, widget.groceryItem.itemCount, finalBuyersString);
              Navigator.pop(context);
            }
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Submit', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
