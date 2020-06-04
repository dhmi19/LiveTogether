import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/models/apartment.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class RoommateTileList extends StatefulWidget {

  @override
  _RoommateTileListState createState() => _RoommateTileListState();
}

class _RoommateTileListState extends State<RoommateTileList> {

  List _roommateList = [];

  Apartment _apartment;

  @override
  Widget build(BuildContext context) {

    final FirebaseUser currentUser = Provider.of<FirebaseUser>(context);
    final apartments = Provider.of<List<Apartment>>(context);

    if(apartments != null){
      apartments.forEach((apartment) {

        for(var roommate in apartment.roommateList){
          if(roommate["displayName"] == currentUser.displayName){
            _roommateList = apartment.roommateList;
            _apartment = apartment;
          }
        }
      });
    }


    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: _roommateList.length,
      itemBuilder: (context, index) {
        return RoommateCard(apartment: _apartment, roommateList: _roommateList, index: index);
      },
    );

  }
}


class RoommateCard extends StatelessWidget {

  final Apartment apartment;
  final List roommateList;
  final int index;

  RoommateCard({this.apartment, this.roommateList, this.index});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final FirebaseUser currentUser = Provider.of<FirebaseUser>(context);

    Color tileColor = kDarkBlue;

    String userName = roommateList[index]["displayName"];

    bool isMe;

    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection("apartments").document(apartment.apartmentName).snapshots(),
        builder: (context, snapshot) {

          try{
            print(snapshot.hasData);
            final DocumentSnapshot documentSnapshot = snapshot.data;
            final data = documentSnapshot.data;
            final List roommateList = data['roommateList'];

            for(var roommate in roommateList){
              if(roommate['displayName'] == roommateList[index]['displayName']){
                tileColor = Color(roommate['color']);
              }
            }

            if(roommateList[index]['displayName'] == currentUser.displayName){
              isMe = true;
            }else{
              isMe = false;
            }

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: tileColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 5,
                        offset: Offset(0, 15), // changes position of shadow
                      ),
                    ]
                ),
                width: size.width * 0.5,
                child: Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: ProfilePictureClipper(),
                      child: Container(
                        height: 220,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(roommateList[index]["profilePictureURL"]),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Text(roommateList[index]["displayName"], style: TextStyle(fontSize: 20),),
                    )
                  ],
                ),
              ),
            );
          }catch(error){
            print(error);
            return Text("");
          }
        }
    );
  }
}

class ProfilePictureClipper extends CustomClipper<Path>{

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width , 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

}



