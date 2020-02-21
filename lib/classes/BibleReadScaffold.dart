import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../components/bottomNavigationBar.dart';
import 'theme.dart' as Theme;
import 'textHelper.dart';

class BibleReadScaffold extends StatelessWidget {
  BibleReadScaffold({Key key, this.selectedIndex, this.bodyWidget, this.title, this.hasFloatingButton, this.floatingActionOnPress}) : super(key: key);


  final int selectedIndex;
  final bool hasFloatingButton;
  final String title;
  final Function floatingActionOnPress;
  final Widget bodyWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Column(
        children: <Widget>[
          SizedBox(height: 40),
          AppBar(
            automaticallyImplyLeading: false,
            bottomOpacity: 0.0,
            title: PageTitleText(title: title),
            centerTitle: false,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(EvilIcons.user, size: 40, color: Colors.black),
              ),
            )
          ],
          ),    
        ]
      ),
      ),
      body: bodyWidget,
      floatingActionButton: hasFloatingButton ? FloatingActionButton(
        backgroundColor: Theme.brThemeData.accentColor,
        onPressed: floatingActionOnPress,
        focusElevation: 5.0,
        child: Icon(Icons.check, color: Colors.white, size: 30.0),
        elevation: 2.0,
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BRBottomNavBar(
        selectedIndex: selectedIndex
      )
    );
  }
}

