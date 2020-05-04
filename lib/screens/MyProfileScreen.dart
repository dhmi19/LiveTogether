
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:path/path.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  final AuthService _auth = AuthService();

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

      setState(() {
        print("profile picture uploaded");
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Picture uploaded"),));
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,

        // FlatButton.icon(onPressed: () => {}, icon: Icon(Icons.menu), label: Text("")),
        title: Text("My Profile", style: TextStyle(color: Colors.black),),

        centerTitle: true,

        actions: <Widget>[
          FlatButton.icon(onPressed: () async {
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
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.purple,
                      child: ClipOval(
                        child: SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: (_image != null)? Image.file(_image, fit: BoxFit.fill,)
                              :Image.network("https://images.unsplash.com/photo-1565043589221-1a6fd9ae45c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=942&q=80",
                            fit: BoxFit.fill,),
                        ),
                      ),
                    ),
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
    );
  }
}
