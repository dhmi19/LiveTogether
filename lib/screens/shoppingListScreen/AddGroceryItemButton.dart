import 'package:flutter/material.dart';

import 'AddGroceryBottomSheet.dart';

class AddGroceryItemButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      child: Icon(Icons.add, size: 40, color: Theme.of(context).colorScheme.primary,),
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

