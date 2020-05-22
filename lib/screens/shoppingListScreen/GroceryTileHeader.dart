import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroceryTileHeader extends StatelessWidget {

  final String listOfBuyers;
  final String apartmentName;

  GroceryTileHeader({
    @required this.listOfBuyers,
    @required this.apartmentName
  });


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection("apartments").document(apartmentName).snapshots(),
      builder: (context, snapshot) {
        try{

          final DocumentSnapshot documentSnapshot = snapshot.data;
          final data = documentSnapshot.data;
          final List roommateList = data['roommateList'];

          final Map<String, int> roommateUsernames = Map<String, int>();
          final List<String> buyerList = listOfBuyers.split(",");


          roommateList.forEach((roommate) {
            String userName = roommate['displayName'];
            int userColor = roommate['color'];
            roommateUsernames[userName] = userColor;
          });

          final List<Widget> bookmarkList = List<Widget>();

          buyerList.forEach((String buyer) {
            int buyerColor = roommateUsernames[buyer];
            Widget bookmark = Icon(
              Icons.bookmark,
              color: buyerColor != null ? Color(buyerColor): Colors.black,
              size: 30,
            );
            bookmarkList.add(bookmark);
          });

          return Container(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: bookmarkList,
            ),
          );
        }
        catch(error) {
          print(error);
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.bookmark,
                color: Colors.black,
                size: 30,
              ),
            ],
          );
        }
      }
    );
  }
}
