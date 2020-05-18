import 'package:flutter/material.dart';
import 'package:lester_apartments/models/Note.dart';

class FullNoteScreen extends StatelessWidget {

  final Note note;

  FullNoteScreen({@required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,

        title: Text(
          note.title != null ? note.title: "New Note",
          style: TextStyle(color: Colors.black),
        ),

        centerTitle: true,

      ),

      body: ,
    );
  }
}
