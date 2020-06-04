import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';
import 'package:lester_apartments/services/database/userServices.dart';
import 'package:lester_apartments/shared/ChangeColorButton.dart';
import 'package:lester_apartments/shared/ProfilePictureWidget.dart';
import 'package:provider/provider.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';

import 'AddRoommateWidget.dart';
import 'NewApartmentWidget.dart';


const checkButton = Icon(Icons.check_circle, size: 20, color: Colors.green);
const editButton = Icon(Icons.edit, size: 20, color: Colors.orange,);

class AboutMeWidget extends StatefulWidget {

  @override
  _AboutMeWidgetState createState() => _AboutMeWidgetState();
}

class _AboutMeWidgetState extends State<AboutMeWidget> {

  static String currentBio;
  FocusNode myFocusNode = FocusNode();
  Icon editIcon = editButton;
  TextEditingController bioController;

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<FirebaseUser>(context);

    return StreamProvider<List<Apartment>>.value(
      value: ApartmentServices().apartments,
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primaryVariant),
            elevation: 0,
            title: Text("", style: TextStyle(color: Colors.white),),

            centerTitle: true,

          ),

          body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: UserServices.userCollection.document(currentUser.uid).snapshots(),
                    builder: (context, snapshot) {

                      String apartmentName;

                      try{

                        apartmentName = snapshot.data.data['apartment'];

                      }catch(error){
                        print(error);
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Text(
                            "Hi ${currentUser.displayName}",
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),

                          SizedBox(height: 80,),

                          StreamBuilder<DocumentSnapshot>(
                            stream: ApartmentServices.apartmentCollection.document(apartmentName).snapshots(),
                            builder: (context, snapshot) {

                              try{
                                int color;

                                DocumentSnapshot documentSnapshot = snapshot.data;

                                if(documentSnapshot != null){

                                  List roommateList = List();

                                  roommateList = documentSnapshot.data['roommateList'];

                                  for(var roommate in roommateList){
                                    if(roommate['displayName'] == currentUser.displayName){
                                      color = roommate['color'];
                                      break;
                                    }
                                  }
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                      color:  Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),

                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0, top: 8.0),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(Icons.bookmark, color: Color(color), size: 40,),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          ProfilePictureWidget(radius: 60,),
                                          ChangeColorButton()
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Container(
                                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "About me:",
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),

                                                IconButton(
                                                  icon: editIcon,
                                                  onPressed: () async {
                                                    if(editIcon == editButton){
                                                      setState(() {
                                                        myFocusNode.requestFocus();
                                                        editIcon = checkButton;
                                                      });
                                                    }else{
                                                      print(currentBio);
                                                      await UserServices.updateUserBio(bioController.text);
                                                      setState(() {
                                                        myFocusNode.unfocus();
                                                        editIcon = editButton;
                                                      });
                                                    }
                                                  },
                                                )
                                              ],
                                            ),

                                            StreamBuilder<QuerySnapshot>(
                                                stream: UserServices.userCollection.where('displayName', isEqualTo: currentUser.displayName).snapshots(),
                                                builder: (context, snapshot) {
                                                  try{

                                                    QuerySnapshot querySnapshot = snapshot.data;
                                                    List<DocumentSnapshot> documents = querySnapshot.documents;

                                                    for(var doc in documents){
                                                      if(doc.data['bio'] == null){
                                                        currentBio = " ";
                                                        break;
                                                      }else{
                                                        currentBio = doc.data['bio'];
                                                        break;
                                                      }
                                                    }

                                                    bioController = TextEditingController(text: currentBio);

                                                    return TextField(
                                                      maxLines: 2,
                                                      maxLength: 180,
                                                      keyboardType: TextInputType.multiline,
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                      ),
                                                      controller: bioController,
                                                      focusNode: myFocusNode,
                                                    );
                                                  }
                                                  catch(error){
                                                    print(error);
                                                    return Text("");
                                                  }

                                                }
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                              }catch(error){
                                print(error);
                                return Text("");
                              }
                            }
                          ),
                          SizedBox(height: 10,),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                NewApartmentWidget(currentUser: currentUser,),

                                AddRoommateWidget(currentUser: currentUser,),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                ),
              )
          ),

          drawer: DrawerWidget()
      ),
    );
  }
}


