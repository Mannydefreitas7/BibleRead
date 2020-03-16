import 'package:BibleRead/classes/CustomToolbar.dart';
import 'package:BibleRead/classes/Verses.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import "package:html/dom.dart" as dom;

class HtmlView extends StatelessWidget {
  HtmlView({Key key, this.html, this.book}) : super(key: key);

  final String html;
  final String book;
  final CustomToolbar customToolbar = CustomToolbar();
  @override
  Widget build(BuildContext context) {
    return Html(
        blockSpacing: 10.0,
        backgroundColor: Colors.transparent,
        data: html,
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 100),
        useRichText: false,
       // renderNewlines: true,
        defaultTextStyle: TextStyle(
          fontSize: 22,
          color: Theme.of(context).textTheme.subhead.color,
          fontWeight: FontWeight.normal,
          fontFamily: 'PT Serif',
        ),
        customRender: (node, children) {
          List<Verses> nodes = [];
          List<dom.Node> _nodes = [...node.children.where((element) => element.text.contains(' '))];
       
          for (var n in _nodes) {
            if (n.attributes['class'] == 'verse') {
              if (n.children[0].children.toList().isNotEmpty) {
                String text = n.text 
                   .substring(3)
                   .trimLeft()
                   .replaceAll('+', ' ')
                   .replaceAll('*', ' ')
                   .replaceAll('\"', '. ')
                   .replaceAll(';', '; ')
                   .replaceAll('\ʹ', '\'')
                   .replaceAll(',', ', ');
                bool isChapter =
                    n.children[0].children[0].attributes['class'] ==
                        'chapterNum';
                String number = n.children[0].children[0].text.trim();
                String verseLink = n.children[0].children[0].children[0]
                    .attributes['data-anchor']
                    .split('#')[1]
                    .split('v')[1];
                nodes.add(Verses(
                  verseText: text,
                  book: book,
                  verseLink: verseLink,
                  isChapter: isChapter,
                  verseNumber: number,
                ));
              } 
            } 
          }
          return Column(children: nodes);
        });
  }
}

class BookMarkDialog extends StatelessWidget {
  const BookMarkDialog({Key key, this.data}) : super(key: key);

  final String data;
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        enableDrag: true,
        elevation: 2.0,
        backgroundColor: Theme.of(context).cardColor,
        clipBehavior: Clip.hardEdge,
        onClosing: () => print(''),
        builder: (context) {
          return Column(
            children: <Widget>[
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
                      Navigator.of(context).popAndPushNamed('/')
                    }),
                    Divider(
                      height: 3,
                      color: Theme.of(context).textTheme.caption.color.withOpacity(0.5),
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
