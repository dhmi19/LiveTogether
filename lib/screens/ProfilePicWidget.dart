import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:provider/provider.dart';

class ProfilePictureWidget extends StatefulWidget {
  @override
  _ProfilePictureWidgetState createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {

  String _image;

  @override
  Widget build(BuildContext context) {

    final users = Provider.of<QuerySnapshot>(context);

    print("Current userID: "+ AuthService.currentUser.uid);

    if(users != null){
      for(var user in users.documents){
        if(user.documentID == AuthService.currentUser.uid){
          AuthService.currentUser.profilePictureURL = user.data['profilePictureURL'];
          _image = AuthService.currentUser.profilePictureURL;
          print(_image);
        }
      }
    }


    return CircleAvatar(
      radius: 100,
      backgroundColor: Colors.purple,
      child: ClipOval(
        child: SizedBox(
          width: 180.0,
          height: 180.0,
          child: (_image != null)? Image.network(_image, fit: BoxFit.fill,)
              :Image.network("https://images.unsplash.com/photo-1565043589221-1a6fd9ae45c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=942&q=80",
            fit: BoxFit.fill,),
        ),
      ),
    );
  }
}
