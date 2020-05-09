
class Apartment {

  String apartmentName;

  List roommateList;

  Apartment({this.apartmentName, this.roommateList});

  Function addRoommmate(String emailID){
    roommateList.add(emailID);
  }

}
