
import 'package:BibleRead/classes/custom/animations.dart';
import 'package:BibleRead/classes/old/CustomToolbar.dart';
import 'package:BibleRead/classes/reading/HtmlView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:share/share.dart';
import 'package:auto_direction/auto_direction.dart';
import 'package:BibleRead/classes/service/SharedPrefs.dart';
class Verses extends StatefulWidget {
  Verses({
    this.isChapter,
    this.verseNumber,
    this.verseLink,
    this.verseText,
    this.book
  });
  final bool isChapter;
  final String book;
  final String verseNumber;
  final String verseLink;
  final String verseText;


  @override
  _VersesState createState() => _VersesState();
}

class _VersesState extends State<Verses> {
 // final CustomToolbar customToolbar = CustomToolbar();
  bool showBookmarkIcon = false;
  void _showBottomSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 150,
        //  clipBehavior: Clip.hardEdge,
          child: BookMarkDialog(
            data: widget.verseLink,
          ),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        );
      });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
        child: Container(
          alignment: Alignment.center,
         // clipBehavior: Clip.none,
          margin: widget.isChapter ? EdgeInsets.all(15) : EdgeInsets.all(10),
          child: Center(
              child: GestureDetector(
            onTap: () => _showBottomSheet(context),
            child: SimpleChapterText(widget: widget),
          )),
        ),
      ),
    Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
                flex: 2,
                child: FadeIn(

                    child: GestureDetector(
                      child: 
                      
                      Container(
                        decoration: BoxDecoration(
                         // color: showBookmarkIcon ? Theme.of(context).accentColor.withOpacity(0.05) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        padding: showBookmarkIcon ? EdgeInsets.all(15) : EdgeInsets.all(0),
                        child: 
                        SimpleVerseText(widget: widget, showBookmarkIcon: showBookmarkIcon),
                      ),
                      onTap: () => setState(() {
                        showBookmarkIcon = !showBookmarkIcon;
                      }),
                    ),
                    delay: 0.2)
                    ),

                    SizedBox(width: showBookmarkIcon ? 10 : 0),

                  showBookmarkIcon ? 
                    Flexible(
                    flex: 0,
                    child: FadeInRight(
                      leaving: showBookmarkIcon,
                       delay: 0.2,
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        CircleAvatar(
                            backgroundColor: Theme.of(context).backgroundColor,
                            child: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(
                                  SFSymbols.xmark,
                                  size: 20,
                                  color: Theme.of(context).textTheme.headline6.color,
                                ),
                                onPressed: () => setState(() => showBookmarkIcon = !showBookmarkIcon))),
                        
                        SizedBox(height: 10, width: 10,),
                       
                        CircleAvatar(
                            backgroundColor: Theme.of(context).backgroundColor,
                            child: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(
                                  SFSymbols.bookmark,
                                  size: 20,
                                  color: Theme.of(context).textTheme.headline6.color,
                                ),
                                onPressed: () => _showBottomSheet(context))),
                          SizedBox(height: 10, width: 10,),
                          CircleAvatar(
                            backgroundColor: Theme.of(context).backgroundColor,
                            child: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(
                                  SFSymbols.square_arrow_up,
                                  size: 20,
                                  color: Theme.of(context).textTheme.headline6.color,
                                ),
                                onPressed: () => {
                                  Share.share('${widget.book} ${SharedPrefs().parseBookMarkedVerse(widget.verseLink)} \n ${widget.verseText}', subject: 'Thought from:  ${widget.book} ${SharedPrefs().parseBookMarkedVerse(widget.verseLink)}')
                                  }))
                      ]
                   ), 
                  ), ) : Text('')
          ])
    ]);
  }
}

class SimpleVerseText extends StatelessWidget {
  const SimpleVerseText({
    Key key,
    @required this.widget,
    @required this.showBookmarkIcon,
  }) : super(key: key);

  final Verses widget;
  final bool showBookmarkIcon;

  @override
  Widget build(BuildContext context) {
    return AutoDirection(
      text: widget.verseText,
          child: Text(
      widget.verseText,
      style: TextStyle(
        fontSize: showBookmarkIcon ? 24 : 22,
        fontStyle: showBookmarkIcon ? FontStyle.italic : FontStyle.normal,
        color: Theme.of(context).textTheme.subtitle1.color,
        fontWeight: showBookmarkIcon ? FontWeight.bold : FontWeight.normal ,
        fontFamily: 'PT Serif',
      ),
      textAlign: TextAlign.left,
      ),
    );
  }
}

class RichVerseText extends StatelessWidget {
  const RichVerseText({
    Key key,
    @required this.widget,
    @required this.showBookmarkIcon,
  }) : super(key: key);

  final Verses widget;
  final bool showBookmarkIcon;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: widget.verseNumber,
              style: TextStyle(
                fontSize: widget.isChapter ? 52 : 22,
                fontFamily: 'Lao MN',
                color: widget.isChapter
                    ? Colors.grey
                    : Theme.of(context).accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: widget.verseText,
              style: TextStyle(
                fontSize: showBookmarkIcon ? 24 : 22,
                fontStyle: showBookmarkIcon ? FontStyle.italic : FontStyle.normal,
                color: Theme.of(context).textTheme.subtitle1.color,
                fontWeight: showBookmarkIcon ? FontWeight.bold : FontWeight.normal ,
                fontFamily: 'PT Serif',
              ),
            )
          ]
        )
      );
  }
}

class SimpleChapterText extends StatelessWidget {
  const SimpleChapterText({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final Verses widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.verseNumber,
      style: TextStyle(
        fontSize: widget.isChapter ? 52 : 22,
        fontFamily: 'Lao MN',
        color: widget.isChapter
            ? Colors.grey
            : Theme.of(context).accentColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

