import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GroceryItemTile extends StatefulWidget {

  final String item;
  final int quantity;
  final String description;

  GroceryItemTile({this.item, this.quantity, this.description});

  @override
  _GroceryItemTileState createState() => _GroceryItemTileState();
}

class _GroceryItemTileState extends State<GroceryItemTile> {

  int newQuantity = 0;

  @override
  void initState() {
    super.initState();
    newQuantity = widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return DeleteItemAlertBox(itemName: widget.item,);
            }
        );
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

            Text(widget.item, style: TextStyle(fontSize: 25),),

            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    setState(() {
                      if(newQuantity > 0){
                        newQuantity --;
                      }
                    });
                  },
                  icon: FaIcon(FontAwesomeIcons.minusCircle, size: 20, color: Theme.of(context).colorScheme.onSecondary,),
                ),
                Text(newQuantity.toString(), style: TextStyle(fontSize: 30),),
                IconButton(
                  onPressed: (){
                    setState(() {
                      newQuantity ++;
                    });
                  },
                  icon: Icon(Icons.add_circle, size: 25, color: Theme.of(context).colorScheme.onSecondary,),
                ),
              ],
            ),

            SizedBox(height: 10,),

            Text(widget.description, style: TextStyle(fontSize: 15),),

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

class DeleteItemAlertBox extends StatelessWidget {

  final String itemName;
  DeleteItemAlertBox({this.itemName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Remove $itemName?"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {

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