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

    //TODO: The current user is not updating so it is referencing old photo url
    var currentUser = Provider.of<FirebaseUser>(context);

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
                bool result = await DatabaseService().leaveApartment();
                Navigator.of(context).pop();
                if(result == true){
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return LeaveApartmentAlertDialog(title: "Success", description: "You have left the apartment",);
                      }
                  );
                }
                else{
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return LeaveApartmentAlertDialog(title: "Error", description: "Sorry, please try again later :(",);
                      }
                  );
                }

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

class LeaveApartmentAlertDialog extends StatelessWidget {

  final String title;
  final String description;

  LeaveApartmentAlertDialog({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: <Widget>[
        FlatButton(
          child: Text("OK"),
          onPressed: (){
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
