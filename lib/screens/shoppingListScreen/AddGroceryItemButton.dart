import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'AddGroceryBottomSheet.dart';

class AddGroceryItemButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      child: FaIcon(FontAwesomeIcons.plus, color: Theme.of(context).colorScheme.primary,),
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

