import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';
import 'package:provider/provider.dart';

class AddRoommateWidget extends StatefulWidget {

  final FirebaseUser currentUser;

  const AddRoommateWidget({this.currentUser});

  @override
  _AddRoommateWidgetState createState() => _AddRoommateWidgetState();
}

class _AddRoommateWidgetState extends State<AddRoommateWidget> {


  final _formKey = GlobalKey<FormState>();

  String _newRommateUsername = '';

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseUser>(context);

    return FlatButton(
      color: Theme.of(context).colorScheme.onSecondary,
      child: Text("Add Roommate", style: TextStyle(fontSize: 15),),
      onPressed: () async{
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
                                  hintText: "Enter username of new roommate",
                                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.primaryVariant)
                              ),
                              onChanged: (val){
                                setState(() {
                                  _newRommateUsername = val;
                                });
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Theme.of(context).colorScheme.onSecondary,
                              child: Text("Add"),
                              onPressed: () async {
                                print("Add button pressed");
                                print(user.displayName);
                                if (_formKey.currentState.validate()) {
                                  final result = await ApartmentServices.addNewRoommate(_newRommateUsername);
                                  //print(result);
                                  if(result != null){
                                    Navigator.of(context).pop();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text("Success"),
                                            content: Text("Your roommate was added to the apartment!"),
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
                                            content: Text("The roommate could not be added, please make sure you entered the correct username and that the user does not have an apartment already."),
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
    );
  }
}
