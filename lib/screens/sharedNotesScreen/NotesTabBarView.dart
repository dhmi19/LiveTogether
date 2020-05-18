import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/models/Note.dart';
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
                    return Text("Sorry, data was not found");
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

                          if(currentNote.tags.contains(tag)){
                            noteList.add(currentNote);
                          }
                        });
                      }
                    }
                  }

                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: noteList.length,
                      itemBuilder: (BuildContext context, int index){
                        return buildNotePreview(
                            noteList[index].title,
                            noteList[index].content,
                            noteList[index].tags
                        );
                      }
                  );
                }
                catch(error){
                  print(error);
                  return Center(
                      child: Text("Sorry, there was an error. Please try again later")
                  );
                }
              }
          ),
        )
      ],
    );
  }
}

Widget buildNotePreview(String title, String content, List tags){

  if(content.length > 50){
    content = content.substring(0,50) + "...";
  }

  return ListTile(
    title: Text(title),
    isThreeLine: true,
    subtitle: Text(content),
    onTap: (){
      print("Note clicked, take to full page note preview");
    },
    trailing: IconButton(
      icon:FaIcon(FontAwesomeIcons.trash) ,
      onPressed: (){
        print("deleting note");
      },
      iconSize: 20,
    ),
  );
}