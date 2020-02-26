import 'package:BibleRead/classes/page.dart';
import 'package:BibleRead/classes/textHelper.dart';
import 'package:BibleRead/components/bottomNavigationBar.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/main.dart';
import 'package:BibleRead/pages/progress.dart';
import 'package:BibleRead/pages/readingPlan.dart';
import 'package:BibleRead/pages/settings.dart';
import 'package:BibleRead/pages/today.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChapterDetail extends StatefulWidget {
  ChapterDetail({Key key, this.bookName, this.id, this.isBookead, this.planId}) : super(key: key);

  final String bookName;
  final bool isBookead;
  final int id;
  final int planId;

  @override
  _ChapterDetailState createState() => _ChapterDetailState();
}

class _ChapterDetailState extends State<ChapterDetail> {

// _markChapterUnRead(int chaptersId, int planId) {
//   DatabaseHelper().markChapterUnRead(chaptersId, widget.planId);
// }

// _markChapterRead(int chaptersId, int planId) {
//   DatabaseHelper().markChapterRead(chaptersId, widget.planId);
// }

  // _markRead(int id, int planId) {
  //   return DatabaseHelper().markBookRead(id, planId);
  // }

  // _markUnRead(int id, int planId) {
  //   return DatabaseHelper().markBookUnRead(id, planId);
  // }

bool _checkBoolean(int isRead, int chaptersId, int planId) {
   if (isRead == 1) {
       return true;
    } else if (isRead == 0) {
      return false;
    } else {
      return null;
    }
}

//  Function _chapterIsRead(int isRead, int chaptersId, int planId) {
//     if (isRead == 1) {
//        return _markChapterUnRead(chaptersId, planId);
//     } else if (isRead == 0) {
//       return _markChapterRead(chaptersId, planId);
//     } else {
//       return null;
//     }
//  }

   final List<PageItem> tabs = [
    PageItem(pageWidget: Today(), title: 'Today'),
    PageItem(pageWidget: Progress(), title: 'Progress'),
    PageItem(pageWidget: ReadingPlan(), title: 'Reading Plans'),
    PageItem(pageWidget: Settings(), title: 'Settings'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(

      preferredSize: Size.fromHeight(100),
      child: Column(
        children: <Widget>[
          SizedBox(height: 40),
          AppBar(
            primary: true,
            leading: IconButton(
              icon: BackButtonIcon(), 
              onPressed: () {
                Navigator.pop(context);
              }
            ),
           automaticallyImplyLeading: false,
            bottomOpacity: 0.0,
            title: PageTitleText(title: widget.bookName),
            centerTitle: false,
          ),
        ]
      ),
      ),
    //  backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
        ),
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
          future: DatabaseHelper().queryBookChapters(widget.planId, widget.id),
          builder: (context, chaptersData) {

            if (chaptersData.hasData) {
              final List chapters = chaptersData.data;
              return ListView.separated(
          
          itemCount: chapters.toList().length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {

            bool chapterIsRead = _checkBoolean(chapters[index]['IsRead'], chapters[index]['Id'], widget.planId);
            
          //  chapters[index]['IsRead'];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                enabled: true,
                onTap: () => {

                  // _chapterIsRead(chapters[index]['IsRead'], chapters[index]['Id'], widget.planId),
                  // setState(() {
                  //   chapterIsRead = _checkBoolean(chapters[index]['IsRead'], chapters[index]['Id'], widget.planId);
                  // })
                },
                trailing: chapterIsRead ? Icon(Icons.check, size:25, color: Theme.of(context).accentColor) : null,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                title: Text(chapters[index]['Chapters'], 

                style: TextStyle(
                  fontSize: 20,
                  color: chapterIsRead ? Colors.grey : Colors.black,
                  fontWeight: FontWeight.w600
                ),)

              ),
            );
              
          });

            } else {
              return Center(child: CircularProgressIndicator(),);
            }

          }
          )
      ),
      floatingActionButton: FutureBuilder(
        future: DatabaseHelper().bookIsRead(widget.planId, widget.id),
        builder: (context, bookIsRead) {

          if (bookIsRead.hasData) {
                  return Container(
              margin: EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                backgroundColor: bookIsRead.data ? Colors.grey : Theme.of(context).accentColor,
                onPressed: () => {

                    //  bookIsRead.data ? _markUnRead(widget.id, widget.planId)  : _markRead(widget.id, widget.planId),

                     setState(() {})

                },
                focusElevation: 5.0,
                child: Icon(bookIsRead.data? Icons.clear : Icons.check, color: Colors.white, size: 30.0),
                elevation: 2.0,
              ),
            );
          } else {

            return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: widget.isBookead ? Colors.grey : Theme.of(context).accentColor,
          onPressed: () => setState(() {}),
          focusElevation: 5.0,
          child: Icon(widget.isBookead ? Icons.clear : Icons.check, color: Colors.white, size: 30.0),
          elevation: 2.0,
        ),
      );

          }

            
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
    );
  }
}
