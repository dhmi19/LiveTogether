import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/models/groceryItem.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';
import 'package:lester_apartments/services/database/shoppingListServices.dart';

import '../GroceryItemTile.dart';


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

            List potentialContributors = List();

            for(var roommate in roommateList){
              if(!(widget.groceryItem.buyers.contains(roommate['displayName']))){
                potentialContributors.add(roommate);
              }
            }

            return IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return ChooseContributorAlertBox(
                        groceryItem: widget.groceryItem,
                        potentialContributors: potentialContributors
                      );
                    }
                );
              },
              icon: FaIcon(
                FontAwesomeIcons.plusCircle,
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
  final List potentialContributors;

  ChooseContributorAlertBox({this.groceryItem, this.potentialContributors});

  @override
  _ChooseContributorAlertBoxState createState() => _ChooseContributorAlertBoxState();
}

class _ChooseContributorAlertBoxState extends State<ChooseContributorAlertBox> {

  final List<Widget> contributorTile = List<Widget>();
  final List additionalContributors = List();

  void toggleContributor(String displayName){
    if(additionalContributors.contains(displayName)){
      additionalContributors.remove(displayName);
    }else{
      additionalContributors.add(displayName);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.potentialContributors.forEach((potentialContributor) {
      contributorTile.add(
          ContributorTile(
            potentialContributor: potentialContributor,
            toggleSelect: toggleContributor,
          )
      );
    });

    return AlertDialog(
      title: Text("Add Contributor"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Who else is contributing to ${widget.groceryItem.itemName}?"),
          SizedBox(height: 10,),
          Container(
            height: 200,
            width: 200,
            child: ListView(
              children: contributorTile,
              shrinkWrap: true,
            )
          )
        ],
      ),

      actions: <Widget>[
        FlatButton(
          onPressed: () {
            String additionalBuyers = '';

            additionalContributors.forEach((contributor) {
              if(additionalBuyers.length == 0){
                additionalBuyers += '$contributor';
              }else{
                additionalBuyers += ',$contributor';
              }
            });
            print(additionalBuyers);
            ShoppingListServices.updateShoppingListItem(widget.groceryItem, widget.groceryItem.itemCount, additionalBuyers);
            Navigator.pop(context);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Submit', style: TextStyle(fontSize: 18)),
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


class ContributorTile extends StatefulWidget{

  final dynamic potentialContributor;
  final Function toggleSelect;
  const ContributorTile({@required this.potentialContributor, @required this.toggleSelect});

  @override
  _ContributorTileState createState() => _ContributorTileState();
}

class _ContributorTileState extends State<ContributorTile> {

  bool _value;

  @override
  void initState() {
    super.initState();
    _value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Material(
        color: Color(widget.potentialContributor['color']),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 10),
          trailing: Checkbox(
            onChanged: (bool value) {
              setState(() {
                _value = value;
                widget.toggleSelect(widget.potentialContributor['displayName']);
              });
            },
            value: _value,
          ),
          title: Text(widget.potentialContributor['displayName']),
          onTap: (){
            setState(() {
              _value = !_value;
              widget.toggleSelect(widget.potentialContributor['displayName']);
            });
          },
        ),
      ),
    );
  }
}