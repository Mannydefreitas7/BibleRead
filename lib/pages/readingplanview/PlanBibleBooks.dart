import 'dart:convert';

import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/pages/readingplanview/PlanBibleBookCard.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';

class PlanBibleBooks extends StatelessWidget {
  PlanBibleBooks({this.planId});

  final int planId;

  @override
  Widget build(BuildContext context) {
    int selectedPan = planId != 2 ? planId : 0;
    return Column(children: [
      Text('Bible Books',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.title.color)),
      SizedBox(height: 20),
      Container(
          height: 100,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
              stream: Rx.combineLatest2<Map<dynamic, dynamic>, String,
                      ReadingPlanBibleBooks>(
                  JwOrgApiHelper().getBibleBooks().asStream(),
                  DefaultAssetBundle.of(context)
                      .loadString('assets/json/plan_$selectedPan.json')
                      .asStream(),
                  (books, json) =>
                      ReadingPlanBibleBooks(books: books, json: json)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  ReadingPlanBibleBooks data = snapshot.data;

                  final List planData = json.decode(data.json);
                  final Map bookInfo = data.books;
                  return ListView.builder(
                      itemCount: planData.length,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                       return PlanBibleBookCard(
                            shortName:
                                bookInfo['${planData[index]['bookNumber']}']
                                    ['officialAbbreviation'],
                            longName:
                                bookInfo['${planData[index]['bookNumber']}']
                                    ['standardName']);
                      });
                } else {
                  return ListView.builder(
                      itemCount: 10,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                            child:
                                PlanBibleBookCard(shortName: '', longName: ''),
                            baseColor: Theme.of(context).backgroundColor,
                            highlightColor: Colors.white);
                      });
                }
              }))
    ]);
  }
}

class ReadingPlanBibleBooks {
  String json;
  Map<dynamic, dynamic> books;

  ReadingPlanBibleBooks({this.books, this.json});
}
