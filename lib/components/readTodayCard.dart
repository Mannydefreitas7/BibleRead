import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../components/bookMarkChip.dart';
import '../pages/bibleReadingView.dart';

class ReadTodayCard extends StatelessWidget {

  ReadTodayCard({
    this.bookName, 
    this.chapters, 
    this.markRead,
    this.chaptersData, 
    this.isDisabled
    });

  final String bookName;
  final String chapters;
  final String chaptersData;
  final bool isDisabled;
  final Function markRead;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text('Read',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: Theme.of(context).textTheme.title.fontWeight,
                  fontSize: Theme.of(context).textTheme.title.fontSize,
                  color: Theme.of(context).textTheme.title.color)),
        ),

        Card(
          elevation: 0.0,
          clipBehavior: Clip.none,
          color: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
              clipBehavior: Clip.none,
              width: MediaQuery.of(context).size.width - 36.0,
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    bookName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0,
                        fontFamily: 'Avenir Next',
                        color: Theme.of(context).textTheme.title.color),
                  ),
                  FlatButton(
  
                      padding: EdgeInsets.only(
                          top: 5, left: 15, bottom: 5, right: 15),
                      child: Text(
                        chapters,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Avenir Next',
                            fontSize: 48.0,
                            color: isDisabled ? Theme.of(context).accentColor : Colors.grey
                            ),
                      ),
                      onPressed: !isDisabled ? null : () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => BibleReadingView(
                                    chapters: chapters,
                                    bookName: bookName,
                                    chaptersData: chaptersData,
                                    actionOnPress: markRead,
                                  )),
                          )),
                  BookMarkChip()
                ],
              )),
        ),
      ],
    );
  }
}
