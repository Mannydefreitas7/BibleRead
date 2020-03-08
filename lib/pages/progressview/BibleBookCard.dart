import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/pages/chapterDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class BibleBookCard extends StatelessWidget {

  final Function notifyProgress;
  final String bookShortName;
  final String bookLongName;
  final int bookId;
  final int selectedPlan;
  final bool isRead;

  BibleBookCard({
    this.isRead, 
    this.bookLongName, 
    this.bookShortName, 
    this.bookId, 
    this.selectedPlan, 
    this.notifyProgress
  });

  @override
  Widget build(BuildContext context) {
    final bibleBookListData = Provider.of<BibleBookListData>(context);
    _markBookRead() => bibleBookListData.markBookRead(bookId);
   return Slidable(
          actionPane: SlidableBehindActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(           
              caption: !isRead ? 'Read' : 'Unread',
              color: Colors.transparent,
              icon: !isRead ? Icons.check : Icons.close,
              foregroundColor: !isRead ? Theme.of(context).accentColor : Theme.of(context).textTheme.caption.color,
              onTap: _markBookRead
          ),

          ],
            child: Container(
              decoration: BoxDecoration(
                 color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              child: ListTile(
                onTap: () => Navigator.push(
              context,
            CupertinoPageRoute(
              maintainState: false,
              fullscreenDialog: false,
              builder: (context) =>
              ChapterDetail(
              bookName: bookLongName,
              isBookRead: isRead,
              id: bookId,
              planId: selectedPlan,
             ))),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  child: Text(bookShortName, style: 
                   TextStyle(color: !isRead ? Colors.black : Colors.grey, fontSize: 16)
                  ,),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                title: Hero(
                      tag: bookLongName,
                      transitionOnUserGestures: true,
                        child: Material(
                  type: MaterialType.transparency, // likely needed
                  child: Text(bookLongName, 
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:  TextStyle(
                        color: !isRead ? Colors.black : Colors.grey, 
                        fontSize: 20, 
                        fontFamily: 'Avenir Next',
                        fontWeight: FontWeight.w600
                              )
                      )),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 20),
              )
        ),
      );
  }
}
