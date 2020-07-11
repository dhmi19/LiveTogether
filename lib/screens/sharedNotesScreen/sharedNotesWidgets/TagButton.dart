import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagButton extends StatefulWidget{

  final String tag;
  final List selectedTags;

  final Function addTag;
  final Function removeTag;

  TagButton({this.tag, this.selectedTags, this.addTag, this.removeTag});

  @override
  _TagButtonState createState() => _TagButtonState();
}

class _TagButtonState extends State<TagButton> {

  bool isSelected;

  @override
  Widget build(BuildContext context) {

    final FirebaseUser currentUser = Provider.of<FirebaseUser>(context);

    if(widget.selectedTags.contains(widget.tag)){
      isSelected = true;
    }
    else if((widget.tag == "personal") &&
        (widget.selectedTags.contains("personal ${currentUser.displayName}"))){
      isSelected = true;
    }
    else{
      isSelected = false;
    }

    return GestureDetector(
      onTap: (){
        setState(() {
          if(!isSelected){
            widget.addTag(widget.tag);
          }else{
            if(widget.tag == "personal"){
              widget.removeTag("personal");
            }else{
              widget.removeTag(widget.tag);
            }
          }
        });
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: isSelected? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onPrimary,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondaryVariant
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Text(widget.tag)
          ),
        ),
      ),
    );
  }
}