import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';
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

    var currentUser = Provider.of<FirebaseUser>(context);

    print(currentUser == null);

    return Drawer(

      child: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 250,
              child: DrawerHeader(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance.collection("users").document(currentUser.uid).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    try{
                      final DocumentSnapshot documentSnapshot = snapshot.data;
                      final data = documentSnapshot.data;
                      final String displayName = data['displayName'];

                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(displayName != null ? displayName : "Options", style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primaryVariant),),

                            SizedBox(height: 20,),

                            ProfilePictureWidget(radius: 60.0)
                          ],
                        ),
                      );
                    }catch(error){
                      print(error);
                      return Center(child: Text(""));
                    }

                  }
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
                bool result;

                void onTapCallBack() async {
                  Navigator.pop(context);

                  result = await ApartmentServices.leaveApartment();

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
                }

                await showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return ConfirmationDialog(onTapCallBack: onTapCallBack,);
                  }
                );

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


class ConfirmationDialog extends StatelessWidget{

  final Function onTapCallBack;

  ConfirmationDialog({this.onTapCallBack});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure you want to leave apartment?"),
      actions: <Widget>[
        FlatButton(
          color: Theme.of(context).colorScheme.onSecondary,
          child: Text("Leave apartment",
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          ),
          onPressed: onTapCallBack,
        ),
        FlatButton(
          color: Theme.of(context).colorScheme.onSecondary,
          child: Text(
            "Cancel",
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ],
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
