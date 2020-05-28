import 'package:flutter/material.dart';
import 'package:lester_apartments/models/bill.dart';
import 'package:lester_apartments/models/billItem.dart';
import 'package:lester_apartments/shared/DrawerWidget.dart';

import 'billsScreenWidgets/ItemCard.dart';

class FullBillScreen extends StatefulWidget{

  final Bill bill;

  FullBillScreen({@required this.bill});

  @override
  _FullBillScreenState createState() => _FullBillScreenState();
}

class _FullBillScreenState extends State<FullBillScreen> {

  List<ItemCard> itemCardList;

  @override
  void initState() {
    super.initState();
    itemCardList = List<ItemCard>();
  }

  @override
  Widget build(BuildContext context) {

    List<BillItem> items = widget.bill.items;

    items.forEach((item) {
      ItemCard itemCard = ItemCard(item: item);
      itemCardList.add(itemCard);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Text(
                widget.bill.timeStamp,
                style: TextStyle(
                  fontSize: 30
                ),
              ),

              SizedBox(height: 20,),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: itemCardList,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



