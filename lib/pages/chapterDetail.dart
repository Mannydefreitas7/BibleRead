import 'package:BibleRead/classes/textHelper.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChapterDetail extends StatelessWidget {
  ChapterDetail({Key key, this.bookName, this.id, this.isBookRead, this.planId}) : super(key: key);

  final String bookName;
  final bool isBookRead;
  final int id;
  final int planId;


  @override
  Widget build(BuildContext context) {
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
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
        ),
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
          future: DatabaseHelper().queryBookChapters(id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final List<Plan> chapters = snapshot.data;
              return ListView.separated(
              itemCount: chapters.toList().length,
              separatorBuilder: (context, index) => Divider(
              height: 3,
              color: Colors.grey[700],
          ),
          itemBuilder: (context, index) {
            bool chapterIsRead = chapters[index].isRead;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                enabled: true,
                onTap: () => {
                },
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
      floatingActionButton: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                backgroundColor: isBookRead ? Colors.grey : Theme.of(context).accentColor,
                onPressed: () => {},
                focusElevation: 5.0,
                child: Icon(isBookRead ? Icons.clear : Icons.check, color: Colors.white, size: 30.0),
                elevation: 2.0,
              ),
            ), 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
