import 'package:flutter/material.dart';
import 'package:lester_apartments/models/Note.dart';
import 'package:lester_apartments/services/database/noteServices.dart';


class NoteCard extends StatelessWidget{

  final Note note;

  final int index;

  NoteCard({@required this.note, @required this.index});

  @override
  Widget build(BuildContext context) {

    String content = note.content;

    if(content.length > 500){
      content = content.substring(0, 500);
    }

    return GestureDetector(
      onDoubleTap: (){
        print("deleting note");
        NoteServices.deleteNote(note);
      },
      onTap: (){
        Navigator.of(context).pushNamed('/FullNoteScreen', arguments: note);
      },
      child: Container(
        decoration: BoxDecoration(
            color: (index % 3) == 0 ? Theme.of(context).colorScheme.onPrimary: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: (index % 3) == 0 ? Theme.of(context).colorScheme.secondary: Colors.white
            )
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15, right: 15),
            child: Column(
              children: <Widget>[
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primaryVariant
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
