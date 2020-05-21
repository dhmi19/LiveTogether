import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lester_apartments/constants.dart';
import 'package:lester_apartments/models/Note.dart';
import 'package:lester_apartments/models/apartment.dart';



class DatabaseService {

  //Collection reference:
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference apartmentCollection = Firestore.instance.collection('apartments');
  final CollectionReference groceriesCollection = Firestore.instance.collection('groceries');
  final CollectionReference notesCollection = Firestore.instance.collection('notes');

  final String defaultProfilePictureURL = "https://images.unsplash.com/photo-1565043589221-1a6fd9ae45c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=942&q=80";


  //Apartment List from snapshot
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


  Future<bool> checkUserNameExists(String userName) async {
    QuerySnapshot querySnapshot = await userCollection.where("displayName", isEqualTo: userName).getDocuments();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;

    if(documentSnapshot.isNotEmpty){
      return true;
    }
    else{
      return false;
    }

  }



  Future updateUserDetails(String email, String password, String username) async{

    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();


    if(email.length != 0) {

      await currentUser.updateEmail(email);

      await userCollection.document(currentUser.uid).updateData({
        'email': email
      });
    }
    if(password.length != 0) {

      await currentUser.updatePassword(password);

    }
    if(username.length != 0) {

      //Update user document
      await userCollection.document(currentUser.uid).updateData({
        'displayName': username
      });

      String currentApartment = await getCurrentApartmentName();

      //Remove user from roommate list in apartments
      await apartmentCollection.document(currentApartment).updateData({
        "roommateList": FieldValue.arrayRemove([{
          'displayName': currentUser.displayName,
          'profilePictureURL': currentUser.photoUrl
        }])
      });

      //Add user to roommate list in apartments
      await apartmentCollection.document(currentApartment).updateData({
        "roommateList": FieldValue.arrayRemove([{
          'displayName': username,
          'profilePictureURL': currentUser.photoUrl
        }])
      });

      // Remove user from roommate list in groceries
      await groceriesCollection.document(currentApartment).updateData({
        "roommateList": FieldValue.arrayRemove([currentUser.displayName])
      });

      //Remove user from roommate list in notes
      await notesCollection.document(currentApartment).updateData({
        "roommateList": FieldValue.arrayRemove([currentUser.displayName])
      });


      //Update groceries collection
      await groceriesCollection.document(currentApartment).updateData({
        "roommateList": FieldValue.arrayUnion([username])
      });

      //Update notes collection
      await notesCollection.document(currentApartment).updateData({
        "roommateList": FieldValue.arrayUnion([username])
      });

      userUpdateInfo.displayName = username;
    }

    currentUser.updateProfile(userUpdateInfo);
    currentUser.reload();
  }


  Future createNewUserDocument(String email, String displayName, String photoUrl, String uID) async{

    return await userCollection.document(uID).setData({
      'email': email,
      'displayName': displayName,
      'profilePictureURL': photoUrl,
      'apartment': ''
    });
  }



  Future updateProfilePicture(String imageURL) async{
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String _apartmentName;

    final documentSnapshot = await apartmentCollection.where('roommateList', arrayContains: {
      "displayName": currentUser.displayName,
      "profilePictureURL": currentUser.photoUrl
    }).getDocuments();

    final documents = documentSnapshot.documents;

    for(var document in documents){
      _apartmentName = document.documentID;
    }

    await apartmentCollection.document(_apartmentName).updateData({
      "roommateList": FieldValue.arrayRemove([{
        'displayName': currentUser.displayName,
        'profilePictureURL': currentUser.photoUrl
      }])
    });

    await apartmentCollection.document(_apartmentName).updateData({
      "roommateList": FieldValue.arrayUnion([{
        'displayName': currentUser.displayName,
        'profilePictureURL': imageURL
      }])
    });

    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.photoUrl = imageURL;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();



    await userCollection.document(currentUser.uid).updateData({
      'profilePictureURL': imageURL
    });


    return currentUser.photoUrl;
  }

  Future<String> getProfilePictureURL(String userName) async{

    QuerySnapshot querySnapshot = await userCollection.where("displayName", isEqualTo: userName).getDocuments();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;

    for(var doc in documentSnapshot){
      if(doc.data['displayName'] == userName){
        return doc.data['profilePictureURL'];
      }
    }

    return "error, photo url not found";

  }

  Future addNewRoommate(String newRoommateUsername) async{

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
      final profilePictureResult = await getProfilePictureURL(newRoommateUsername);

      if(profilePictureResult == null){
        newRoommateProfilePicURL = defaultProfilePictureURL;
      }else{
        newRoommateProfilePicURL = profilePictureResult;
      }

      //Update apartment roommate list:
      DocumentReference documentReference =  apartmentCollection.document(_apartmentName);

      await documentReference.updateData({
        "roommateList": FieldValue.arrayUnion([{
          'displayName': newRoommateUsername,
          'profilePictureURL': newRoommateProfilePicURL
        }]),

      });

      //Add roommate to groceries collection
      await groceriesCollection.document(_apartmentName).updateData({
        "roommateList": FieldValue.arrayUnion([newRoommateUsername])
      });

      //Add roommate to notes collection
      await notesCollection.document(_apartmentName).updateData({
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

  Future<List> createNewApartment(String apartmentName) async{

    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    //Get the profile picture URL of the current user
    String profilePictureURL = await getProfilePictureURL(currentUser.displayName);

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

  Future doesUserHaveAnApartment(String userName) async {

    final currentUser = await FirebaseAuth.instance.currentUser();

    final DocumentSnapshot documentSnapshot = await userCollection.document(currentUser.uid).get();
    final String apartmentName = documentSnapshot.data['apartment'];

    if(apartmentName == ""){
      return true;
    }else{
      return false;
    }


  }

  Future<String> getCurrentApartmentName() async {
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


  Future getUserColor() async{

  }

  Future<bool> leaveApartment() async{
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


  //Grocery Functions:

  Future updateGroceryItem(String itemName, int oldItemCount, int itemCount, String description) async {

    try{

      final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

      String apartmentName = await getCurrentApartmentName();

      if(apartmentName == null){
        return [false, "You are not part of an apartment. Join/Create an apartment to add items"];
      }

      DocumentReference documentReference =  groceriesCollection.document(apartmentName);

      await documentReference.updateData({
        "groceryList": FieldValue.arrayRemove([{
          'itemName': itemName,
          'itemCount': oldItemCount,
          'description': description,
          'buyer': currentUser.displayName
        }]),
      });

      await documentReference.updateData({
        "groceryList": FieldValue.arrayUnion([{
          'itemName': itemName,
          'itemCount': itemCount,
          'description': description,
          'buyer': currentUser.displayName
        }]),
      });

      return true;
    }
    catch(error){
      print(error);
      return false;
    }

  }

  Future<List> addGroceryItem(String itemName, int itemCount, String description) async{

    try{
      String apartmentName = await getCurrentApartmentName();

      final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

      if(apartmentName == null){
        return [false, "You are not part of an apartment. Join/Create an apartment to add items"];
      }

      DocumentReference documentReference =  groceriesCollection.document(apartmentName);

      await documentReference.updateData({
        "groceryList": FieldValue.arrayUnion([{
          'itemName': itemName,
          'itemCount': itemCount,
          'description': description,
          'buyer': currentUser.displayName
        }]),
      }
      );

      return [true, "Your item was added! Enjoy shopping"];
    }
    catch(error){
      print(error);
      return [false, "Sorry, there was an error. Please try again later :( "];
    }

  }


  // Notes Functions:

  Future<List> editNote(String title, String content, List newTags, Note note, List oldTagList) async{

    try{
      String apartmentName = await getCurrentApartmentName();

      if(apartmentName == null){
        return [false, "You are not part of an apartment. Join/Create an apartment to add items"];
      }

      DocumentReference documentReference =  notesCollection.document(apartmentName);

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

  Future<bool> addNote(String title, String content, List tagList) async {
    try {
      String apartmentName = await getCurrentApartmentName();

      if (apartmentName == null) {
        return false;
      }

      DocumentReference documentReference = notesCollection.document(
          apartmentName);

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

  Future<bool> deleteNote(Note note) async {
    try {
      String apartmentName = await getCurrentApartmentName();

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


