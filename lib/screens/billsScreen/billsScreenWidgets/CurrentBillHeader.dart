import 'package:flutter/material.dart';

import 'AmountDueCard.dart';
import 'ItemsBoughtCard.dart';

class CurrentBillHeader extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: AmountDueCard(),
        ),

        SizedBox(width: 20,),

        Expanded(
          child: ItemsBoughtCard(),
        ),

      ],
    );
  }
}