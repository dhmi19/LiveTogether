
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/constants.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';
import 'package:provider/provider.dart';


class RoommateTile extends StatelessWidget {

  final Apartment apartment;
  final List roommateList;
  final int index;
  RoommateTile({this.apartment, this.roommateList, this.index});

  @override
  Widget build(BuildContext context) {

    final FirebaseUser currentUser = Provider.of<FirebaseUser>(context);

    Color tileColor = kDarkBlue;

    String userName = roommateList[index]["displayName"];

    bool isMe;

    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection("apartments").document(apartment.apartmentName).snapshots(),
      builder: (context, snapshot) {

        try{
          print(snapshot.hasData);
          final DocumentSnapshot documentSnapshot = snapshot.data;
          final data = documentSnapshot.data;
          final List roommateList = data['roommateList'];

          for(var roommate in roommateList){
            if(roommate['displayName'] == roommateList[index]['displayName']){
              tileColor = Color(roommate['color']);
            }
          }

          if(roommateList[index]['displayName'] == currentUser.displayName){
            isMe = true;
          }else{
            isMe = false;
          }

          return Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Card(
              color: tileColor,
              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(roommateList[index]["profilePictureURL"]),
                  ),
                  title: Text(userName),
                  trailing: isMe? CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                    foregroundColor: Colors.white,
                    child: ChangeColorButton(apartment: apartment),
                  ) : null,
                ),
              ),
            ),
          );
        }catch(error){
          print(error);
          return Text("");
        }
      }
    );
  }
}

class ChangeColorButton extends StatelessWidget {
  const ChangeColorButton({
    Key key,
    @required this.apartment,
  }) : super(key: key);

  final Apartment apartment;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.color_lens),
      onPressed: () async {
        int selectedColor;

        void selectColorCallBack(int _selectedColor) async {
          selectedColor = _selectedColor;
          await ApartmentServices.updateColor(selectedColor, apartment.apartmentName);
        }

        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Pick Color"),
              content: Container(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Select a color from the options below:"),
                    SizedBox(height: 10,),
                    StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection("apartments").document(apartment.apartmentName).snapshots(),
                      builder: (BuildContext context, snapshot) {
                        try{
                          final DocumentSnapshot documentSnapshot = snapshot.data;
                          final data = documentSnapshot.data;
                          List availableColors = data["availableColors"];

                          List<Widget> colorOptions = List<Widget>();

                          availableColors.forEach((color) {
                            ColorOption colorOption = ColorOption(
                              color: color,
                              onTapCallBack: selectColorCallBack,
                            );
                            colorOptions.add(colorOption);
                          });
                          return Container(
                            height: 200,
                            child: GridView.count(
                              crossAxisCount: 4,
                              children: colorOptions,
                            ),
                          );
                        }
                        catch(error) {
                          print(error);
                          return Text("Sorry, could not find colors. Please try again later");
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }
}

class ColorOption extends StatelessWidget {

  final Function onTapCallBack;
  final int color;

  const ColorOption({this.onTapCallBack, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTapCallBack(color);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 10,
          backgroundColor: Color(color),
        ),
      ),
    );
  }
}
