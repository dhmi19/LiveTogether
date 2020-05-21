import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/services/database.dart';


const checkButton = Icon(Icons.check_circle, size: 20, color: Colors.green);
const editButton = Icon(Icons.edit, size: 20, color: Colors.orange,);

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
  Icon editIcon;
  FocusNode myFocusNode;
  TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    newQuantity = widget.quantity;
    editIcon = editButton;
    quantityController = TextEditingController(text: newQuantity.toString());
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
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
              children: <Widget>[
                SizedBox(width: 75,),
                SizedBox(
                  width: 40,
                  child: TextField(
                    controller: quantityController,
                    style: TextStyle(fontSize: 30),
                    focusNode: myFocusNode,
                    decoration: null,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if(editIcon == editButton){
                      setState(() {
                        myFocusNode.requestFocus();
                        editIcon = checkButton;
                      });
                    }else{
                      int updatedQuantity = int.parse(quantityController.text);
                      DatabaseService().updateGroceryItem(widget.item, widget.quantity, updatedQuantity, widget.description);
                      setState(() {
                        newQuantity = int.parse(quantityController.text);
                        myFocusNode.unfocus();
                        editIcon = editButton;
                      });
                    }
                  },
                  icon: editIcon,
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