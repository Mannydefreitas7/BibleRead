
import 'package:BibleRead/classes/CustomToolbar.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:extended_text/extended_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';

class HtmlView extends StatelessWidget {
  HtmlView({Key key, this.html}) : super(key: key);

  final String html;
  CustomToolbar customToolbar = CustomToolbar();
    @override
  Widget build(BuildContext context) {
    return Html(
        blockSpacing: 10.0,
        backgroundColor: Colors.transparent,
        data: html,
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 100),
        useRichText: false,
        renderNewlines: true,
        defaultTextStyle: TextStyle(
          fontSize: 22,
          color: Theme.of(context).textTheme.subhead.color,
          fontWeight: FontWeight.w400,
          fontFamily: 'Lao MN',
        ),
        customRender: (node, children) {
          
          if (node is dom.Element) {
          if (node.attributes['class'] != null) {

                
          if (node.attributes['class'] == 'verse') {
         
          bool isChapter = node.children[0].children[0].attributes['class'] == 'chapterNum';

          String verseLink = node.children[0].nodes[0].children.first.attributes['data-anchor'].split('#')[1].split('v')[1];
          print(node.children.last.text);
          var test = node.children[0].nodes.toList().where((element) => element.text.contains(' ', 0));

         String text = test.join().replaceAll('<html span>', '');
 
             return Column(
          children: [
            isChapter ? Center(
              child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(),
              clipBehavior: Clip.none,
              width: MediaQuery.of(context).size.width / 1.5,
              margin: EdgeInsets.only(bottom: 20),
              child: Center(
              child: GestureDetector(
                onTap: () => showModalBottomSheet(
                  enableDrag: true,
                  context: context,
                  builder: (_) {
                  return Container(
                    height: 150,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      child: BookMarkDialog(
                        data: verseLink,
                      ),
                      decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                      )
                    );
                  }),
                  child: Text(
                  node.children[0].nodes[0].text.trim(),
                  style: TextStyle(
                  fontSize: 52,
                  fontFamily: 'Avenir Next',
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ),
            ),
          ) : Center(
              child: FlatButton(
              splashColor: Colors.transparent,
              onPressed: () => showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) {
                return Container(
                  height: 150,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    child: BookMarkDialog(
                      data: verseLink,
                    ),
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20)
                  )
                ),
              )
            );
          }),
            child: Text(
            node.children[0].nodes[0].text.trim(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Avenir Next',
              fontWeight: FontWeight.w600,
              color: Theme.of(context).accentColor),
              ),
            ),
          ),

          ExtendedText(text.replaceAll('\"', '').trim(),
            selectionEnabled: true,
            selectionColor: Theme.of(context).accentColor.withOpacity(0.3),
            textSelectionControls: customToolbar,
            onTap: () => customToolbar,
            )
            ]
          );
          } else {
            return SizedBox.shrink();
          }
         
        }}
    });
    }}
 
class BookMarkDialog extends StatelessWidget {
  const BookMarkDialog({Key key, this.data}) : super(key: key);



  final String data;
  @override
  Widget build(BuildContext context) {
   // print(data);
    return BottomSheet(
      backgroundColor: Theme.of(context).cardColor,
        onClosing: () => print(''),
        builder: (context) {
          return Column(children: <Widget>[
            ListTile(
                leading: Icon(
                  Icons.bookmark_border,
                  size: 30,
                  color: Theme.of(context).textTheme.title.color,
                ),
                title: Text(
                  'Save Bookmark',
                  style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).textTheme.title.color,
                      fontWeight: FontWeight.w600),
                ),
              
                trailing: Text(SharedPrefs().parseBookMarkedVerse(data),
                    style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).textTheme.title.color,
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
