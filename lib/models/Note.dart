import 'package:flutter/material.dart';

class Note{

  String title;

  String content;

  List<dynamic> tags;

  Note({this.title, this.content, @required this.tags});

  static final List<String> allTags = ['important', 'personal', 'shared', 'others'];

}