import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lester_apartments/services/auth.dart';


class DatabaseService {

  final String uid;

  DatabaseService({this.uid});

  //Collection reference:
  final CollectionReference userCollection = Firestore.instance.collection('users');


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
    return await userCollection.document(uid).setData({
      'profilePictureURL': imageURL
    });
  }

  /*Future updateProfilePicture(String imageURL) async{

    String uid = AuthService.currentUser.uid;

    return await userCollection.document(uid).setData({
      'profilePictureURL': imageURL,
    });
  }*/

}