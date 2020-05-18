import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/models/Note.dart';
import 'package:lester_apartments/screens/sharedNotesScreen/sharedNotesWidgets/FolderNotesHeader.dart';
import 'package:lester_apartments/screens/sharedNotesScreen/sharedNotesWidgets/NoteCard.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';
import 'package:provider/provider.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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

                        final List<DocumentSnapshot> apartments = snapshot.data.documents;

                        for(DocumentSnapshot apartment in apartments){
                          List notes = apartment.data["notes"];
                          notes.forEach((note) {
                            Note currentNote = Note(
                                title: note['title'],
                                content: note['content'],
                                tags: note['tags']);

                            if(widget.screenTitle.toLowerCase() == "all notes"){
                              noteList.add(currentNote);
                            }
                            else if(currentNote.tags.contains(widget.screenTitle.toLowerCase())){
                              noteList.add(currentNote);
                            }
                            else if(widget.screenTitle.toLowerCase() == "personal"){
                              if(currentNote.tags.contains("${widget.screenTitle.toLowerCase()} ${currentUser.displayName}")){
                                noteList.add(currentNote);
                              }
                            }
                          });
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          itemCount: noteList.length,
                          itemBuilder: (BuildContext context, int index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2),
                            child: NoteCard(note: noteList[index], index: index,),
                          ),
                          staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(2, noteList[index].content.length > 100? 3 : 2),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        ),
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
        bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
          unselectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
          selectedItemColor: Theme.of(context).colorScheme.primaryVariant,
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.arrowLeft),
                title: Text("Back"),
                backgroundColor: Theme.of(context).colorScheme.primary
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
                backgroundColor: Theme.of(context).colorScheme.primary
            ),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.plus),
                title: Text("Add Note"),
                backgroundColor: Theme.of(context).colorScheme.primary
            ),
          ],
          onTap: (index) {
            if(index == 0){
              Navigator.pop(context);
            }
            else if(index == 1){
              Navigator.pushNamed(context, "/");
            }
            else if(index == 2){
              //Add note screen
              Navigator.pushReplacementNamed(context, "/FullNoteScreen", arguments: Note());
            }
          },
        ),
        drawer: DrawerWidget()
    );
  }
}


