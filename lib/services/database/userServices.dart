import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'apartmentServices.dart';

class UserServices {

  static final CollectionReference userCollection = Firestore.instance.collection('users');
  static final CollectionReference apartmentCollection = Firestore.instance.collection('apartments');
  static final CollectionReference groceriesCollection = Firestore.instance.collection('groceries');
  static final CollectionReference notesCollection = Firestore.instance.collection('notes');

  final String defaultProfilePictureURL = "https://images.unsplash.com/photo-1565043589221-1a6fd9ae45c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=942&q=80";


  static Future updateUserBio(String bio) async{
    try{

      final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

      QuerySnapshot querySnapshot = await userCollection.where("displayName", isEqualTo: currentUser.displayName).getDocuments();
      List<DocumentSnapshot> documentSnapshot = querySnapshot.documents;

      for(var doc in documentSnapshot){
        if(doc.data['displayName'] == currentUser.displayName){
          String documentID = doc.documentID;
          UserServices.userCollection.document(documentID).updateData({
            'bio': bio
          });
          break;
        }
      }

    }catch(error){
      print(error);
    }
  }

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

    if(email.length != 0) {

      await currentUser.updateEmail(email);

      await userCollection.document(currentUser.uid).updateData({
        'email': email
      });
    }
    if(password.length != 0) {

      await currentUser.updatePassword(password);

    }
  }

  static Future updateProfilePicture(String imageURL) async{
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String _apartmentName = await ApartmentServices.getCurrentApartmentName();


    //Update apartment collection is the user is in an apartment:
    if(_apartmentName != "" && _apartmentName != null){
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
    }

    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.photoUrl = imageURL;
    await currentUser.updateProfile(userUpdateInfo);

    await userCollection.document(currentUser.uid).updateData({
      'profilePictureURL': imageURL
    });

    return currentUser.photoUrl;
  }


}
