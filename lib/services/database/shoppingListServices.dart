

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

  static Future<String> getListOfBuyers(String apartmentName, String itemName) async {

    final DocumentSnapshot documentSnapshot = await groceriesCollection.document(apartmentName).get();
    final data = documentSnapshot.data;
    final shoppingList = data['groceryList'];

    for(var item in shoppingList){
      if(item['itemName'] == itemName){
        return item['buyer'];
      }
    }

    return null;
  }

  static Future updateShoppingListItem(
      String itemName,
      int oldItemCount,
      int itemCount,
      String description,
      String newBuyerUsername ) async {

    try{

      final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

      String apartmentName = await ApartmentServices.getCurrentApartmentName();

      if(apartmentName == null){
        return [false, "You are not part of an apartment. Join/Create an apartment to add items"];
      }

      DocumentReference documentReference =  groceriesCollection.document(apartmentName);

      String listOfBuyers = await getListOfBuyers(apartmentName, itemName);

      String newListOfBuyers = newBuyerUsername != null ?
                              listOfBuyers+",$newBuyerUsername" : listOfBuyers;

      await documentReference.updateData({
        "groceryList": FieldValue.arrayRemove([{
          'itemName': itemName,
          'itemCount': oldItemCount,
          'description': description,
          'buyer': listOfBuyers
        }]),
      });

      await documentReference.updateData({
        "groceryList": FieldValue.arrayUnion([{
          'itemName': itemName,
          'itemCount': itemCount,
          'description': description,
          'buyer': newListOfBuyers
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