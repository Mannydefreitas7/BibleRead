import 'package:BibleRead/classes/textHelper.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChapterDetail extends StatelessWidget {
  ChapterDetail({Key key, this.bookName, this.id, this.planId}) : super(key: key);

  final String bookName;
  ///static Future<bool> isBookRead;
  final int id;
  final int planId;

  @override
  Widget build(BuildContext context) {
   // final bibleBookListData = Provider.of<BibleBookListData>(context);
   
    return Consumer<BibleBookListData>(

    builder: (context, bibleBookListData, child) {
       markBookRead() => bibleBookListData.markBookRead(id);
      markBookUnRead() => bibleBookListData.markBookUnRead(id);
     
        return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(

        preferredSize: Size.fromHeight(100),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            AppBar(

              primary: true,
              leading: IconButton(
                color: Theme.of(context).textTheme.title.color,
                icon: BackButtonIcon(), 
                onPressed: () {
                  Navigator.pop(context);
                }
              ),
             automaticallyImplyLeading: false,
              bottomOpacity: 0.0,
              title: Hero(
                tag: bookName,
                transitionOnUserGestures: false,
                
                child: Material(
                    type: MaterialType.transparency, // likely needed
                    child: PageTitleText(
                      title: bookName,
                      textColor: Theme.of(context).textTheme.title.color,
                      )
              )),
              centerTitle: false,
            ),
          ]
        ),
        ),
        body: Container(
        //  clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
          ),
          padding: EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          height: double.infinity,
          child: StreamBuilder(
            stream: bibleBookListData.getChapters(id).asStream(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
  
                final List<Plan> chapters = snapshot.data;
                return ListView.separated(
                itemCount: chapters.toList().length,
                separatorBuilder: (context, index) => Divider(
                height: 3,
                color: Theme.of(context).textTheme.caption.color,
            ),
            itemBuilder: (context, index) {
              bool chapterIsRead = chapters[index].isRead;
              markChapterRead() => bibleBookListData.markChapterRead(chapters[index].id, chapters, index);
              markChapterUnRead() => bibleBookListData.markChapterUnRead(chapters[index].id, chapters, index);
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  enabled: true,
                  onTap: chapterIsRead ? markChapterUnRead : markChapterRead,
                  trailing: chapterIsRead ? Icon(Icons.check, size:25, color: Theme.of(context).accentColor) : null,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  title: Text(chapters[index].chapters, 
                  style: TextStyle(
                    fontSize: 20,
                    color: chapterIsRead ? Colors.grey : Theme.of(context).textTheme.title.color,
                    fontWeight: FontWeight.w600
                  ),)
                ),
              );      
            });
              } else {
                return Center(child: CircularProgressIndicator(),);
              }
            })
        ),
         floatingActionButton: 
        Container(
               margin: EdgeInsets.only(bottom: 20),
        
               child: 
               // FloatingActionButton(
        //               backgroundColor: bibleBookListData.checkBookIsRead(id) ? Colors.grey : Theme.of(context).accentColor,
        //               onPressed: bibleBookListData.checkBookIsRead(id) ? markBookUnRead : markBookRead,
        //               focusElevation: 5.0,
        //               child: Icon(bibleBookListData.checkBookIsRead(id) ? Icons.clear : Icons.check, color: Colors.white, size: 30.0),
        //               elevation: 2.0,
        //         )
                
                FutureBuilder(
                  future: bibleBookListData.checkBookIsRead(id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      bool isBookRead = snapshot.data;
                      return FloatingActionButton(
                      backgroundColor: isBookRead ? Colors.grey : Theme.of(context).accentColor,
                      onPressed: isBookRead ? markBookUnRead : markBookRead,
                      focusElevation: 5.0,
                      child: Icon(isBookRead ? Icons.clear : Icons.check, color: Colors.white, size: 30.0),
                      elevation: 2.0,
                );
                    } else {
                      return Container();
                    }
                   
                  },
                ),

              ), 
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }
    );
  }
}
