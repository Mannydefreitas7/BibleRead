import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/pages/progressview/ProgressCard.dart';
import 'package:provider/provider.dart';
import '../components/bibleBooksList.dart';
import 'package:flutter/material.dart';
import '../classes/BibleReadScaffold.dart';

class ProgressPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BibleReadScaffold(
      title: 'Progress',
      hasFloatingButton: false,
      selectedIndex: 1,
      bodyWidget: Container(
      child: Stack(
        children: <Widget>[  
            Container(
              margin: EdgeInsets.only(top:50),
              child: BibleBookList()
            ),
            Container(
              padding: EdgeInsets.only(left:15, right:15),
              child: ProgressViewCard(),
            )
        ],
      ),
    ),
    );
  }
}
