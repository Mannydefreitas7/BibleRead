import 'package:BibleRead/pages/bibleReadingView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChatperButtonsList extends StatefulWidget {
  ChatperButtonsList({Key key}) : super(key: key);

  @override
  _ChatperButtonsListState createState() => _ChatperButtonsListState();
}

class _ChatperButtonsListState extends State<ChatperButtonsList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,

      child: ListView(

        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 15, right: 15),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: FlatButton(
              color: Theme.of(context).backgroundColor,
              padding: EdgeInsets.all(2),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),),
              child: Text('116', 
              style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Avenir Next',
                      fontSize: 32.0,
                      color: Theme.of(context).accentColor),
              ),
              onPressed: () => Navigator.push(context, 
                CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) =>
                  BibleReadingView()
                )
              ),
            ),
          ),
          

          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: FlatButton(
              color: Theme.of(context).backgroundColor,
              padding: EdgeInsets.all(2),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0), 
              ),
              child: Text('117', 
              style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Avenir Next',
                      fontSize: 32.0,
                      color: Theme.of(context).accentColor),
              ),
              onPressed: () => print('read chapter'),
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: FlatButton(
              color: Theme.of(context).backgroundColor,
              padding: EdgeInsets.all(2),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              child: Text('119', 
              style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Avenir Next',
                      fontSize: 32.0,
                      color: Theme.of(context).accentColor),
              ),
              onPressed: () => print('read chapter'),
            ),
          ),

        ]
      )
    );
  }
}