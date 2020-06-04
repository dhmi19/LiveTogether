import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';
import 'package:lester_apartments/services/database/userServices.dart';
import 'package:provider/provider.dart';

class ChangeColorButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final FirebaseUser currentUser = Provider.of<FirebaseUser>(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: UserServices.userCollection.document(currentUser.uid).snapshots(),
      builder: (context, snapshot) {
        try{

          DocumentSnapshot document = snapshot.data;

          String apartmentName;
          String profilePitureURL;

          if(document != null){
            apartmentName = document.data['apartment'];
            profilePitureURL = document.data['profilePictureURL'];
          }

          return IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: () async {
              int selectedColor;

              void selectColorCallBack(int _selectedColor) async {
                selectedColor = _selectedColor;
                await ApartmentServices.updateColor(selectedColor, apartmentName,profilePitureURL);
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
                              stream: Firestore.instance.collection("apartments").document(apartmentName).snapshots(),
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
        }catch(error){
          print(error);
          return Text("");
        }
      }
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