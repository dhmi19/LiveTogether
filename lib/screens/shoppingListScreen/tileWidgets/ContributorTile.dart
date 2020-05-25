import 'package:flutter/material.dart';
import 'package:lester_apartments/models/groceryItem.dart';

class ContributorTile extends StatefulWidget{

  final dynamic roommate;
  final Function toggleSelect;
  final GroceryItem groceryItem;

  const ContributorTile({
    @required this.roommate,
    @required this.toggleSelect,
    @required this.groceryItem
  });

  @override
  _ContributorTileState createState() => _ContributorTileState();
}

class _ContributorTileState extends State<ContributorTile> {

  bool _value;
  String roommateUsername;
  int roommateColor;
  String roommatePhotoURL;

  @override
  void initState() {
    super.initState();
    roommateUsername = widget.roommate['displayName'];
    roommateColor = widget.roommate['color'];
    roommatePhotoURL = widget.roommate['profilePictureURL'];

    if(widget.groceryItem.buyers.contains(roommateUsername)){
      _value = true;
    }
    else{
      _value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Material(
        color: Color(widget.roommate['color']),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: roommatePhotoURL != null? NetworkImage(roommatePhotoURL) : null,
            backgroundColor: roommatePhotoURL != null? null: Color(roommateColor),
          ),
          contentPadding: EdgeInsets.only(left: 10),
          trailing: Checkbox(
            onChanged: (bool value) {
              setState(() {
                _value = value;
                widget.toggleSelect(widget.roommate['displayName']);
              });
            },
            value: _value,
          ),
          title: Text(widget.roommate['displayName']),
          onTap: (){
            setState(() {
              _value = !_value;
              widget.toggleSelect(widget.roommate['displayName']);
            });
          },
        ),
      ),
    );
  }
}