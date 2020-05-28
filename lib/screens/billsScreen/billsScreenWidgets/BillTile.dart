import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lester_apartments/models/bill.dart';


class BillTile extends StatelessWidget{

  final Bill bill;

  BillTile({@required this.bill});

  @override
  Widget build(BuildContext context) {

    return Card(
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.receipt),
        title: bill.timeStamp == null ? Text("") : Text(bill.timeStamp),
        subtitle: Text("Items: "+ bill.items.length.toString()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: (){
                Navigator.pushNamed(context, '/FullBillScreen', arguments: bill);
              },
              icon: Icon(Icons.open_in_new),
            )
          ],
        ),
      ),
    );
  }

}