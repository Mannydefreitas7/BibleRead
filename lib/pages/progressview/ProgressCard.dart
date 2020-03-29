import 'package:BibleRead/components/progressCard.dart';
import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/helpers/animations.dart';
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';

class ProgressViewCard extends StatelessWidget {

  const ProgressViewCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bibleBookListData = Provider.of<BibleBookListData>(context);

    return StreamBuilder(
      stream: Rx.combineLatest2<Plan, double, ProgressCardData>(bibleBookListData.getUnReadBooks().asStream(), bibleBookListData.getProgressValue().asStream(), (unreadchapter, progress) => ProgressCardData(progressvalue: progress, unreadchapter: unreadchapter)) ,
      builder: (context, bibleBook) {

          if (bibleBook.hasData) {
            ProgressCardData progressdata = bibleBook.data;
                   return Container(
                  child: ProgressCard(subtitle: 'Current', progressNumber: progressdata.progressvalue, textOne: '', textTwo: progressdata.unreadchapter.longName , textThree: progressdata.unreadchapter.chapters,),
                  height: 110,
            );
} else {
return Shimmer.fromColors(
      child: Container(
          child: ProgressCard(subtitle: 'Current', progressNumber: 0.0, textOne: '', textTwo: '', textThree: '',),
                  height: 110,
            ), baseColor: Theme.of(context).backgroundColor, highlightColor: Theme.of(context).cardColor);
}
            
      });
    
  }
}

class ProgressCardData {
  final Plan unreadchapter;
  final double progressvalue;
  ProgressCardData({this.progressvalue, this.unreadchapter});
}
