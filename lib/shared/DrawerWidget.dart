
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/shared/ProfilePictureWidget.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {


  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    String _image;

    //TODO: The current user is not updating so it is referencing old photo url
    var currentUser = Provider.of<FirebaseUser>(context);
    _image = currentUser.photoUrl;
    print("The drawer is showing: "+_image);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 250,
            child: DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Options", style: TextStyle(fontSize: 20, color: Colors.white),),

                  SizedBox(height: 20,),
/*
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.purple,
                    child: ClipOval(
                      child: SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child: (_image != null)? Image.network(_image, fit: BoxFit.fill,)
                            :Image.network("https://images.unsplash.com/photo-1565043589221-1a6fd9ae45c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=942&q=80",
                          fit: BoxFit.fill,),
                      ),
                    ),
                  )
                  */
                  ProfilePictureWidget(radius: 60.0)
                ],
              ),

              decoration: BoxDecoration(
                  color: Colors.red[400],
              ),
            ),
          ),

          ListTile(
            title: Text('Edit Profile'),
            trailing: Icon(Icons.person),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/MyProfileScreen');
            },
          ),

          ListTile(
            title: Text('Leave Apartment'),
            trailing: Icon(Icons.directions_run),
            onTap: () async {
              Navigator.of(context).pop();
            },
          ),

          ListTile(
            title: Text('Log Out'),
            trailing: Icon(Icons.exit_to_app),
            onTap: () async {
              //TODO: Make apartment data null in static context
              Navigator.of(context).pop();
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
