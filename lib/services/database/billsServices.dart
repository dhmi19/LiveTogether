import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lester_apartments/models/groceryItem.dart';

class BillsServices {

  //Collection References:
  static final CollectionReference usersCollection = Firestore.instance.collection('users');
  static final CollectionReference groceriesCollection = Firestore.instance.collection('groceries');

  static Future<int> getBillCount(String userName) async {

    final QuerySnapshot querySnapshot = await usersCollection.where("displayName", isEqualTo: userName).getDocuments();

    final List<DocumentSnapshot> documentList = querySnapshot.documents;

    for(var userDocument in documentList){
      final userDocumentID = userDocument.documentID;
      QuerySnapshot billCollection = await usersCollection.document(userDocumentID).collection('bills').getDocuments();

      if(billCollection == null){
        return 0;
      } else if(billCollection.documents.length == 0){
        return 0;
      } else{
        return billCollection.documents.length;
      }
    }

    return null;

  }


  static Future makeBill() async {

    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    final QuerySnapshot querySnapshot = await groceriesCollection.where("roommateList", arrayContains: currentUser.displayName).getDocuments();

    final List<DocumentSnapshot> documents = querySnapshot.documents;

    List roommateList = List();

    for(var doc in documents){
      roommateList = doc.data['roommateList'];
      break;
    }
    
    if(roommateList != null) {

      for(var roommateUsername in roommateList){
        final QuerySnapshot querySnapshot = await usersCollection.where("displayName", isEqualTo: roommateUsername).getDocuments();

        final List<DocumentSnapshot> documentList = querySnapshot.documents;

        for(var userDocument in documentList){
          final userDocumentID = userDocument.documentID;
          QuerySnapshot querySnapshot = await usersCollection.document(userDocumentID).collection('bills').where("currentBill", isEqualTo: true).getDocuments();

          List<DocumentSnapshot> bills = querySnapshot.documents;

          for(DocumentSnapshot bill in bills){
            bill.reference.updateData({
              "timeStamp": FieldValue.serverTimestamp(),
              "currentBill": false
            });
          }

          await usersCollection.document(userDocumentID).collection('bills').document().setData({
            "isPaid": false,
            "currentBill": true
          });
        }
      }
    }
  }

  static Future addItemToBill(GroceryItem groceryItem, double cost) async {

    try{

      final List<String> buyerList = groceryItem.buyers.split(",");


      for(var buyerUserName in buyerList){
        try{

          final QuerySnapshot querySnapshot = await usersCollection.where("displayName", isEqualTo: buyerUserName).getDocuments();

          final List<DocumentSnapshot> userDocuments = querySnapshot.documents;

          for(var userDocument in userDocuments){
            final userDocumentID = userDocument.documentID;
            QuerySnapshot querySnapshot = await usersCollection.document(userDocumentID).collection('bills').where("currentBill", isEqualTo: true).getDocuments();

            if(querySnapshot != null){
              List<DocumentSnapshot> bills = querySnapshot.documents;

              for(DocumentSnapshot bill in bills){
                await bill.reference.updateData({
                  "${groceryItem.itemName}": {
                    "itemCount": groceryItem.itemCount,
                    "itemCost": cost
                  },
                });
              }
            }
          }
        }
        catch(error){
          print("addItemToBill function (for loop) : "+ error.toString());
        }
      }

    }catch(error){
      print("addItemToBill function: "+ error.toString());
    }
  }

}