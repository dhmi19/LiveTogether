import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lester_apartments/models/groceryItem.dart';
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


  static Future updateShoppingListItem(
      GroceryItem groceryItem,
      int itemCount,
      String newBuyerUsername ) async {

    try{

      String apartmentName = await ApartmentServices.getCurrentApartmentName();

      if(apartmentName == null){
        return [false, "You are not part of an apartment. Join/Create an apartment to add items"];
      }

      DocumentReference documentReference =  groceriesCollection.document(apartmentName);


      String newListOfBuyers = newBuyerUsername != null ?
                              groceryItem.buyers+",$newBuyerUsername" : groceryItem.buyers;

      await documentReference.updateData({
        "groceryList": FieldValue.arrayRemove([{
          'itemName': groceryItem.itemName,
          'itemCount': groceryItem.itemCount,
          'description': groceryItem.description,
          'buyer': groceryItem.buyers
        }]),
      });

      await documentReference.updateData({
        "groceryList": FieldValue.arrayUnion([{
          'itemName': groceryItem.itemName,
          'itemCount': itemCount,
          'description': groceryItem.description,
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

  static Future updateBuyers(GroceryItem groceryItem, int itemCount, String newBuyers ) async {

    try{

      String apartmentName = await ApartmentServices.getCurrentApartmentName();

      if(apartmentName == null){
        return [false, "You are not part of an apartment. Join/Create an apartment to add items"];
      }

      DocumentReference documentReference =  groceriesCollection.document(apartmentName);


      await documentReference.updateData({
        "groceryList": FieldValue.arrayRemove([{
          'itemName': groceryItem.itemName,
          'itemCount': groceryItem.itemCount,
          'description': groceryItem.description,
          'buyer': groceryItem.buyers
        }]),
      });

      await documentReference.updateData({
        "groceryList": FieldValue.arrayUnion([{
          'itemName': groceryItem.itemName,
          'itemCount': itemCount,
          'description': groceryItem.description,
          'buyer': newBuyers
        }]),
      });

      return true;
    }
    catch(error){
      print(error);
      return false;
    }

  }

  static Future removeShoppingListItem(GroceryItem groceryItem, String apartmentName) async {
    try{

      DocumentReference documentReference =  groceriesCollection.document(apartmentName);

      await documentReference.updateData({
        "groceryList": FieldValue.arrayRemove([{
          'itemName': groceryItem.itemName,
          'itemCount': groceryItem.itemCount,
          'description': groceryItem.description,
          'buyer': groceryItem.buyers
        }]),
      });

      return true;
    }
    catch(error){
      print(error);
      return false;
    }
  }

  static Future addCost({double costPerPerson, GroceryItem groceryItem, String apartmentName}) async{

    try{

      List<String> buyerList = groceryItem.buyers.split(',');

      buyerList.forEach((buyerUserName) {
        groceriesCollection.document(apartmentName).updateData({
          "costList.$buyerUserName": FieldValue.increment(costPerPerson)
        });
      });

    }
    catch(error){
      print(error);
    }
  }

}