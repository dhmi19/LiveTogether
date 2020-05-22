

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';

class ShoppingListServices {

  static final CollectionReference groceriesCollection = Firestore.instance.collection('groceries');

  static Future<List> addShoppingListItem(String itemName, int itemCount,
      String description) async {
    try {
      String apartmentName = await ApartmentServices.getCurrentApartmentName();

      final FirebaseUser currentUser = await FirebaseAuth.instance
          .currentUser();

      if (apartmentName == null) {
        return [
          false,
          "You are not part of an apartment. Join/Create an apartment to add items"
        ];
      }

      DocumentReference documentReference = groceriesCollection.document(
          apartmentName);

      await documentReference.updateData({
        "groceryList": FieldValue.arrayUnion([{
          'itemName': itemName,
          'itemCount': itemCount,
          'description': description,
          'buyer': currentUser.displayName
        }
        ]),
      }
      );

      return [true, "Your item was added! Enjoy shopping"];
    }
    catch (error) {
      print(error);
      return [false, "Sorry, there was an error. Please try again later :( "];
    }
  }


  static Future updateShoppingListItem(String itemName, int oldItemCount, int itemCount, String description) async {

    try{

      final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

      String apartmentName = await ApartmentServices.getCurrentApartmentName();

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

}