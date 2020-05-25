

import 'package:flutter/material.dart';
import 'package:lester_apartments/models/groceryItem.dart';
import 'package:lester_apartments/services/database/shoppingListServices.dart';

class DeleteItemAlertBox extends StatefulWidget {

  final GroceryItem groceryItem;
  final String apartmentName;
  DeleteItemAlertBox({this.groceryItem, this.apartmentName});

  @override
  _DeleteItemAlertBoxState createState() => _DeleteItemAlertBoxState();
}

class _DeleteItemAlertBoxState extends State<DeleteItemAlertBox> {

  TextEditingController priceController = TextEditingController();
  String error = "";

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text("How much did you pay for ${widget.groceryItem.itemName}?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: priceController,
            decoration: InputDecoration(
              hintText: "\$0.00",
              hintStyle: TextStyle(fontSize: 25),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
          Text(error, style: TextStyle(color: Colors.red),)
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {

            //Add costs to each user
            final double cost = double.parse(priceController.text);

            //Get cost per person
            int numPeople = widget.groceryItem.buyers.split(',').length;

            final double costPerPerson = cost/numPeople;

            ShoppingListServices.addCost(
              costPerPerson: costPerPerson,
              groceryItem: widget.groceryItem,
              apartmentName: widget.apartmentName
            );

            //Remove from grocery List
            ShoppingListServices.removeShoppingListItem(widget.groceryItem, widget.apartmentName);
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Buy', style: TextStyle(fontSize: 18)),
        ),

        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text('Cancel', style: TextStyle(fontSize: 18),
          ),
        ),

      ],
    );
  }
}