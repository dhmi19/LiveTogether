import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/database/apartmentServices.dart';

class NewApartmentWidget extends StatefulWidget {

  final FirebaseUser currentUser;

  const NewApartmentWidget({this.currentUser});


  @override
  _NewApartmentWidgetState createState() => _NewApartmentWidgetState();
}

class _NewApartmentWidgetState extends State<NewApartmentWidget> {


  final _formKey = GlobalKey<FormState>();
  String _apartmentName = '';


  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
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
                                    final result = await ApartmentServices.createNewApartment(_apartmentName);
                                    Navigator.of(context).pop();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return NewApartmentAlertDialog(isSuccess: result[0], description: result[1],);
                                        }
                                    );
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
    );
  }
}

class NewApartmentAlertDialog extends StatelessWidget {

  final bool isSuccess;
  final String description;

  NewApartmentAlertDialog({this.isSuccess, this.description});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isSuccess? "Success": "Error"),
      content: Text(description),
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
}
