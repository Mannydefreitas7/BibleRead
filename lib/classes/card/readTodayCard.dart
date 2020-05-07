import 'package:BibleRead/classes/custom/animations.dart';
import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/reading/bookMarkChip.dart';
import 'package:BibleRead/views/read/Read.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

class ReadTodayCard extends StatelessWidget {

  ReadTodayCard({
    this.bookName, 
    this.chapters,
    this.selectedPlan,
    this.markRead,
    this.bibleViewMarkRead,
    this.chaptersData, 
    this.isDisabled,
    this.removeBookMark
    });

  final String bookName;
  final String chapters;
  final int selectedPlan;
  final String chaptersData;
  final bool isDisabled;
  final Function markRead;
  final Function bibleViewMarkRead;
  final Function removeBookMark;

  @override
  Widget build(BuildContext context) {
    return  Card(
            elevation: 0.0,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
            child: Stack(
          children: <Widget>[ 
              Positioned.fill(
                              child: Image(
                  alignment: Alignment.center,
             // width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                image:
                selectedPlan != null ? AssetImage('assets/images/plan_${selectedPlan}_pnr.jpg')
                   : AssetImage('assets/images/today_image.png')),
              ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                  Colors.black12,
                  Colors.black45,
                  Colors.black
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                )
                )
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Text(
                      bookName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          fontFamily: 'Avenir Next',
                          color: Colors.white),
                    ),

                  FadeIn(
                       delay: 0.5,
                            child: Text(
                            chapters,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Avenir Next',
                                fontSize: 52.0,
                                color: Colors.white
                                ),
                          ),
                        ),
                        SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                               FlatButton(
                                 child: 
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: <Widget>[
                                     Icon(
                                       SFSymbols.doc_plaintext,
                                       size: 24,
                                       color: Theme.of(context).accentColor,
                                     ),
                                     SizedBox(width: 5),
                                     Text(
                            'Read Online',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Avenir Next',
                                fontSize: 18.0,
                                color: Theme.of(context).accentColor
                                ),
                          ),
                                   ],
                                 ),
                          onPressed: !isDisabled ? null : () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                title: bookName,
                                  fullscreenDialog: true,
                                  builder: (context) => BibleReadingView(
                                      chapters: chapters,
                                      bookName: bookName,
                                      chaptersData: chaptersData,
                                      actionOnPress: bibleViewMarkRead,
                                    )),
                            )
                               ),
                                 BookMarkChip(onChipPress: removeBookMark,)
                            ],
                            )
                  
                  ],
                )),
          ])
    
    );
  }
}
