import 'package:BibleRead/classes/bibleicons.dart';
import 'package:BibleRead/components/HtmlView.dart';
import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../helpers/LocalDataBase.dart';
import '../helpers/SharedPrefs.dart';

class BibleReadingView extends StatelessWidget {
  final String bookName;
  final String chapters;
  final String chaptersData;
  final bool isChapterRead;
  final Function actionOnPress;

  BibleReadingView(
      {this.bookName,
      this.chaptersData,
      this.chapters,
      this.isChapterRead,
      this.actionOnPress});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     // appBar: ,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05, width: double.infinity),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Icon(
              //   LineAwesomeIcons.newspaper_1,
              //   size: 25,
              //   color: Theme.of(context).textTheme.title.color,
              // ),
              // SizedBox(width: 10),
              Text(
                bookName,
                style: TextStyle(
                    fontSize: 26,
                    color: Theme.of(context).textTheme.title.color,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 5),
              Text(chapters,
                  style: TextStyle(
                      fontSize: 26,
                       color: Theme.of(context).textTheme.title.color,
                      fontWeight:
                          FontWeight.w700)),
              Spacer(),
              IconButton(
                  icon: Icon(
                    Icons.close,
                    
                    color: Theme.of(context).accentColor,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context))
            ],
          ),
        ),
        Expanded(
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor, 
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)
                  )
                  ),
              width: double.infinity,
              padding: EdgeInsets.zero,
              child: FutureBuilder(
                  initialData: false,
                  future: SharedPrefs().getHasBookMark(),
                  builder: (context, hasBookMark) {
                    String bookMarkdata;
                    String chapterHtml;
                    return FutureBuilder(
                        initialData: '2001002',
                        future: SharedPrefs().getBookMarkData(),
                        builder: (context, bookMark) {
                          if (hasBookMark.hasData &&
                              hasBookMark.data &&
                              bookMark.hasData) {
                            bookMarkdata = bookMark.data;
                            chapterHtml =
                                bookMarkdata + '-' + chaptersData.split('-')[1];
                          } else {
                            chapterHtml = chaptersData;
                          }

                          return FutureBuilder(
                              future:
                                  JwOrgApiHelper().getBibleHtml(chapterHtml),
                              builder: (context, htmlData) {
                                if (htmlData.hasData) {
                                  List html = [htmlData.data].toList();
                                  return PageView(
                                      children: html.map((_html) {
                                    return SingleChildScrollView(
                                      child: HtmlView(
                                        html: _html,
                                        book: bookName,
                                      ),
                                    );
                                  }).toList());
                                } else {
                                  return Center(
                                      child: SpinKitDoubleBounce(
                                      color: Theme.of(context).accentColor,
                                    ));
                                }
                              });
                        });
                  })),
        )
      ]),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: actionOnPress,
          focusElevation: 5.0,
          child: Icon(Icons.check, color: Colors.white, size: 30.0),
          elevation: 2.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
