import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageSlideShow extends StatefulWidget {

  final FirebaseUser currentUser;

  const HomePageSlideShow({this.currentUser});

  @override
  _HomePageSlideShowState createState() => _HomePageSlideShowState();
}

class _HomePageSlideShowState extends State<HomePageSlideShow> {

  final PageController ctrl = PageController(viewportFraction: 0.8);

  final Firestore firestoreInstance = Firestore.instance;

  int currentPage = 0;

  @override
  void initState() {
    //_queryDb();
    
    ctrl.addListener((){
      int next = ctrl.page.round();

      if(currentPage != next){
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(

    );
  }

  Stream _queryDb({String tag = 'favourites'}){

    //Make a Query:
    //Query query = firestoreInstance.collection('Groceries').where('', isEqualTo: widget.currentUser.displayName)
  }
}
