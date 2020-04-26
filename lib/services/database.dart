import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {

  final String uid;

  DatabaseService({this.uid});

  //Collection reference:
  final CollectionReference userCollection = Firestore.instance.collection('users');



  Future updateUserData(String email, String password, String username, String apartment) async{

    return await userCollection.document(uid).setData({
      'email': email,
      'password': password,
      'username': username,
      'apartment': apartment
    });
  }

}