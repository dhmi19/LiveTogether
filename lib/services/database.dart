import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lester_apartments/models/apartment.dart';



class DatabaseService {

  //Collection reference:
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference apartmentCollection = Firestore.instance.collection('apartments');
  final CollectionReference groceriesCollection = Firestore.instance.collection('groceries');

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
      userUpdateInfo.displayName = username;

      await userCollection.document(currentUser.uid).updateData({
        'displayName': username
      });
    }

    currentUser.updateProfile(userUpdateInfo);
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

    //TODO: Update the profile picture in the apartments collection too
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

  }

  Future addNewRoommate(String newRoommateUsername) async{

    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String newRoommateProfilePicURL;

    //Check if currentUser has an apartment already
    final isCurrentUserHomeless = await checkIfUserHasAnApartment(currentUser.uid);

    if(isCurrentUserHomeless){
      return null;
    }

    //Check if roommate is already in an apartment
    final isRoommateHomeless = await checkIfUserHasAnApartment(newRoommateUsername);


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

      //Update roommate list:
      DocumentReference documentReference =  apartmentCollection.document(_apartmentName);

      await documentReference.updateData({
        "roommateList": FieldValue.arrayUnion([{
          'displayName': newRoommateUsername,
          'profilePictureURL': newRoommateProfilePicURL
        }]),

      });

      //Add roommate to groceries collection
      groceriesCollection.document(_apartmentName).updateData({
        "roommateList": FieldValue.arrayUnion([newRoommateUsername])
      });

      return true;
    }else{
      return null;
    }

  }

  Future createNewApartment(String apartmentName) async{

    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    //Get the profile picture URL of the current user
    String profilePictureURL = await getProfilePictureURL(currentUser.displayName);

    if(profilePictureURL == null){
      profilePictureURL = defaultProfilePictureURL;
    }

    final isUserHomeless = await checkIfUserHasAnApartment(currentUser.displayName);


    final documentSnapshot = await apartmentCollection.document(apartmentName).get();

    if((documentSnapshot == null || !documentSnapshot.exists) && isUserHomeless == false){
      await apartmentCollection.document(apartmentName).setData({"roommateList": [{
        'displayName': currentUser.displayName,
        'profilePictureURL': profilePictureURL
      }]
      });

      await userCollection.document(currentUser.uid).updateData({
        "apartment": apartmentName
      }
      );

      //Create new document for groceries
      await groceriesCollection.document(apartmentName).setData({
        "roommateList": [currentUser.displayName]
      });

      return true;
    }
    else{
      return null;
    }

  }

  Future checkIfUserHasAnApartment(String userName) async {

    final documentSnapshot = await apartmentCollection.where("roommateList", arrayContains: userName).getDocuments();

    if(documentSnapshot.documents.isEmpty){
      return false;
    }else{
      return true;
    }

  }

  Future<String> getCurrentApartmentName() async {

    String _apartmentName;

    final currentUser = await FirebaseAuth.instance.currentUser();

    try{
      String _loggedInUserProfilePic = currentUser.photoUrl;

      print(currentUser.displayName);
      print(_loggedInUserProfilePic);

      final documentSnapshot = await apartmentCollection.where(
          "roommateList",
          arrayContains: {
            "displayName": currentUser.displayName,
            "profilePictureURL": _loggedInUserProfilePic
          }
      ).getDocuments();

      final documents = documentSnapshot.documents;

      for(var document in documents){
        _apartmentName = document.documentID;
        return _apartmentName;
      }
      return null;
    }catch(error){
      print(error);
      return null;
    }

  }

  Future leaveApartment() async{
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    final DocumentSnapshot documentSnapshot = await userCollection.document(currentUser.uid).get();
    final String apartmentName = documentSnapshot.data['apartment'];

    //Update user collection
    await userCollection.document(currentUser.uid).updateData({"apartment":""});

    //Update groceries collection
    await groceriesCollection.document(apartmentName).updateData({
      "roommateList": FieldValue.arrayRemove([currentUser.displayName])
    });

    //Update apartment collection
    await apartmentCollection.document(apartmentName).updateData({
      "roommateList": FieldValue.arrayRemove([{
        'displayName': currentUser.displayName,
        'profilePictureURL': currentUser.photoUrl
      }])
    });
  }


  //Grocery Functions:
  Future addGroceryItem(String itemName, int itemCount, String description) async{

    String apartmentName = await getCurrentApartmentName();

    print(apartmentName);

    if(apartmentName == null){
      return null;
    }

    DocumentReference documentReference =  groceriesCollection.document(apartmentName);

    await documentReference.updateData({
      "groceryList": FieldValue.arrayUnion([{
        'itemName': itemName,
        'itemCount': itemCount,
        'description': description
      }]),
    });

    return true;
  }
}


