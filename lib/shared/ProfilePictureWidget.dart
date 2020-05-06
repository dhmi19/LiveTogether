
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePictureWidget extends StatefulWidget {

  final double radius;
  ProfilePictureWidget({this.radius});

  @override
  _ProfilePictureWidgetState createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {


  @override
  Widget build(BuildContext context) {
    String _image;

    var currentUser = Provider.of<FirebaseUser>(context);

    /*
    if(users != null){
      for(var user in users.documents){
        if(user.documentID == AuthService.currentUser.uid){
          AuthService.currentUser.profilePictureURL = user.data['profilePictureURL'];
          _image = AuthService.currentUser.profilePictureURL;
          print(_image);
        }
      }
    }

     */

    _image = currentUser.photoUrl;

    /*
    child: (_image != null)? Image.network(_image, fit: BoxFit.fill,)
        :Image.network("https://images.unsplash.com/photo-1565043589221-1a6fd9ae45c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=942&q=80",
      fit: BoxFit.fill,),

     */

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: Colors.blue,
      child: CircleAvatar(
        radius: widget.radius - 5,
        backgroundImage: (_image != null)? NetworkImage(_image) : NetworkImage("https://images.unsplash.com/photo-1565043589221-1a6fd9ae45c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=942&q=80"),
      ),

    );
  }
}
