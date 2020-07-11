
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lester_apartments/models/note.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';

class NoteServices {


  static final CollectionReference notesCollection = Firestore.instance.collection('notes');


  static Future<List> editNote(
      String title,
      String content,
      List newTags,
      Note note,
      List oldTagList,
      FirebaseUser currentUser) async{

    try{
      String apartmentName = await ApartmentServices.getCurrentApartmentName();

      if(apartmentName == null){
        return [false, "You are not part of an apartment. Join/Create an apartment to add items"];
      }

      DocumentReference documentReference =  notesCollection.document(apartmentName);

      if(newTags.contains("personal")){
        newTags.remove("personal");
        newTags.add("personal ${currentUser.displayName}");
      }

      await documentReference.updateData({
        "notes": FieldValue.arrayRemove([{
          'title': note.title,
          'content': note.content,
          'tags': oldTagList
        }]),
      });

      await documentReference.updateData({
        "notes": FieldValue.arrayUnion([{
          'title': title,
          'content': content,
          'tags': newTags
        }]),
      });

      return [true, "Your note was edited!"];
    }
    catch(error){
      print(error);
      return [false, "Sorry, there was an error. Please try again later :( "];
    }
  }

  static Future<bool> addNote(
      String title,
      String content,
      List tagList,
      FirebaseUser currentUser) async {
    try {
      String apartmentName = await ApartmentServices.getCurrentApartmentName();

      if (apartmentName == null) {
        return false;
      }

      DocumentReference documentReference = notesCollection.document(apartmentName);

      if(tagList.contains("personal")){
        tagList.remove("personal");
        tagList.add("personal ${currentUser.displayName}");
      }

      await documentReference.updateData({
        "notes": FieldValue.arrayUnion([{
          'title': title,
          'content': content,
          'tags': tagList
        }
        ]),
      });
      return true;
    }
    catch(error){
      print(error);
      return false;
    }
  }

  static Future<bool> deleteNote(Note note) async {
    try {
      String apartmentName = await ApartmentServices.getCurrentApartmentName();

      if (apartmentName == null) {
        return false;
      }

      DocumentReference documentReference = notesCollection.document(
          apartmentName);

      await documentReference.updateData({
        "notes": FieldValue.arrayRemove([{
          'title': note.title,
          'content': note.content,
          'tags': note.tags
        }
        ]),
      });
      return true;
    }
    catch(error){
      print(error);
      return false;
    }
  }

}