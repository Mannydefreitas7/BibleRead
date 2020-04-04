
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:BibleRead/pages/progressview/BibleBookCard.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BibleBookList extends StatelessWidget {
  BibleBookList({Key key, this.duration}) : super(key: key);
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Consumer<BibleBookListData>(
        builder: (context, bibleBookListData, child) {
      return FutureBuilder(
          future: bibleBookListData.books,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<Plan> list = snapshot.data;
              return ListView.builder(
                  padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
                  scrollDirection: Axis.vertical,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: BibleBookCard(
                          bookLongName: list[index].longName,
                          bookShortName: list[index].shortName,
                          selectedPlan: list[index].planId,
                          bookId: list[index].bookNumber,
                        ));
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
