
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/main.dart';
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


  String uid = AuthService.currentUser.uid;
  final _formKey = GlobalKey<FormState>();


  File _image;

  String _email = '';
  String _password = '';
  String _username = '';


  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('Image path $_image');
    });
    return _image;
  }

/*
Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      print('Image path $_image');
    });
  }
 */

  Future uploadImage(BuildContext context) async{

    String fileName = basename(_image.path);
    StorageReference firebaseStorageReference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    String imageURL = await FirebaseStorage.instance.ref().child(fileName).getDownloadURL();
    print("location of image in storage is: "+ imageURL);
    DatabaseService(uid: uid).updateProfilePicture(imageURL);

    setState(() {
      print("profile picture uploaded, changes should be visible now.");
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Picture uploaded"),));
    });

  }

  @override
  Widget build(BuildContext context) {

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

        ),

        body: Builder(
          builder: (context) => Center(
            child: SingleChildScrollView(
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
                        onPressed: () async{
                          await getImageFromGallery();

                          setState(() {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("New picture will show once changes have been submitted."),));
                          });
                        },
                      ),
                    ],
                  ),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[

                        SizedBox(height: 10,),

                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              /*boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, 0.2),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )]

                               */
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.green))
                                ),
                                child: TextFormField(
                                  validator: (val) {
                                    if(val.length != 0 && val.length < 6){
                                      return "Password must be more than 6 letters";
                                    }else{
                                      return null;
                                    }
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: "Enter new password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                  onChanged: (val){
                                    setState(() {
                                      _password = val;
                                    });
                                  },
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.green))
                                ),
                                child: TextFormField(
                                  validator: (val) {
                                    if(val.length != 0 && val.length < 6){
                                      return "Password must be more than 6 letters";
                                    } else if(val != _password){
                                      return "Password does not match above";
                                    }
                                    else{
                                      return null;
                                    }
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: "Re-enter new password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                  onChanged: (val){
                                    setState(() {
                                      _password = val;
                                    });
                                  },
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.green))
                                ),
                                child: TextFormField(
                                  validator: (val) {
                                    if(val.length != 0 && val.length < 6){
                                      return "Username must be more than 6 letters";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Re-enter Username",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                  onChanged: (val){
                                    setState(() {
                                      _username = val;
                                    });
                                  },
                                ),
                              ),


                            ],
                          ),
                        ),
                        SizedBox(height: 40,),

                        Container(
                          width: 150,
                          child: RaisedButton(
                            color: Colors.orange[900],
                            child: Text("Submit", style: TextStyle(color: Colors.white),),
                            onPressed: () async {

                              if(_formKey.currentState.validate()) {
                                await DatabaseService(uid: uid).updateUserDetails(_email, _password, _username);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text("Success!"),
                                        content: Text("Details were updated sucessfully"),
                                        actions: [
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ]
                                      );
                                    }
                                );
                              }

                              if(_image != null){
                                uploadImage(context);
                              }
                            },
                          ),
                        ),


                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
