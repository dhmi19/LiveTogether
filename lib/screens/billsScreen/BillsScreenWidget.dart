import 'package:flutter/material.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';

class BillsScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,

        centerTitle: true,
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Text("Your current bill: ", style: TextStyle(fontSize: 18),),
              SizedBox(height: 10,),
              Card(
                color: Colors.white,
                child: Container(
                  width: double.infinity,
                  height: 20,
                ),
              )

            ],
          ),
        )
      ),

      drawer: DrawerWidget()
    );
  }
}
