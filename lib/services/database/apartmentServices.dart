import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:lester_apartments/services/database/userServices.dart';

import '../../constants.dart';

class ApartmentServices{

  //Collection reference:
  static final CollectionReference userCollection = Firestore.instance.collection('users');
  static final CollectionReference apartmentCollection = Firestore.instance.collection('apartments');
  static final CollectionReference groceriesCollection = Firestore.instance.collection('groceries');
  static final CollectionReference notesCollection = Firestore.instance.collection('notes');

  static final String defaultProfilePictureURL = "https://images.unsplash.com/photo-1565043589221-1a6fd9ae45c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=942&q=80";

  List<Apartment> _apartmentListFromSnapshot(QuerySnapshot snapshot){

    List list = snapshot.documents.map((document){
      return Apartment(
          apartmentName: document.documentID ?? '',
          roommateList: document.data["roommateList"] ?? []
      );
    }).toList();

    return list;
  }

  //Get Apartment Streams
  Stream<List<Apartment>> get apartments {
    return apartmentCollection.snapshots().map(_apartmentListFromSnapshot);
  }



  static Future getAvailableColors(String apartmentName) async{

    try{

      final DocumentSnapshot documentSnapshot = await Firestore.instance.collection("apartments").document(apartmentName).get();
      final data = documentSnapshot.data;
      return data['availableColors'];

    }catch(error){
      print(error);
      return null;
    }
  }

  static void returnColor(int color, String apartmentName) {
    final DocumentReference documentReference = Firestore.instance.collection("apartments").document(apartmentName);

    documentReference.updateData({
      "availableColors": FieldValue.arrayUnion([color])
    });
  }

  static Future updateColor(int selectedColor, String apartmentName) async {

    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    final DocumentReference documentReference = Firestore.instance
        .collection("apartments").document(apartmentName);

    final DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection("apartments").document(apartmentName).get();

    final data = documentSnapshot.data;

    final roommateList = data["roommateList"];

    for(var roommate in roommateList){
      if(roommate['displayName'] == currentUser.displayName){
        returnColor(roommate['color'], apartmentName);

        //Remove roommate:
        await documentReference.updateData({
          "roommateList": FieldValue.arrayRemove([{
            'color': roommate["color"],
            'displayName': currentUser.displayName,
            'profilePictureURL': currentUser.photoUrl,
          }])
        });

        //Add roommate again:
        await documentReference.updateData({
          "roommateList": FieldValue.arrayUnion([{
            'color': selectedColor,
            'displayName': currentUser.displayName,
            'profilePictureURL': currentUser.photoUrl,
          }])
        });

        print(selectedColor);

        //Remove color from available colors:
        await documentReference.updateData({
          "availableColors": FieldValue.arrayRemove([selectedColor])
        });
      }
    }
  }

  static int getRandomColor(List availableColors){
    int length = availableColors.length;
    int index = Random().nextInt(length);
    return availableColors[index];
  }

  static Future addNewRoommate(String newRoommateUsername) async{

    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String newRoommateProfilePicURL;

    //Check if currentUser has an apartment already
    final isCurrentUserHomeless = await doesUserHaveAnApartment(currentUser.uid);

    if(isCurrentUserHomeless){
      return null;
    }

    //Check if roommate is already in an apartment
    final isRoommateHomeless = await doesUserHaveAnApartment(newRoommateUsername);


    if(!isRoommateHomeless){

      //Get apartment name:
      String _apartmentName = await getCurrentApartmentName();

      //get the profile picture url of new roommate:
      final profilePictureResult = await UserServices.getProfilePictureURL(newRoommateUsername);

      if(profilePictureResult == null){
        newRoommateProfilePicURL = defaultProfilePictureURL;
      }else{
        newRoommateProfilePicURL = profilePictureResult;
      }

      //Update apartment roommate list:
      List availableColors = await getAvailableColors(_apartmentName);
      final int tileColor = getRandomColor(availableColors);

      DocumentReference documentReference =  apartmentCollection.document(_apartmentName);

      //Add roommate to list and assign them a color
      documentReference.updateData({
        "roommateList": FieldValue.arrayUnion([{
          'displayName': newRoommateUsername,
          'profilePictureURL': newRoommateProfilePicURL,
          'color': tileColor
        }]),
      });

      //Remove the assigned color from the availableColors list
      documentReference.updateData({
        "availableColors": FieldValue.arrayRemove([tileColor]),
      });

      //Add roommate to groceries collection
      groceriesCollection.document(_apartmentName).updateData({
        "roommateList": FieldValue.arrayUnion([newRoommateUsername])
      });

      //Add roommate to notes collection
      notesCollection.document(_apartmentName).updateData({
        "roommateList": FieldValue.arrayUnion([newRoommateUsername])
      });

      //Update the roommate's users document:
      final QuerySnapshot querySnapshot = await userCollection.where("displayName", isEqualTo: newRoommateUsername).getDocuments();
      List<DocumentSnapshot> documents = querySnapshot.documents;

      String documentId;

      for(var doc in documents){
        documentId = doc.documentID;
        break;
      }

      await userCollection.document(documentId).updateData({'apartment': _apartmentName});

      return true;
    }
    else{
      return null;
    }

  }

  static Future<List> createNewApartment(String apartmentName) async{

    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    //Get the profile picture URL of the current user
    String profilePictureURL = await UserServices.getProfilePictureURL(currentUser.displayName);

    if(profilePictureURL == null){
      profilePictureURL = defaultProfilePictureURL;
    }

    final isUserHomeless = await doesUserHaveAnApartment(currentUser.displayName);

    if(isUserHomeless == false){
      return [false, "You already have an apartment"];
    }

    final documentSnapshot = await apartmentCollection.document(apartmentName).get();

    if((documentSnapshot == null || !documentSnapshot.exists) && isUserHomeless == true){

      await apartmentCollection.document(apartmentName).setData({
        "roommateList": [{
          'displayName': currentUser.displayName,
          'profilePictureURL': profilePictureURL,
          'color': kOrange.value, }],
        "availableColors": kAvailableColors
      });

      await userCollection.document(currentUser.uid).updateData({
        "apartment": apartmentName
      });

      //Create new document for groceries
      await groceriesCollection.document(apartmentName).setData({
        "roommateList": [currentUser.displayName]
      });


      //Create new document for notes
      await notesCollection.document(apartmentName).setData({
        "roommateList": [currentUser.displayName],
        "notes": []
      });

      return [true, "Welcome to your new apartment!"];
    }
    else{
      return [false,  "Sorry, the apartment name is already taken"];
    }
  }

  static Future doesUserHaveAnApartment(String userName) async {

    final currentUser = await FirebaseAuth.instance.currentUser();

    final DocumentSnapshot documentSnapshot = await userCollection.document(currentUser.uid).get();
    final String apartmentName = documentSnapshot.data['apartment'];

    if(apartmentName == ""){
      return true;
    }else{
      return false;
    }
  }

  static Future<String> getCurrentApartmentName() async {
    try{
      final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      final DocumentSnapshot documentSnapshot = await Firestore.instance.collection('users').document(currentUser.uid).get();
      final data = documentSnapshot.data;
      return data['apartment'];
    }
    catch(error){
      print(error);
      return null;
    }

  }

  static Future<bool> leaveApartment() async{
    try{
      final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

      final DocumentSnapshot documentSnapshot = await userCollection.document(currentUser.uid).get();
      final String apartmentName = documentSnapshot.data['apartment'];

      //Update user collection
      await userCollection.document(currentUser.uid).updateData({"apartment":""});

      //Update groceries collection
      await groceriesCollection.document(apartmentName).updateData({
        "roommateList": FieldValue.arrayRemove([currentUser.displayName])
      });

      //Update notes collection
      await notesCollection.document(apartmentName).updateData({
        "roommateList": FieldValue.arrayRemove([currentUser.displayName])
      });

      //Update apartment collection
      await apartmentCollection.document(apartmentName).updateData({
        "roommateList": FieldValue.arrayRemove([{
          'displayName': currentUser.displayName,
          'profilePictureURL': currentUser.photoUrl
        }])
      });

      return true;
    }
    catch(error){
      print(error);
      return false;
    }

  }

}