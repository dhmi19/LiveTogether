import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {

  final String uid;
  FirebaseUser currentUser;

  DatabaseService({this.uid});

  //Collection reference:
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference apartmentCollection = Firestore.instance.collection('apartments');


  Future updateUserRegistrationData(String email, String password, String username) async{

    return await userCollection.document(uid).setData({
      'email': email,
      'password': password,
      'username': username,
    });
  }


  Future updateProfilePicture(String imageURL) async{

    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.photoUrl = imageURL;
    await currentUser.updateProfile(userUpdateInfo);

    return currentUser.photoUrl;

    //return await userCollection.document(uid).updateData({
      //'profilePictureURL': imageURL
    //});
  }

  Future updateUserDetails(String email, String password, String username) async{

    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();

    if(email.length != 0) {

      await currentUser.updateEmail(email);

      await userCollection.document(uid).updateData({
      'email': email
      });
    }
    if(password.length != 0) {

      await currentUser.updatePassword(password);

      await userCollection.document(uid).updateData({
      'password': password
      });
    }
    if(username.length != 0) {
      userUpdateInfo.displayName = username;
      await userCollection.document(uid).updateData({
      'username': username
      });
    }

    currentUser.updateProfile(userUpdateInfo);
  }

  Future createNewApartment(String apartmentName) async{

    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    final isUserHomeless = await checkIfUserHasAnApartment(currentUser.displayName);
    print("Is the user homeless: "+ isUserHomeless);

    final documentSnapshot = await apartmentCollection.document(apartmentName).get();
    print('The apartment name is taken: $documentSnapshot.exists');

    if(documentSnapshot == null || !documentSnapshot.exists){
      await apartmentCollection.document(apartmentName).setData({"roommateList": [currentUser.displayName]});
      return true;
    }
    else{
      return null;
    }

  }

  Future checkIfUserHasAnApartment(String userName) async{

    final documentSnapshot = await apartmentCollection.where("roommateList", arrayContains: userName).getDocuments();

    if(documentSnapshot.documents.isEmpty){
      return false;
    }else{
      return true;
    }

  }
}


