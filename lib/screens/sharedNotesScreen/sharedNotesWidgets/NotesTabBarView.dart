import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/models/note.dart';
import 'package:lester_apartments/services/database/noteServices.dart';
import 'package:provider/provider.dart';


class NotesTabView extends StatelessWidget {

  final String tag;

  NotesTabView({this.tag});

  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<FirebaseUser>(context);

    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("notes").snapshots(),
              builder: (context, snapshot) {
                try{

                  List<Note> noteList = List<Note>();

                  if(!snapshot.hasData){
                    return Text("");
                  }

                  if(snapshot.hasData){
                    final List<DocumentSnapshot> apartments = snapshot.data.documents;
                    for(DocumentSnapshot apartment in apartments){
                      List tempRoommateList = apartment.data["roommateList"];
                      if(tempRoommateList.contains(currentUser.displayName)){
                        List notes = apartment.data["notes"];
                        notes.forEach((note) {
                          Note currentNote = Note(
                              title: note['title'],
                              content: note['content'],
                              tags: note['tags']);

                          if(currentNote.tags.contains(tag.toLowerCase())){
                            noteList.add(currentNote);
                          }
                        });
                      }
                    }
                  }

                  if(noteList.length == 0){

                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FaIcon(
                              FontAwesomeIcons.frownOpen,
                              size: 50,
                              color: Theme.of(context).colorScheme.primaryVariant,),

                            SizedBox(height: 20,),

                            Text(
                              tag.contains("personal") ? "You don't have any personal notes" :
                              "You don't have any $tag notes",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primaryVariant
                              ),
                            ),
                          ],
                        )
                    );

                  }else{
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: noteList.length,
                        itemBuilder: (BuildContext context, int index){
                          return buildNotePreview(noteList[index], context);
                        }
                    );
                  }

                }
                catch(error){
                  print(error);
                  return Center(
                      child: Text("")
                  );
                }
              }
          ),
        )
      ],
    );
  }
}

Widget buildNotePreview(Note note, BuildContext context){

  String contentPreview = note.content;

  if(contentPreview.length > 50){
    contentPreview = contentPreview.substring(0,50) + "...";
  }

  return ListTile(
    title: Text(note.title),
    isThreeLine: true,
    subtitle: Text(contentPreview),
    onTap: (){
      Navigator.of(context).pushNamed('/FullNoteScreen', arguments: note);
    },
    trailing: IconButton(
      icon:FaIcon(FontAwesomeIcons.trash) ,
      onPressed: (){
        NoteServices.deleteNote(note);
      },
      iconSize: 20,
    ),
  );
}