import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/models/Note.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';
import 'package:provider/provider.dart';

import 'NotesPageTabBar.dart';
import 'NotesTabBarView.dart';


class SharedNotesWidget extends StatefulWidget {

  final FirebaseUser currentUser;

  const SharedNotesWidget({this.currentUser});

  @override
  _SharedNotesWidgetState createState() => _SharedNotesWidgetState();
}

class _SharedNotesWidgetState extends State<SharedNotesWidget> with SingleTickerProviderStateMixin{

  int _selectedCategoryIndex = 0;
  TabController _tabController;


  Widget _buildCategoryCard(int index, String title, int content){

    return GestureDetector(
      onTap: (){
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Container(
        margin: index == 0?
          EdgeInsets.only(left: 30, right: 10, top: 20, bottom: 20):
          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        height: 100,
        width: 175,
        decoration: BoxDecoration(
          color: _selectedCategoryIndex == index ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onPrimary,
          border: Border.all(
            width: 1,
            color: _selectedCategoryIndex == index ? Theme.of(context).colorScheme.onPrimary: Theme.of(context).colorScheme.secondary
          ),
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            _selectedCategoryIndex == index ? BoxShadow(
              color: Colors.black26, offset: Offset(0, 2), blurRadius: 10.0
            ) :
                BoxShadow(
                  color: Colors.transparent
                )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                title,
                style: TextStyle(
                    color: _selectedCategoryIndex == index ?
                    Theme.of(context).colorScheme.primary :
                    Theme.of(context).colorScheme.primaryVariant,
                    fontSize: 25,
                    fontWeight: _selectedCategoryIndex == index ? FontWeight.bold : FontWeight.normal
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                content.toString(),
                style: TextStyle(
                  color: _selectedCategoryIndex == index ?
                  Theme.of(context).colorScheme.primary :
                  Theme.of(context).colorScheme.primaryVariant,
                  fontSize: 50,
                  fontWeight: _selectedCategoryIndex == index ? FontWeight.bold : FontWeight.normal
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    final currentUser = Provider.of<FirebaseUser>(context);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,

          title: Text("Shared Notes", style: TextStyle(color: Colors.black),),

          centerTitle: true,

        ),


        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("notes").snapshots(),
                    builder: (context, snapshot) {
                      try{

                        Map<String, int> folderHeaders = {
                          'All Notes': 0,
                          'Personal': 0,
                          'Shared': 0,
                          'Important': 0,
                          'Leisure': 0,
                          'Others': 0
                        };

                        if(!snapshot.hasData){
                          return Text("Sorry, data was not found");
                        }

                        if(snapshot.hasData){
                          final List<DocumentSnapshot> apartments = snapshot.data.documents;
                          for(DocumentSnapshot apartment in apartments){
                            List tempRoommateList = apartment.data["roommateList"];
                            if(tempRoommateList.contains(currentUser.displayName)){
                              List notes = apartment.data["notes"];
                              notes.forEach((note) {
                                Note currentNote = Note(
                                    title: note['title'],
                                    content: note['content'],
                                    tags: note['tags']);

                                folderHeaders['All Notes'] ++;

                                if(currentNote.tags.contains('personal')){
                                  folderHeaders['Personal'] ++;
                                }
                                if(currentNote.tags.contains('shared')){
                                  folderHeaders['Shared'] ++;
                                }
                                if(currentNote.tags.contains('important')){
                                  folderHeaders['Important'] ++;
                                }
                                if(currentNote.tags.contains('leisure')){
                                  folderHeaders['Leisure'] ++;
                                }
                                if(currentNote.tags.contains('others')){
                                  folderHeaders['Others'] ++;
                                }
                              });
                            }
                          }
                        }

                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: folderHeaders.length,
                            itemBuilder: (BuildContext context, int index){
                              return _buildCategoryCard(
                                  index,
                                  folderHeaders.keys.toList()[index],
                                  folderHeaders.values.toList()[index]
                              );
                            }
                        );
                      }
                      catch(error){
                        print(error);
                        return Center(child: Text("Sorry, there was an error. Please try again later"));
                      }
                    }
                  ),
                ),

                NotesPageTabBar(tabController: _tabController),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      NotesTabView(tag: 'important'),
                      NotesTabView(tag: 'shared'),
                      NotesTabView(tag: 'leisure'),
                    ],
                  ),
                )
              ],
            ),
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){

          },
          child: FaIcon(
            FontAwesomeIcons.plus,
            color: Theme.of(context).colorScheme.primary,
          ),
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
        ),
        drawer: DrawerWidget()
    );
  }
}


