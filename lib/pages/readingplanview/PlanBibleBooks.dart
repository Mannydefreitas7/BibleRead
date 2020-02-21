import 'dart:convert';

import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/pages/readingplanview/PlanBibleBookCard.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class PlanBibleBooks extends StatelessWidget {

PlanBibleBooks({this.planId});

final int planId;

@override
Widget build(BuildContext context) {
return Column(
  children:[

    Text('Bible Books',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).textTheme.title.color)),

    SizedBox(height: 20),

    Container(
height: 100,
width: MediaQuery.of(context).size.width,
child: FutureBuilder(
future: JwOrgApiHelper().getBibleBooks(),
builder: (context, snap) {

final bookInfo = snap.data;
if (snap.data != null) {
return FutureBuilder(
  future: planId != 2 ? DefaultAssetBundle.of(context).loadString(
  'assets/json/plan_$planId.json') : DefaultAssetBundle.of(context).loadString(
  'assets/json/plan_0.json'),
  builder: (context, snapshot) {

    if (snapshot.data != null) {
  final List planData = json.decode(snapshot.data);
    return ListView.builder(
    itemCount: snapshot.data == null ? 10 : planData.length,
    padding: EdgeInsets.symmetric(
      horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {

        if (snapshot.data == null) {

          return Shimmer.fromColors(
            child: PlanBibleBookCard(
            shortName: '', 
            longName: ''
          ), 
            baseColor: Theme.of(context).backgroundColor, 
            highlightColor: Colors.white
          );

        } else {

          return PlanBibleBookCard(
          shortName: bookInfo['${planData[index]['bookNumber']}']['officialAbbreviation'], 
          longName: bookInfo['${planData[index]['bookNumber']}']['standardName']
        );
        }
        });
    } else {
      return ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.symmetric(
      horizontal: 20),
      scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            child: PlanBibleBookCard(
            shortName: '', 
            longName: ''
          ), 
            baseColor: Theme.of(context).backgroundColor, 
            highlightColor: Colors.white
          );  
        }
        );
    }




      });
} else {
  return Center(child: CircularProgressIndicator());
}
})

)

  ]
);




}
}

