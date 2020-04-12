
import 'package:BibleRead/helpers/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import '../components/bottomNavigationBar.dart';

import 'textHelper.dart';

class BibleReadScaffold extends StatelessWidget {
  BibleReadScaffold({Key key, this.selectedIndex, this.bodyWidget, this.title, this.hasFloatingButton, this.floatingActionOnPress, this.hasBottombar, this.hasLeadingIcon}) : super(key: key);


  final int selectedIndex;
  final bool hasFloatingButton;
  final String title;
  final Function floatingActionOnPress;
  final Widget bodyWidget;
  final bool hasBottombar;
  final bool hasLeadingIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: Column(
        children: <Widget>[
          SizedBox(height: 40),
          AppBar(
            automaticallyImplyLeading: false,
            leading: hasLeadingIcon ? BackButton(color: Theme.of(context).textTheme.headline6.color, onPressed: () => Navigator.pop(context),) : null
            ,
            bottomOpacity: 0.0,
            title: PageTitleText(title: title),
            centerTitle: false,
          actions: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(right: 15),
            //   child: CircleAvatar(
            //     backgroundColor: Colors.transparent,
            //     child: Icon(EvilIcons.user, size: 40, color: Colors.black),
            //   ),
            // )
          ],
          ),    
        ]
      ),
      ),
      body: bodyWidget,
      floatingActionButton: hasFloatingButton ? 
      Container(
        margin: EdgeInsets.only(bottom: 20.0),
    //   clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 2),
              blurRadius: 5.0,
             // spreadRadius: 2.0
          ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(25))
        ),
        child:  FlatButton.icon(
        padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))
        ),
        color: Theme.of(context).accentColor,
        onPressed: floatingActionOnPress, 
        icon: Icon(SFSymbols.checkmark_alt,
        size: 24, 
        color: Colors.white,
        ), 
        label: Text(AppLocalizations.of(context).translate('mark_read'), style: TextStyle(
          fontSize: 20.0,
          color: Colors.white
        ),)
      ),
    )
       : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: hasBottombar ? BRBottomNavBar(
        selectedIndex: selectedIndex
      ) : null
    );
  }
}

