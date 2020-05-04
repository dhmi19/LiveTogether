
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/screens/ProfilePicWidget.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:path/path.dart';

import 'package:lester_apartments/services/database.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  final AuthService _auth = AuthService();
  String uid = AuthService.currentUser.uid;

  File _image;

  @override
  Widget build(BuildContext context) {

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print('Image path $_image');
      });
    }


    Future uploadImage(BuildContext context) async{

      String fileName = basename(_image.path);
      StorageReference firebaseStorageReference = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageReference.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      String imageURL = await FirebaseStorage.instance.ref().child(fileName).getDownloadURL();
      print("location of image in storage is: "+ imageURL);
      DatabaseService(uid: uid).updateProfilePicture(imageURL);

      setState(() {
        print("profile picture uploaded");
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Picture uploaded"),));
      });

    }

    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().users,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,

          // FlatButton.icon(onPressed: () => {}, icon: Icon(Icons.menu), label: Text("")),
          title: Text("My Profile", style: TextStyle(color: Colors.black),),

          centerTitle: true,

          actions: <Widget>[
            FlatButton.icon(onPressed: () async {
              Navigator.of(context).pop();
              await _auth.signOut();
              }, icon: Icon(Icons.exit_to_app), label: Text(""))
          ],
        ),

        body: Builder(
          builder: (context) => Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: ProfilePictureWidget()
                    ),

                   IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.black, size: 30,),
                      onPressed: () {
                        getImage();
                        print("image icon clicked");
                      },
                    ),
                  ],
                ),

                //TODO: add the ability to edit usernames and passwords and other details too

                RaisedButton(
                  color: Colors.redAccent,
                  child: Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  elevation: 0,
                  splashColor: Colors.blue,
                  onPressed: (){
                      uploadImage(context);
                  },

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
