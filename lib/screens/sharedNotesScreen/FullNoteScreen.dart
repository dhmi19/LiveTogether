import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lester_apartments/models/Note.dart';
import 'package:lester_apartments/screens/sharedNotesScreen/sharedNotesWidgets/TagButton.dart';
import 'package:lester_apartments/services/database.dart';

class FullNoteScreen extends StatefulWidget {

  final Note note;

  FullNoteScreen({@required this.note});

  @override
  _FullNoteScreenState createState() => _FullNoteScreenState();
}

class _FullNoteScreenState extends State<FullNoteScreen> {

  List oldTags = List();

  void addTagCallBack(String tag){
    if(!widget.note.tags.contains(tag)){
      widget.note.tags.add(tag);
    }
  }

  void removeTagCallBack(String tag){
    if(widget.note.tags.contains(tag)){
      widget.note.tags.remove(tag);
    }
  }

  @override
  void initState() {
    super.initState();

    if(widget.note.tags != null){
      widget.note.tags.forEach((tag) {
        oldTags.add(tag);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController noteTitleController = TextEditingController(
        text: widget.note.title != null ? widget.note.title.toUpperCase() : null
    );
    TextEditingController noteContentController = TextEditingController(
        text:  widget.note.content != null ? widget.note.content : null)
    ;

    List<Widget> tagButtonList = List<Widget>();

    Note.allTags.forEach((tag) {
      tagButtonList.add(
        TagButton(
          tag: tag,
          selectedTags: widget.note.tags,
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
        leading: FullNoteScreenBackButton(
            noteTitleController: noteTitleController,
            noteContentController: noteContentController,
            newTagList: widget.note.tags,
            note: widget.note,
            oldTags: oldTags,
        ),
        title: Text(
          widget.note.title != null ? "": "New Note",
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
                  hintText: noteTitleController.text == "" ? "Title" : ""
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
                  hintText: noteContentController.text == "" ? "Enter content text here" : ""
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

class FullNoteScreenBackButton extends StatelessWidget {
  const FullNoteScreenBackButton({
    Key key,
    @required this.noteTitleController,
    @required this.noteContentController,
    @required this.newTagList,
    @required this.note,
    @required this.oldTags,
  }) : super(key: key);

  final TextEditingController noteTitleController;
  final TextEditingController noteContentController;
  final List newTagList;
  final Note note;
  final List oldTags;

  @override
  Widget build(BuildContext context) {

    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () async {
        await DatabaseService().editNote(
            noteTitleController.text,
            noteContentController.text,
            newTagList,
            note,
            oldTags
        );

        Navigator.pop(context);
      },
    );
  }
}
