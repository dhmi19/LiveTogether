import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/shared/loading.dart';



class SignInScreen extends StatefulWidget{

  final Function toggleView;

  SignInScreen({this.toggleView});

  @override
  _SignInScreenState createState() => _SignInScreenState();

}

class _SignInScreenState extends State<SignInScreen>{

  String _email = '';
  String _password = '';
  String _error = '';

  bool _loading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _loading ? Loading(): Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 0), //Check this
          width: double.infinity,
          color: Theme.of(context).colorScheme.secondary,
          /*
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.purple[900],
                    Colors.purple[600],
                    Colors.purple[400]
                  ]
              )
          ),
          */
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 80, ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 40, ),),
                    SizedBox(height: 10,),
                    Text("Welcome to your apartment", style: TextStyle(color: Colors.white, fontSize: 25, ),)
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,

                        child: Column(
                          children: <Widget>[

                            SizedBox(height: 10,),

                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(240, 239, 239, 1.0),
                                  borderRadius: BorderRadius.circular(10),
                                  /*boxShadow: [BoxShadow(
                                      color: Color.fromRGBO(106, 191, 76, 0.5),
                                      blurRadius: 20,
                                      offset: Offset(0, 10)
                                  )]*/
                              ),
                              child: Column(
                                children: <Widget>[

                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondary))
                                    ),
                                    child: TextFormField(
                                      validator: (val) {
                                        if(val.isEmpty){
                                          return "Enter Email ID";
                                        }else{
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          hintText: "Email ID",
                                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primaryVariant),
                                          border: InputBorder.none
                                      ),
                                      onChanged: (val){
                                        setState(() {
                                          _email = val;
                                        });
                                      },
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondary))
                                    ),
                                    child: TextFormField(
                                      validator: (val) {
                                        if(val.length < 6){
                                          return "Password must be more than 6 letters";
                                        }else{
                                          return null;
                                        }
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primaryVariant),
                                          border: InputBorder.none
                                      ),
                                      onChanged: (val){
                                        setState(() {
                                          _password = val;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),

                            SizedBox(height: 30,),

                            Center(
                              child: GestureDetector(
                                child: Text(
                                  "Forgot password? Click here to reset",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline, color: Theme.of(context).colorScheme.primaryVariant
                                  ),
                                ),

                                onTap: () async {

                                  if(_email == ''){
                                    showDialog(
                                        context: context,
                                        child: AlertDialog(
                                          title: Text("Invalid email ID", style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                          content: const Text(
                                            'Please enter an email ID to reset password', 
                                            style: TextStyle(color: Color.fromRGBO(62, 61, 62, 1)),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                'Ok',
                                              style: TextStyle(color: Color.fromRGBO(62, 61, 62, 1)),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        )
                                    );
                                  }else{
                                    await _auth.resetPassword(_email, context);
                                  }
                                },
                              ),
                            ),

                            SizedBox(height: 30,),

                            Container(
                              width: 200,
                              child: FlatButton(
                                color: Theme.of(context).colorScheme.secondary,
                                child: Text("Sign In", style: TextStyle(color: Colors.white),),
                                onPressed: () async {
                                  if(_formKey.currentState.validate()) {

                                    setState(() {
                                      _loading = true;
                                    });
                                    dynamic result = await _auth.signInWithEmailAndPassword(_email, _password);
                                    //TODO: Update Apartment to which ever apartment the user belongs to
                                    if (result == null) {
                                      setState(() {
                                        _error = "Couldn't sign in with those credentials";
                                        _loading = false;
                                      });
                                    }

                                    //print(_email + "," + _password);
                                  }
                                },
                                splashColor: Theme.of(context).colorScheme.primary,
                              ),
                            ),

                            Container(
                              width: 200,
                              child: FlatButton(
                                color: Theme.of(context).colorScheme.secondary,
                                child: Text("Make a new account", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                                onPressed: () async {
                                  widget.toggleView();
                                  //Navigator.of(context).pushReplacementNamed('/RegisterScreen');
                                },
                                splashColor: Theme.of(context).colorScheme.secondary,
                              ),
                            ),

                            SizedBox(height: 20,),

                            Text(_error, style: TextStyle(color: Colors.red, fontSize: 14.0),),

                            SizedBox(height: 80,),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}