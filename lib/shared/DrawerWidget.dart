import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/services/database.dart';
import 'package:lester_apartments/shared/ProfilePictureWidget.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              trailing: FaIcon(FontAwesomeIcons.doorOpen),
              onTap: () async {
                DatabaseService().leaveApartment();
                Navigator.of(context).pop();
              },
            ),

            ListTile(
              title: Text('Log Out'),
              trailing: Icon(Icons.exit_to_app),
              onTap: () async {
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
