import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:BibleRead/pages/progressview/BibleBookCard.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BibleBookList extends StatelessWidget {
  BibleBookList({Key key, this.duration}) : super(key: key);
  final Duration duration;
 Future<List<Plan>> _list;
    List<Plan> tempList = [];



 bool _checkBookIsRead(int index) {

  BibleBookListData().getChapters(index).then((value) => tempList = value);
  var filteredList = tempList.where((item) => item.isRead == false);
  print(tempList);
  if (filteredList.length == 0) {
    return true;
  } else {
    return false;
  }
 } 

  @override
  Widget build(BuildContext context) {

  return Consumer<BibleBookListData>(

    builder: (context, bibleBookListData, child) {
       return FutureBuilder(
          future: bibleBookListData.books,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {

              List<Plan> list = snapshot.data;
            
              return  ListView.builder(
              padding: const EdgeInsets.only(
              top: 70, left: 20, right: 20),
              scrollDirection: Axis.vertical,
              itemCount: list.length,
              itemBuilder: (context, index) {
                print(list[index].isRead);
              return Container(
              margin: EdgeInsets.only(bottom: 10),
              child: BibleBookCard(
                bookLongName: list[index].longName,
                bookShortName: list[index].shortName,
                selectedPlan: list[index].planId,
                bookId: list[index].bookNumber,
                isRead: _checkBookIsRead(list[index].bookNumber),
         )
       );
    });
  } else {
    return Container(
      child: Center(
        child: CircularProgressIndicator()
      ),
    );
  }
    }); 
});


 }
}
