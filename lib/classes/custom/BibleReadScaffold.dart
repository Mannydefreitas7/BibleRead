import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/custom/bottomNavigationBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import 'textHelper.dart';

class BibleReadScaffold extends StatelessWidget {
  BibleReadScaffold({Key key, this.selectedIndex, this.bodyWidget, this.title, this.hasFloatingButton, this.floatingActionOnPress, this.hasBottombar, this.isLoading, this.hasLeadingIcon}) : super(key: key);

  final int selectedIndex;
  final bool hasFloatingButton;
  final String title;
  final Function floatingActionOnPress;
  final Widget bodyWidget;
  final bool hasBottombar;
  final bool hasLeadingIcon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    bool _isLoading = this.isLoading != null ? this.isLoading : false;
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
      clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).accentColor.withOpacity(0.4),
              offset: Offset(1, 4),
              blurRadius: 10.0,

          //   spreadRadius: 1.5
          )
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
        icon: _isLoading == false ? Icon(SFSymbols.checkmark_alt,
        size: 24, 
        color: Colors.white,
        ) : CircularProgressIndicator(
          backgroundColor: Colors.white,
          strokeWidth: 3,
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

