import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/services/database.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';

class RommatesWidget extends StatefulWidget {

  final FirebaseUser currentUser;

  const RommatesWidget({this.currentUser});

  @override
  _RommatesWidgetState createState() => _RommatesWidgetState();
}

class _RommatesWidgetState extends State<RommatesWidget> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _apartmentName = '';

  @override
  Widget build(BuildContext context) {
    return Container(

      color: Theme.of(context).colorScheme.onBackground,

      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primaryVariant),
            elevation: 0,

            // FlatButton.icon(onPressed: () => {}, icon: Icon(Icons.menu), label: Text("")),
            title: Text("", style: TextStyle(color: Colors.white),),

            centerTitle: true,

          ),


          body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[

                    SizedBox(height: 20,),

                    Text("Apartment Name", style: TextStyle(fontSize: 30, color: Theme.of(context).colorScheme.primaryVariant)),

                    SizedBox(height: 20,),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          height: 400,
                          width: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20,),
                              Text("People in your apartment: ", style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primaryVariant),)
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          ButtonTheme(
                            child: FlatButton(
                              color: Theme.of(context).colorScheme.onSecondary,
                              child: Text("New Apartment", style: TextStyle(fontSize: 15),),
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Stack(
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          Positioned(
                                            right: -40.0,
                                            top: -40.0,
                                            child: InkResponse(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: CircleAvatar(
                                                child: Icon(Icons.close, color: Colors.white,),
                                                backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
                                              ),
                                              splashColor: Colors.white,
                                            ),
                                          ),

                                          Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                      hintText: "Apartment Name",
                                                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.primaryVariant)
                                                    ),
                                                    onChanged: (val){
                                                      setState(() {
                                                        _apartmentName = val;
                                                      });
                                                    },
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    color: Theme.of(context).colorScheme.onSecondary,
                                                    child: Text("Submit"),
                                                    onPressed: () async {
                                                      if (_formKey.currentState.validate()) {
                                                        //TODO: Check if apartment name is taken
                                                        final result = await DatabaseService(uid: widget.currentUser.uid).createNewApartment(_apartmentName);
                                                        print(result);
                                                        if(result != null){
                                                          Navigator.of(context).pop();
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext context){
                                                                return AlertDialog(
                                                                  title: Text("Success"),
                                                                  content: Text("Your apartment was made! You can now add your roommates"),
                                                                  actions: <Widget>[
                                                                    FlatButton(
                                                                      child: Text("OK"),
                                                                      onPressed: (){
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    )
                                                                  ],
                                                                );
                                                              }
                                                          );

                                                        }else{
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context){
                                                              return AlertDialog(
                                                                title: Text("Error"),
                                                                content: Text("The apartment name already exists, please make a new group name"),
                                                                actions: <Widget>[
                                                                  FlatButton(
                                                                    child: Text("OK"),
                                                                    onPressed: (){
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            }
                                                          );
                                                        }
                                                      }
                                                    },
                                                    splashColor: Theme.of(context).colorScheme.primary,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                );

                              },
                            ),
                          ),

                          FlatButton(
                            color: Theme.of(context).colorScheme.onSecondary,
                            child: Text("Add Roommate", style: TextStyle(fontSize: 15),),
                            onPressed: (){

                            },
                          ),

                        ],
                      ),
                    ),


                  ],
                ),
              )
          ),

          drawer: DrawerWidget()
      ),
    );
  }
}
