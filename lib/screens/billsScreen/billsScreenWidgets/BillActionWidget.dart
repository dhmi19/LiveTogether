import 'package:flutter/material.dart';

class BillActionsWidget extends StatelessWidget {
  const BillActionsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.payment, color: Theme.of(context).colorScheme.primary, size: 30,),
                ),
                SizedBox(height: 3,),
                Text("Settle Bill")
              ],
            ),
          )
        ],
      ),
    );
  }
}