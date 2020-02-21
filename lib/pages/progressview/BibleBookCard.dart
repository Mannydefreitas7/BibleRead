import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/pages/chapterDetail.dart';
import 'package:BibleRead/pages/progressview/ProgressCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shimmer/shimmer.dart';
import '../progress.dart';

class BibleBookCard extends StatefulWidget {

  final Function notifyProgress;
  final String bookShortName;
  final String bookLongName;
  final int bookId;
  final int selectedPlan;

  BibleBookCard({this.bookLongName, this.bookShortName, this.bookId, this.selectedPlan, this.notifyProgress});

  @override
  _BibleBookCardState createState() => _BibleBookCardState();
}

class _BibleBookCardState extends State<BibleBookCard> {

  bool _bookIsRead;


  _markRead(int id, int planId) {
    return DatabaseHelper().markBookRead(id, planId);
  }

  _markUnRead(int id, int planId) {
    return DatabaseHelper().markBookUnRead(id, planId);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          initialData: false,
          future: DatabaseHelper().bookIsRead(widget.selectedPlan, widget.bookId),
          builder: (context, bookData) {
          
          if (bookData.hasData) {
          bool _bookData = bookData.data;
          return Slidable(
          actionPane: SlidableBehindActionPane(),
          secondaryActions: <Widget>[
           
           IconSlideAction(           
            caption: !_bookData ? 'Read' : 'Unread',
            color: Colors.transparent,
            icon: !_bookData ? Icons.check : Icons.close,
          foregroundColor: !_bookData ? Theme.of(context).accentColor : Theme.of(context).textTheme.caption.color,
            onTap: () => {



              _bookData ? _markUnRead(widget.bookId, widget.selectedPlan)  : _markRead(widget.bookId, widget.selectedPlan),
               
              setState(() => {
                 _bookData = bookData.data

              }),

            },
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
            MaterialPageRoute(
              maintainState: false,
              fullscreenDialog: false,
              builder: (context) =>
              ChapterDetail(
              bookName: widget.bookLongName,
              isBookead: _bookData,
              id: widget.bookId,
              planId:widget.selectedPlan,
             ))),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  child: Text(widget.bookShortName, style: 
                   TextStyle(color: !_bookData ? Colors.black : Colors.grey, fontSize: 16)
                  ,),
                ),
                
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                title: Text(widget.bookLongName, style: 
                     TextStyle(color: !_bookData ? Colors.black : Colors.grey, fontSize: 20, fontWeight: FontWeight.w600)),
                trailing: Icon(Icons.arrow_forward_ios, size: 20),
              )
        ),
      );
          } else {
            bool _bookData = false;
            return Slidable(
          actionPane: SlidableBehindActionPane(),
          secondaryActions: <Widget>[
           
           IconSlideAction(           
            caption: !_bookData ? 'Read' : 'Unread',
            color: Colors.transparent,
            icon: !_bookData ? Icons.check : Icons.close,
          foregroundColor: !_bookData ? Theme.of(context).accentColor : Theme.of(context).textTheme.caption.color,
            onTap: () => {

              _bookData ? _markUnRead(widget.bookId, widget.selectedPlan)  : _markRead(widget.bookId, widget.selectedPlan),
              
              setState(() => {
                  widget.notifyProgress,
                 _bookData = bookData.data

              })

            },
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
            MaterialPageRoute(
              maintainState: false,
              fullscreenDialog: false,
              builder: (context) =>
              ChapterDetail(
              isBookead: false,
              bookName: widget.bookLongName,
              id: widget.bookId,
              planId:widget.selectedPlan,
             ))),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  child: Text(widget.bookShortName, style: 
                   TextStyle(color: Colors.black, fontSize: 16)
                  ,),
                ),
                
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                title: Text(widget.bookLongName, style: 
                     TextStyle(color:Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
                trailing: Icon(Icons.arrow_forward_ios, size: 20),
              )
            )
        );
 
          }
        }
    );
  }
}