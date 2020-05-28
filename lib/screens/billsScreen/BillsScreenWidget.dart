import 'package:flutter/material.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';

import 'billsScreenWidgets/AllBillsWidget.dart';
import 'billsScreenWidgets/BillActionWidget.dart';
import 'billsScreenWidgets/CurrentBillHeader.dart';

const headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

class BillsScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;

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
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Text("Current Bill", style: headerStyle,),
              SizedBox(height: 10,),

              CurrentBillHeader(),

              SizedBox(height: 30,),

              Text("Weekly Expenditure", style: headerStyle),
              SizedBox(height: 10,),

              Container(
                width: double.infinity,
                height: 150,
                color: Colors.white,
              ),

              SizedBox(height: 30,),

              Text("Previous Bills", style: headerStyle),
              SizedBox(height: 10,),

              AllBillsWidget()
            ],
          ),
        )
      ),

      drawer: DrawerWidget()
    );
  }
}









