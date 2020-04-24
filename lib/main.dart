import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lester_apartments/route_generator.dart';
import 'package:lester_apartments/services/auth.dart';

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    )
);


class LoginPage extends StatefulWidget{


  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{

  var _userName;
  final nameController = new TextEditingController();
  var valid = false;
  var apartment = "None";

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 0), //Check this
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.orange[900],
                    Colors.orange[800],
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
                    Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, ),),
                    SizedBox(height: 10,),
                    Text("Welcome Home", style: TextStyle(color: Colors.white, fontSize: 30, ),)
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
                      child: Column(
                        children: <Widget>[

                          SizedBox(height: 80,),

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
                                  child: TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                        hintText: "Enter your full name",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 40,),
                          Column(
                            children: <Widget>[
                              Material(
                                color: Colors.orange[900],
                                borderRadius: BorderRadius.circular(50),
                                child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      _userName = nameController.text;
                                    });
                                    valid = check_userName(_userName);
                                    if(valid){
                                      Navigator.of(context).pushNamed('/IntroductionScreen', arguments: _userName);
                                    }else{
                                      print("Sorry, this app is not for you");
                                    }

                                    //enterApplication(_userName);
                                  },

                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.symmetric(horizontal: 50),
                                    child: Center(
                                        child: Text("Enter", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20,),

                              Material(
                                color: Colors.blueGrey[600],
                                borderRadius: BorderRadius.circular(50),
                                child: InkWell(
                                  onTap: () async {
                                    dynamic result = await _auth.signInAnon();

                                    if(result == null){
                                      print("Error signing in as gues");
                                    }else{
                                      print(result.uid);
                                      Navigator.of(context).pushNamed('/IntroductionScreen', arguments: "Guest");
                                    }
                                    //enterApplication(_userName);
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.symmetric(horizontal: 50),
                                    child: Center(
                                        child: Text("Sign in as Guest", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 80,),

                        ],
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

  bool check_userName(userName) {

    var lowerCaseUserName = userName.toString().toLowerCase();

    if(lowerCaseUserName.startsWith("omar") || lowerCaseUserName.startsWith("dhruv") || lowerCaseUserName.startsWith("tahmeed")
        || lowerCaseUserName.startsWith("khush") || lowerCaseUserName.startsWith("cindy") || lowerCaseUserName.startsWith("codey")
        || lowerCaseUserName.startsWith("abhi")){

      return true;
    } else{
      return false;
    }
  }
}


