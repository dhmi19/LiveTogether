import 'package:flutter/material.dart';

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