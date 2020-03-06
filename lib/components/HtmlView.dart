import 'package:BibleRead/components/bookMarkChip.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';

class HtmlView extends StatelessWidget {
  const HtmlView({Key key, this.html}) : super(key: key);

  final String html;

  @override
  Widget build(BuildContext context) {
    return Html(
        blockSpacing: 10.0,
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 100),
        useRichText: false,
        defaultTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          fontFamily: 'Lao MN',
        ),
        customRender: (node, children) {
          if (node is dom.Element) {
            if (node.attributes['class'] != null) {

              if (node.attributes['class'].contains('jsBibleLink') ||
                  node.attributes['class'].contains('footnoteLink')) {

                return SizedBox(width: 0, height: 0,);
              } else if (node.attributes['class'].contains('verseNum')) {
              //  print(node.firstChild.attributes['href'].split('#')[1]);
                return Center(
                  child: FlatButton(
                    splashColor: Colors.transparent,
                    onPressed: () => showModalBottomSheet(
                        backgroundColor: Colors.black,
                        context: context,
                        builder: (_) {
                          return Container(
                              height: 150,
                              child: Container(
                                child: BookMarkDialog(
                                  data: node.firstChild.attributes['href'].split('#')[1].split('v')[1],
                                ),
                                decoration: BoxDecoration(
                                    // color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20))),
                              ));
                        }),
                    child: Text(
                      node.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Avenir Next',
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor),
                    ),
                  ),
                );
              } else if (node.attributes['class'].contains('chapterNum')) {
                return Center(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(),
                    clipBehavior: Clip.none,
                    width: MediaQuery.of(context).size.width / 1.5,
                    // height: 50,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Center(
                        child: GestureDetector(
                          onTap: () => showModalBottomSheet(
                            enableDrag: true,
                        backgroundColor: Colors.black,
                        context: context,
                        builder: (_) {
                          return Container(
                              height: 150,
                              child: Container(
                                child: BookMarkDialog(
                                  data: node.firstChild.attributes['href'].split('#')[1].split('v')[1],
                                ),
                                decoration: BoxDecoration(
                                    // color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20))),
                              ));
                        }),
                       child: Text(
                      node.text,
                      style: TextStyle(
                          fontSize: 52,
                          fontFamily: 'Avenir Next',
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                      ),
                    ),
                        )),
                  ),
                );
              } else {
                return null;
              }
            }
          }
        },
        backgroundColor: Colors.transparent,
        data: html);
  }
}

class BookMarkDialog extends StatelessWidget {
  const BookMarkDialog({Key key, this.data}) : super(key: key);



  final String data;
  @override
  Widget build(BuildContext context) {
    print(data);
    return BottomSheet(
        onClosing: () => print(''),
        builder: (context) {
          return Column(children: <Widget>[
            ListTile(
                leading: Icon(
                  Icons.bookmark_border,
                  size: 30,
                  color: Colors.black,
                ),
                title: Text(
                  'Save Bookmark',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              
                trailing: Text(SharedPrefs().parseBookMarkedVerse(data),
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)),
                onTap: () => {
                    SharedPrefs().setBookMarkData(data),
                    SharedPrefs().setBookMarkTrue(),
                  //  print(data),
                    
                    Navigator.of(context).popAndPushNamed('/')
                   
                }
                ),
            ListTile(
                title: Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.pop(context))
          ]);
        });
  }
}
