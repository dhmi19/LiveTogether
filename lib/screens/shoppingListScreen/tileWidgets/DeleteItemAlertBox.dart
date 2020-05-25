
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
      title: Text("Remove ${widget.groceryItem.itemName}?"),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            //Remove from grocery List
            ShoppingListServices.removeShoppingListItem(widget.groceryItem, widget.apartmentName);
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Yes', style: TextStyle(fontSize: 18)),
        ),

        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text('No', style: TextStyle(fontSize: 18),
          ),
        ),

      ],
    );
  }
}