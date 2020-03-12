import 'package:BibleRead/components/HtmlView.dart';
import 'package:BibleRead/helpers/animations.dart';
import 'package:flutter/material.dart';
import 'package:BibleRead/classes/CustomToolbar.dart';

import 'package:extended_text/extended_text.dart';

class Verses extends StatefulWidget {
  Verses({
    this.isChapter,
    this.verseNumber,
    this.verseLink,
    this.verseText,
  });
  final bool isChapter;
  final String verseNumber;
  final String verseLink;
  final String verseText;

  @override
  _VersesState createState() => _VersesState();
}

class _VersesState extends State<Verses> {
  final CustomToolbar customToolbar = CustomToolbar();
  bool showBookmarkIcon = false;
  void _showBottomSheet(BuildContext context) => showModalBottomSheet(
                  enableDrag: true,
                  context: context,
                  builder: (_) {
                    return Container(
                          height: 150,
                          clipBehavior: Clip.hardEdge,
                          child: BookMarkDialog(
                            data: widget.verseLink,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20))),
                      );
                  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            alignment: Alignment.center,
           // decoration: BoxDecoration(),
            clipBehavior: Clip.none,
            
          //  width: MediaQuery.of(context).size.width / 1.5,
            margin: widget.isChapter ? EdgeInsets.all(15) : EdgeInsets.all(10),
            child: Center(
                child: GestureDetector(
              onTap: () => _showBottomSheet(context),
              child: Text(
                widget.verseNumber,
                style: TextStyle(
                  fontSize: widget.isChapter ? 52 : 22,
                  fontFamily: 'Avenir Next',
                  color: widget.isChapter ? Colors.grey : Theme.of(context).accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
          ),
        ),

            Row(

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex:  3,
                  child: FadeIn(child: ExtendedText(
                
          widget.verseText,

          textAlign: TextAlign.left,
          selectionEnabled: true,
          selectionColor: Theme.of(context).accentColor.withOpacity(0.3),
          textSelectionControls: customToolbar,
          onTap: () => setState(() {showBookmarkIcon = !showBookmarkIcon;}),
        ), delay: 0.2))
        ,
        Flexible(
          flex: 0,
          child: 
        showBookmarkIcon ? 
        
        FadeInRight(0.2, 
        IconButton(

          color: Theme.of(context).buttonColor,
          icon: Icon(Icons.bookmark_border, color: Theme.of(context).accentColor,), 
        onPressed: () => _showBottomSheet(context)
        ))  : 
        Text(''))
              ]
            )
    ]);
  }
}
