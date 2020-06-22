import 'package:BibleRead/classes/custom/animations.dart';
import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/reading/bookMarkChip.dart';
import 'package:BibleRead/classes/service/ReadingProgressData.dart';
import 'package:BibleRead/classes/service/SharedPrefs.dart';
import 'package:BibleRead/views/read/Read.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class ReadTodayCard extends StatelessWidget {

  ReadTodayCard({
    this.bookName, 
    this.chapters,
    this.chaptersData, 
    this.isDisabled,
    });

  final String bookName;
  final String chapters;
  final String chaptersData;
  final bool isDisabled;


  @override
  Widget build(BuildContext context) {
    
    return Card( 
            elevation: 0.0,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
            child: Stack(
          children: <Widget>[ 

           StreamBuilder(
                stream: SharedPrefs().getSelectedPlan().asStream(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  int selectedPlan = snapshot.data;

                  return Positioned.fill(
                    child: Image(
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    image: snapshot.hasData ? AssetImage('assets/images/plan_${selectedPlan}_pnr.jpg')
                      : AssetImage('assets/images/today_image.png')),
                    );
            
            }),
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
                                       color: !isDisabled ? Colors.grey : Theme.of(context).accentColor,
                                     ),
                                     SizedBox(width: 5),
                                     Text(
                            AppLocalizations.of(context).translate('read'),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Avenir Next',
                                fontSize: 18.0,
                                color: !isDisabled ? Colors.grey : Theme.of(context).accentColor
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
                                    )),
                                  )
                               ),
                                 BookMarkChip()
                            ],
                            )
                  ],
                )),
          ])
    
    );
  }
}
