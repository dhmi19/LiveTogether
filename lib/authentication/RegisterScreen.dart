import 'package:flutter/material.dart';
import 'package:lester_apartments/services/auth.dart';
import 'package:lester_apartments/shared/loading.dart';

class RegisterScreen extends StatefulWidget {

  final Function toggleView;

  RegisterScreen({this.toggleView});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  String _email = '';
  String _password = '';
  String _error = '';
  String _username = '';

  bool _loading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return _loading ? Loading() : Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 0), //Check this
          width: double.infinity,
          color: Colors.red[400],
          /*
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.blue[900],
                    Colors.blue[600],
                    Colors.blue[400]
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
                    Text("Register", style: TextStyle(color: Colors.white, fontSize: 40,),),
                    SizedBox(height: 10,),
                    Text("Make living with friends easier", style: TextStyle(color: Colors.white, fontSize: 25, ),)
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.red[400]))
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
                                        border: Border(bottom: BorderSide(color: Colors.red[400]))
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
                                  ),

                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.red[400]))
                                    ),
                                    child: TextFormField(
                                      validator: (val) {
                                        if(val.length < 6){
                                          return "Username must be more than 6 letters";
                                        }else{
                                          return null;
                                        }
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          hintText: "Username",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                      onChanged: (val){
                                        setState(() {
                                          _username = val;
                                        });
                                      },
                                    ),
                                  ),


                                ],
                              ),
                            ),
                            SizedBox(height: 40,),

                            Container(
                              width: 200,
                              child: RaisedButton(
                                color: Colors.red[400],
                                child: Text("Register", style: TextStyle(color: Colors.white),),
                                onPressed: () async {

                                  setState(() {
                                    _loading = true;
                                  });

                                  if(_formKey.currentState.validate()) {

                                    dynamic result = await _auth.registerWithEmailAndPassword(_email, _password, _username);

                                    print(result);

                                    if(result == null){
                                      setState(() {
                                        _error = 'Please supply valid email';
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
                                color: Colors.blue[500],
                                child: Text("Return to Sign In ", style: TextStyle(color: Colors.white),),
                                onPressed: () async {
                                  widget.toggleView();
                                  //Navigator.of(context).pushReplacementNamed('/SignInScreen');
                                },
                              ),
                            ),

                            SizedBox(height: 20,),

                            Text(_error, style: TextStyle(color: Colors.red, fontSize: 14.0),),

                            SizedBox(height: 60,),

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
