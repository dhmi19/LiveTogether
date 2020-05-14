import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lester_apartments/models/apartment.dart';



class DatabaseService {

  //Collection reference:
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference apartmentCollection = Firestore.instance.collection('apartments');

  final String defaultProfilePictureURL = "https://images.unsplash.com/photo-1565043589221-1a6fd9ae45c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=942&q=80";

  //Apartment List from snapshot
  List<Apartment> _apartmentListFromSnapshot(QuerySnapshot snapshot){

    for(var document in snapshot.documents){
      print(document.data);
    }

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

  Future updateUserRegistrationData(String email, String password, String username) async{

    final currenUser = await FirebaseAuth.instance.currentUser();

    return await userCollection.document(currenUser.uid).setData({
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

    await userCollection.document(currentUser.uid).updateData({
      'profilePictureURL': imageURL
    });

    return currentUser.photoUrl;

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

      await userCollection.document(currentUser.uid).updateData({
      'password': password
      });
    }
    if(username.length != 0) {
      userUpdateInfo.displayName = username;

      await userCollection.document(currentUser.uid).updateData({
      'username': username
      });
    }

    currentUser.updateProfile(userUpdateInfo);
  }


  Future<String> getProfilePictureURL(String userName) async{

    final querySnapshot = await userCollection.where('displayName', isEqualTo: userName).getDocuments();
    final queryDocuments = querySnapshot.documents;

    for(var document in queryDocuments){
      if(document.data['displayName'] == userName){
        return document.data['profilePictureURL'];
      }
    }

    return null;
  }

  Future addNewRoommate(String newRoommateUsername) async{

    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String newRoommateProfilePicURL;

    //Check if currentUser has an apartment already
    final isCurrentUserHomeless = await checkIfUserHasAnApartment(currentUser.uid);
    print("is current user homeless? "+ isCurrentUserHomeless.toString());

    if(isCurrentUserHomeless){
      return null;
    }

    //Check if roommate is already in an apartment
    final isRoommateHomeless = await checkIfUserHasAnApartment(newRoommateUsername);

    print("is new roommate homeless? "+ isRoommateHomeless.toString());

    if(!isRoommateHomeless){

      //Get apartment name:
      String _apartmentName;
      String _loggedInUserProfilePic = currentUser.photoUrl;
      print("database.dart (137): "+ _loggedInUserProfilePic);

      //TODO: Not able to get apartment name
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
      }

      //get the profile picture url of new roommate:
      final profilePictureResult = await getProfilePictureURL(newRoommateUsername);

      if(profilePictureResult == null){
        newRoommateProfilePicURL = defaultProfilePictureURL;
      }else{
        newRoommateProfilePicURL = profilePictureResult;
      }

      //Update roommate list:
      DocumentReference documentReference =  apartmentCollection.document(_apartmentName);
      print(_apartmentName);
      print(documentReference.documentID);
      await documentReference.updateData({
        "roommateList": FieldValue.arrayUnion([{
          'displayName': newRoommateUsername,
          'profilePictureURL': newRoommateProfilePicURL
        }]),

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

}


