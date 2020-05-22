import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'apartmentServices.dart';

class UserServices {

  static final CollectionReference userCollection = Firestore.instance.collection('users');
  static final CollectionReference apartmentCollection = Firestore.instance.collection('apartments');
  static final CollectionReference groceriesCollection = Firestore.instance.collection('groceries');
  static final CollectionReference notesCollection = Firestore.instance.collection('notes');

  final String defaultProfilePictureURL = "https://images.unsplash.com/photo-1565043589221-1a6fd9ae45c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=942&q=80";

  static Future<bool> checkUserNameExists(String userName) async {
    QuerySnapshot querySnapshot = await userCollection.where("displayName", isEqualTo: userName).getDocuments();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;

    if(documentSnapshot.isNotEmpty){
      return true;
    }
    else{
      return false;
    }
  }

  static Future createNewUserDocument(String email, String displayName, String photoUrl, String uID) async{

    return await userCollection.document(uID).setData({
      'email': email,
      'displayName': displayName,
      'profilePictureURL': photoUrl,
      'apartment': ''
    });
  }

  static Future<String> getProfilePictureURL(String userName) async{

    QuerySnapshot querySnapshot = await userCollection.where("displayName", isEqualTo: userName).getDocuments();
    List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;

    for(var doc in documentSnapshot){
      if(doc.data['displayName'] == userName){
        return doc.data['profilePictureURL'];
      }
    }

    return "error, photo url not found";

  }

  static Future updateUserDetails(String email, String password, String username) async{

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

      String currentApartment = await ApartmentServices.getCurrentApartmentName();

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

  static Future updateProfilePicture(String imageURL) async{
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


}
