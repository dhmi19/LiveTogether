import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:lester_apartments/services/auth.dart';


class DatabaseService {

  final String uid;

  DatabaseService({this.uid});

  //Collection reference:
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference apartmentCollection = Firestore.instance.collection('apartments');


  Future updateUserRegistrationData(String email, String password, String username) async{

    return await userCollection.document(uid).setData({
      'email': email,
      'password': password,
      'username': username,
      'profilePictureURL': 'https://images.unsplash.com/photo-1565043589221-1a6fd9ae45c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=942&q=80'
    });
  }


  //Get User stream
  Stream<QuerySnapshot> get users{
    return userCollection.snapshots();
  }

  Future updateProfilePicture(String imageURL) async{

    AuthService.currentUser.profilePictureURL = imageURL;

    return await userCollection.document(uid).updateData({
      'profilePictureURL': imageURL
    });
  }

  Future updateUserDetails(String email, String password, String username) async{
    if(email.length != 0) {
      await userCollection.document(uid).updateData({
      'email': email
      });
    }
    if(password.length != 0) {
      await userCollection.document(uid).updateData({
      'password': password
      });
    }
    if(username.length != 0) {
      await userCollection.document(uid).updateData({
      'username': username
      });
    }
  }

  Future createNewApartment(String apartmentName) async{

    final isUserHomeless = await checkIfUserHasAnApartment(AuthService.currentUser.userName);
    print(isUserHomeless);

    final documentSnapshot = await apartmentCollection.document(apartmentName).get();
    print(documentSnapshot);
    print(documentSnapshot.exists);

    if(documentSnapshot == null || !documentSnapshot.exists){
      await apartmentCollection.document(apartmentName).setData({"roommateList": [AuthService.currentUser.userName]});
      return true;
    }
    else{
      return null;
    }

  }

  Future checkIfUserHasAnApartment(String userName) async{

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    var user = await _firebaseAuth.currentUser();
    print("The current user is: ");
    print(user.email);

    final documentSnapshot = await apartmentCollection.where("roommateList", arrayContains: userName).getDocuments();

    if(documentSnapshot.documents.isEmpty){
      return false;
    }else{
      return true;
    }

  }
}


