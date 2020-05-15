
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

    return Drawer(

      child: Container(
        color: Theme.of(context).colorScheme.onPrimary,
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
                    Text(currentUser.displayName, style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primaryVariant),),

                    SizedBox(height: 20,),

                    ProfilePictureWidget(radius: 60.0)
                  ],
                ),

                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryVariant,
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
              //TODO: Make it into abhi icon
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
      ),
    );
  }
}
