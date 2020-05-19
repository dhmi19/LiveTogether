import 'package:flutter/material.dart';
import 'package:lester_apartments/models/Note.dart';
import 'package:lester_apartments/screens/sharedNotesScreen/sharedNotesWidgets/TagButton.dart';
import 'package:lester_apartments/services/database.dart';

class NewNoteScreen extends StatefulWidget {
  @override
  _NewNoteScreenState createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {

  List tagList = List();

  void addTagCallBack(String tag){
    if(!tagList.contains(tag)){
      tagList.add(tag);
    }
  }

  void removeTagCallBack(String tag){
    if(tagList.contains(tag)){
      tagList.remove(tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController noteTitleController = TextEditingController();
    TextEditingController noteContentController = TextEditingController();

    List<Widget> tagButtonList = List<Widget>();

    Note.allTags.forEach((tag) {
      tagButtonList.add(
          TagButton(
            tag: tag,
            selectedTags: tagList,
            addTag: addTagCallBack,
            removeTag: removeTagCallBack,
          )
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        leading: NewNoteScreenBackButton(
          noteTitleController: noteTitleController,
          noteContentController: noteContentController,
          newTagList: tagList,
        ),
        title: Text(
          "New Note",
          style: TextStyle(color: Colors.black),
        ),

        centerTitle: true,

      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Title"
                ),
                controller: noteTitleController,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            Container(
              width: double.infinity,
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: tagButtonList
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Enter content text here"
                ),
                controller: noteContentController,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewNoteScreenBackButton extends StatelessWidget {

  final TextEditingController noteTitleController;
  final TextEditingController noteContentController;
  final List newTagList;

  NewNoteScreenBackButton({this.noteTitleController, this.noteContentController, this.newTagList});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () async {
        print(noteTitleController.text);
        print(noteContentController.text);
        if(noteTitleController.text != "" && noteContentController.text != ""){
          await DatabaseService().addNote(
            noteTitleController.text,
            noteContentController.text,
            newTagList.isEmpty? ['shared'] : newTagList,
          );
        }

        Navigator.pop(context);
      },
    );
  }
}

