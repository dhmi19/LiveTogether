import 'package:flutter/material.dart';
import 'package:lester_apartments/models/billItem.dart';


class ItemCard extends StatelessWidget {

  final BillItem item;

  ItemCard({@required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 25,),

            Text(item.itemName, style: TextStyle(fontSize: 20),),

            SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Cost"),
                    SizedBox(height: 5,),
                    Text(item.itemCost.toString(), style: TextStyle(fontSize: 30))
                  ],
                ),

                Column(
                  children: <Widget>[
                    Text("Quantity"),
                    SizedBox(height: 5,),
                    Text(item.itemCount.toString(), style: TextStyle(fontSize: 30))
                  ],
                )

              ],
            )
          ],
        ),
      ),
    );
  }
}