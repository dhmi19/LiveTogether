
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/database.dart';

class AddGroceryBottomSheet extends StatefulWidget {

  @override
  _AddGroceryBottomSheetState createState() => _AddGroceryBottomSheetState();
}

class _AddGroceryBottomSheetState extends State<AddGroceryBottomSheet> {
  String itemName;

  int itemCount;

  String description;

  String _error;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF686868),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40,),

            Text("Add grocery item: ", style: TextStyle(
              color: Theme.of(context).colorScheme.primaryVariant,
              fontSize: 30,
            ),
            ),
            SizedBox(height: 20,),
            TextField(
              onChanged: (value){
                itemName = value;
              },
              autofocus: true,
              decoration: InputDecoration(
                  hintText: "Item name",
                  icon: Icon(Icons.shopping_cart, color: Theme.of(context).colorScheme.secondary,)
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
              cursorColor: Theme.of(context).colorScheme.primaryVariant,
            ),
            SizedBox(height: 20,),
            TextField(
              onChanged: (value){
                itemCount = int.parse(value);
              },
              decoration: InputDecoration(
                  hintText: "Number of items",
                  icon: Icon(Icons.add_circle, color: Theme.of(context).colorScheme.secondary,)
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
              cursorColor: Theme.of(context).colorScheme.primaryVariant,
            ),
            SizedBox(height: 20,),
            TextField(
              onChanged: (value){
                description = value;
              },
              decoration: InputDecoration(
                  hintText: "Description of item",
                  icon: Icon(Icons.short_text, color: Theme.of(context).colorScheme.secondary,)
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
              cursorColor: Theme.of(context).colorScheme.primaryVariant,
            ),
            SizedBox(height: 20,),

            Container(
              width: 150,
              child: FlatButton(
                color: Theme.of(context).colorScheme.secondaryVariant,
                child: Text("Add item", style: TextStyle(color: Colors.white),),
                onPressed: () async {
                  if((itemCount == null) || (itemName == null)){
                    setState(() {
                      _error = "Please input all fields";
                    });
                  }else{
                    final result = await DatabaseService().addGroceryItem(itemName, itemCount, description);
                    if(result != null){
                      Navigator.of(context).pop();
                    }else{
                      setState(() {
                        _error = "Could not add item, please try again later";
                      });
                    }
                  }
                },
              ),
            ),
            SizedBox(height: 10,),

            Text(_error?? "", style: TextStyle(color: Colors.red[500]),),

            SizedBox(height: 10,),

            Text("Swipe screen down to cancel", style: TextStyle(color: Theme.of(context).colorScheme.primaryVariant),)
          ],
        ),
      ),
    );
  }
}