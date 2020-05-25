import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/groceryItem.dart';
import 'package:lester_apartments/screens/shoppingListScreen/tileWidgets/AddContributorButton.dart';
import 'package:lester_apartments/screens/shoppingListScreen/tileWidgets/BuyItemAlertBox.dart';
import 'package:lester_apartments/screens/shoppingListScreen/tileWidgets/DeleteItemAlertBox.dart';
import 'package:lester_apartments/screens/shoppingListScreen/tileWidgets/GroceryTileHeader.dart';
import 'package:lester_apartments/services/database/shoppingListServices.dart';
import 'package:provider/provider.dart';


const checkButton = Icon(Icons.check_circle, size: 20, color: Colors.green);
const editButton = Icon(Icons.edit, size: 20, color: Colors.orange,);

class GroceryItemTile extends StatefulWidget {

  final GroceryItem groceryItem;
  final String apartmentName;

  GroceryItemTile({@required this.apartmentName, @required this.groceryItem});

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
    newQuantity = widget.groceryItem.itemCount;
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

    final FirebaseUser currentUser = Provider.of<FirebaseUser>(context);

    bool isMe;

    if(widget.groceryItem.buyers.contains(currentUser.displayName)){
      isMe = true;
    }else{
      isMe = false;
    }

    return GestureDetector(
      onLongPress: (){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return BuyItemAlertBox(groceryItem: widget.groceryItem, apartmentName: widget.apartmentName,);
            }
        );
      },
      onDoubleTap: (){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return DeleteItemAlertBox(groceryItem: widget.groceryItem, apartmentName: widget.apartmentName,);
            }
        );
      },
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AddContributorButton(widget: widget),
                  GroceryTileHeader(listOfBuyers: widget.groceryItem.buyers, apartmentName: widget.apartmentName,),
                ],
              ),

              Text(widget.groceryItem.itemName, style: TextStyle(fontSize: 20),),

              SizedBox(height: 5,),

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
                        isMe ?
                        ShoppingListServices.updateShoppingListItem(
                          widget.groceryItem,
                          updatedQuantity,
                          null
                        ) :
                        ShoppingListServices.updateShoppingListItem(
                          widget.groceryItem,
                          updatedQuantity,
                          currentUser.displayName
                        );
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

              Text(widget.groceryItem.description, style: TextStyle(fontSize: 15),),

            ],
          ),
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),

      ),
    );
  }
}



