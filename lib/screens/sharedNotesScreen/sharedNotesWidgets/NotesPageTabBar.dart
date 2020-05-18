import 'package:flutter/material.dart';


class NotesPageTabBar extends StatelessWidget {
  const NotesPageTabBar({
    @required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).colorScheme.primaryVariant,
        unselectedLabelColor: Theme.of(context).colorScheme.primaryVariant,
        indicatorColor: Theme.of(context).colorScheme.secondary,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 4,
        isScrollable: true,
        tabs: <Widget>[
          Tab(
            child: Text(
              "Important",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.bold),
            ),
          ),
          Tab(
            child: Text(
              "Shared",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.bold),
            ),
          ),
          Tab(
            child: Text(
              "Leisure",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}