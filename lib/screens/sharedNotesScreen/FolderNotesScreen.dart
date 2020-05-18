import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/models/Note.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';
import 'package:provider/provider.dart';

class FolderNotesScreen extends StatefulWidget {

  final String screenTitle;

  FolderNotesScreen({@required this.screenTitle});

  @override
  _FolderNotesScreenState createState() => _FolderNotesScreenState();
}

class _FolderNotesScreenState extends State<FolderNotesScreen> with SingleTickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<FirebaseUser>(context);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,

          title: Text(widget.screenTitle, style: TextStyle(color: Colors.black),),
          centerTitle: true,
        ),

        body: SafeArea(
          child: Column(
            children: <Widget>[
              FolderNotesHeader(currentUser: currentUser, widget: widget),

              SizedBox(height: 30,),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection("notes").where("roommateList", arrayContains: currentUser.displayName).snapshots(),
                  builder: (BuildContext context, snapshot) {
                    try{

                      List<Note> noteList = List<Note>();

                      if(!snapshot.hasData){
                        return Text("Sorry, data was not found");
                      }

                      if(snapshot.hasData){
                        List<DocumentSnapshot> documents = snapshot.data.documents;

                        for(var doc in documents){
                          print(doc.data);
                        }

                      }

                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: noteList.length,
                          itemBuilder: (BuildContext context, int index){
                            return Text(index.toString());
                          }
                      );
                    }
                    catch(error){
                      print(error);
                      return Center(
                          child: Text("Sorry, there was an error. Please try again later")
                      );
                    }
                  },

                ),
              )
            ],
          ),
        ),

        drawer: DrawerWidget()
    );
  }
}

class FolderNotesHeader extends StatelessWidget {
  const FolderNotesHeader({
    Key key,
    @required this.currentUser,
    @required this.widget,
  }) : super(key: key);

  final FirebaseUser currentUser;
  final FolderNotesScreen widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Hi ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text("${currentUser.displayName},",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "These are your ${widget.screenTitle.toLowerCase()} notes",
                  style: TextStyle(fontSize: 14),
                ),
              )
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.only(right: 40.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(currentUser.photoUrl),
            radius: 35,
          ),
        )
      ],
    );
  }
}