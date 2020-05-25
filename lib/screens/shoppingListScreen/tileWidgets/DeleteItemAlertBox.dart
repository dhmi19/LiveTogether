

import 'package:flutter/material.dart';
import 'package:lester_apartments/models/groceryItem.dart';
import 'package:lester_apartments/services/database/shoppingListServices.dart';

class DeleteItemAlertBox extends StatelessWidget {

  final GroceryItem groceryItem;
  final String apartmentName;
  DeleteItemAlertBox({this.groceryItem, this.apartmentName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Remove ${groceryItem.itemName}?"),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            ShoppingListServices.removeShoppingListItem(groceryItem, apartmentName);
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('YES', style: TextStyle(fontSize: 18)),
        ),

        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text('NO', style: TextStyle(fontSize: 18),
          ),
        ),

      ],
    );
  }
}