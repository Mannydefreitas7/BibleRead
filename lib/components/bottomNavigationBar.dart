import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/bibleicons.dart';
import '../classes/page.dart';

class BRBottomNavBar extends StatelessWidget {
  final int selectedIndex;

  BRBottomNavBar({this.selectedIndex});

    List tabs = [
    PageItem(route: '/today'),
    PageItem(route: '/progress'),
    PageItem(route: '/readingplans'),
    PageItem(route: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                spreadRadius: 3.0,
                blurRadius: 7.0)
          ],
        ),
      //  height: MediaQuery.of(context).size.height * 0.1,
        child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) => {
                 Navigator.of(context).popAndPushNamed(tabs[index].route),
      
              },
              backgroundColor: Theme.of(context).bottomAppBarColor,
              elevation: 0.0,
              selectedFontSize: 12.0,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: TextStyle(),
              showUnselectedLabels: true,

              showSelectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    BibleIcons.today,
                    size: 35.0,
                  ),
                  title: Text(
                    'Today',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      BibleIcons.progress,
                      size: 35.0,
                    ),
                    title: Text(
                      'Progress',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      BibleIcons.plans,
                      size: 35.0,
                    ),
                    title: Text(
                      'Plans',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      BibleIcons.settings,
                      size: 35.0,
                    ),
                    title: Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )),
              ],
            )));
  }
}
