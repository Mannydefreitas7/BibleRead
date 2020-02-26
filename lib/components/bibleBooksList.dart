import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:BibleRead/pages/progressview/BibleBookCard.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BibleBookList extends StatefulWidget {
  BibleBookList({Key key, this.duration}) : super(key: key);
  final Duration duration;
  @override
  _BibleBookListState createState() => _BibleBookListState();
}

class _BibleBookListState extends State<BibleBookList> {
//AnimationController _controller;

@override
void initState() {
super.initState();

}

@override
void dispose() {
  super.dispose();
}

  // _markRead(int id, int planId) {
  //   return DatabaseHelper().markBookRead(id, planId);
  // }

  // _markUnRead(int id, int planId) {
  //   return DatabaseHelper().markBookUnRead(id, planId);
  // }

  @override
  Widget build(BuildContext context) {
    
  //   return FutureBuilder(
  //   future: DatabaseHelper().filterBooks(),
  //   builder: (context, planData) {
  //     if (planData.hasData) {
  //        final List<Plan> plan = planData.data;

  //        return ListView.builder(
          
  //       padding: const EdgeInsets.only(
  //       top: 70, left: 20, right: 20),
  //       scrollDirection: Axis.vertical,
  //       itemCount: plan.length,
  //       itemBuilder: (context, index) {
  //       return Container(
  //        margin: EdgeInsets.only(bottom: 10),
  //        child: BibleBookCard(
  //          notifyProgress: widget.notifyProgress,
  //         bookLongName: plan[index].longName,
  //         bookShortName: plan[index].shortName,
  //         selectedPlan: plan[index].planId,
  //         bookId: plan[index].bookNumber,
  //        )
  //      );
  //   });
  // } else {
  //   return Center(child: CircularProgressIndicator());
  // }
  //      });

  return Consumer<BibleBookListData>(

    builder: (context, bibleBookListData, child) {
      List list = Provider.of<BibleBookListData>(context).bibleBooks;
      print(list);
      if (list != null) {
        return  ListView.builder(
        padding: const EdgeInsets.only(
        top: 70, left: 20, right: 20),
        scrollDirection: Axis.vertical,
        itemCount: 66,
        itemBuilder: (context, index) {
        return Container(
         margin: EdgeInsets.only(bottom: 10),
         child: BibleBookCard(
          bookLongName: list[index].longName,
          bookShortName: list[index].shortName,
          selectedPlan: list[index].planId,
          bookId: list[index].bookNumber,
         )
       );
    });
      } else {
    return Center(child: CircularProgressIndicator());
  }
});


 }
}
