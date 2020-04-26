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
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.orange[900],
                    Colors.orange[600],
                    Colors.orange[400]
                  ]
              )
          ),
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
                    color: Colors.white,
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
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, 0.2),
                                      blurRadius: 20,
                                      offset: Offset(0, 10)
                                  )]
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.green))
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
                                          hintStyle: TextStyle(color: Colors.grey),
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
                                        border: Border(bottom: BorderSide(color: Colors.green))
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
                                          hintStyle: TextStyle(color: Colors.grey),
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
                            SizedBox(height: 40,),

                            Container(
                              width: 200,
                              child: RaisedButton(
                                color: Colors.orange[900],
                                child: Text("Sign In", style: TextStyle(color: Colors.white),),
                                onPressed: () async {
                                  if(_formKey.currentState.validate()) {

                                    setState(() {
                                      _loading = true;
                                    });
                                    dynamic result = await _auth.signInWithEmailAndPassword(_email, _password);

                                    if (result == null) {
                                      setState(() {
                                        _error = "Couldn't sign in with those credentials";
                                        _loading = false;
                                      });
                                    }

                                    //print(_email + "," + _password);
                                  }
                                },
                              ),
                            ),

                            Container(
                              width: 200,
                              child: RaisedButton(
                                color: Colors.blue[600],
                                child: Text("Make a new account", style: TextStyle(color: Colors.white),),
                                onPressed: () async {
                                  widget.toggleView();
                                  //Navigator.of(context).pushReplacementNamed('/RegisterScreen');
                                },
                              ),
                            ),

                            Container(
                              width: 200,
                              child: RaisedButton(
                                color: Colors.blueGrey[700],
                                child: Text("Enter as Guest", style: TextStyle(color: Colors.white),),
                                onPressed: () async {
                                  dynamic result = await _auth.signInAnon();

                                  if(result == null){
                                    print("Error signing in as guest");
                                  }else{
                                    print(result.uid);
                                    Navigator.of(context).pushReplacementNamed('/IntroductionScreen', arguments: "Guest");
                                  }
                                },
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