import 'package:flutter/material.dart';
import 'package:lester_apartments/services/database.dart';

import 'AddGroceryBottomSheet.dart';

class AddGroceryItemButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      child: Icon(Icons.add, size: 40, color: Colors.white,),
      onPressed: (){
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddGroceryBottomSheet()
        );
      },
    );
  }
}

