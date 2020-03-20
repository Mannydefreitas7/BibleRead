import '../components/bottomNavigationBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/page.dart';

import '../pages/progress.dart';
import '../pages/today.dart';
import '../pages/readingPlan.dart';
import '../pages/settings.dart';

class MainView extends StatefulWidget {

  final Widget brWidget;
  final int tabIndex;
  final Text title;
  final List<Widget> actions;
  final bool isNavItem;

  MainView({this.brWidget ,this.tabIndex, this.title, this.actions, this.isNavItem});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  int selectedIndex = 0;
  bool isNavItem = false;

  final List<PageItem> tabs = [
   // PageItem(pageWidget: Today()),
    PageItem(pageWidget: Progress()),
    PageItem(pageWidget: ReadingPlan()),
    PageItem(pageWidget: Settings()),
  ];

   void onItemTapped(int index) {
    setState(() {
      if (widget.isNavItem) {
        isNavItem = true;
      } else {
        isNavItem = false;
      }
        selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
        child:  isNavItem ? tabs[selectedIndex].pageWidget : widget.brWidget,
      );
  }
}
