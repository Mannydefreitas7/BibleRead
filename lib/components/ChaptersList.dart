
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:BibleRead/pages/progressview/BibleBookCard.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChaptersList extends StatelessWidget {
  ChaptersList({Key key, this.duration}) : super(key: key);
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Consumer<BibleBookListData>(
        builder: (context, bibleBookListData, child) {
      return StreamBuilder(
          stream: bibleBookListData.getAllChapters().asStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              ScrollController scrollController = new ScrollController();
              
              List<Plan> list = snapshot.data;
              
              return ListView.builder(
                  padding: const EdgeInsets.only(top: 70, left: 25, right: 25),
                  scrollDirection: Axis.vertical,
                  controller: scrollController,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    markChapterRead() => bibleBookListData.markChapterRead(list[index].id, list, index);
                    markChapterUnRead() => bibleBookListData.markChapterUnRead(list[index].id, list, index);
                    return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).backgroundColor,
                            child: Text(list[index].shortName,
                            style: TextStyle(color: Theme.of(context).textTheme.headline6.color, 
                            fontWeight: FontWeight.bold
                            ),
                            ),
                          ),
                          title: Text(
                            '${list[index].longName} ${list[index].chapters}',
                          style: TextStyle(color: list[index].isRead ? Theme.of(context).textTheme.caption.color : Theme.of(context).textTheme.headline6.color, 
                            fontWeight: FontWeight.w400,
                            fontSize: 18
                            )
                          ),
                          subtitle: Text(
                            'Day ${index + 1}',
                            style: TextStyle(color: Theme.of(context).textTheme.caption.color, 
                            fontWeight: FontWeight.w400,
                            fontSize: 14
                            )
                          ),
                          onTap: list[index].isRead ? markChapterUnRead : markChapterRead,
                          trailing: list[index].isRead ? Icon(SFSymbols.checkmark_circle_fill, size:25, color: Theme.of(context).accentColor) : Icon(SFSymbols.circle, size:25, color: Theme.of(context).accentColor),
                        )
                        
                        );
                  });
            } else {
              return Container(
                child: Center(
                    child: SpinKitPulse(
                  color: Theme.of(context).accentColor,
                )),
              );
            }
          });
    });
  }
}
