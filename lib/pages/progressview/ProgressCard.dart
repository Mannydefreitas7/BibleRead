import 'package:BibleRead/components/progressCard.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:BibleRead/models/ReadingPlan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';

class ProgressViewCard extends StatelessWidget {

  const ProgressViewCard({Key key, this.showExpected, this.subtitle, this.textOne, this.textThree, this.textTwo}) : super(key: key);
  final String textOne;
  final String textTwo;
  final String textThree;
  final String subtitle;
  final bool showExpected;

 double getExpectedProgressValue(String date, int numberDaysTotal) {
    DateTime dateTime = DateTime.parse(date);
   // int difference = DateTime.now().compareTo(dateTime);
    Duration duration = DateTime.now().difference(dateTime);
    double multiplier = 100 / numberDaysTotal;
    double value = (duration.inDays * multiplier) / 100;
    print(value);
    return value;
  }


  @override
  Widget build(BuildContext context) {
    final bibleBookListData = Provider.of<BibleBookListData>(context);

    return StreamBuilder(
      stream: Rx.combineLatest4<Plan, double, bool, ReadingPlans, ProgressCardData>(bibleBookListData.getUnReadBooks().asStream(), bibleBookListData.getProgressValue().asStream(), SharedPrefs().getExpectedProgress().asStream(), DatabaseHelper().queryCurrentPlan().asStream(), (unreadchapter, progress, expectedProgress, currentReadingPlan) => ProgressCardData(
        progressvalue: progress, 
        unreadchapter: unreadchapter,
        showExpected: expectedProgress,
        readingPlan: currentReadingPlan
        )) ,
      builder: (context, bibleBook) {
    
          if (bibleBook.hasData) {
            ProgressCardData progressdata = bibleBook.data;
            print(progressdata.progressvalue);
                   return Container(
                  child: ProgressCard(
                    showExpected: progressdata.showExpected,
                    subtitle: subtitle, 
                    expectedValue: getExpectedProgressValue(progressdata.readingPlan.startDate, progressdata.readingPlan.numberDaysTotal),
                    progressNumber: 
                    progressdata.progressvalue, 
                    textOne: textOne == null ? '' : textOne, 
                    textTwo: textTwo == null ? progressdata.unreadchapter.longName : textTwo, 
                    textThree: textThree == null ? progressdata.unreadchapter.chapters : textThree,
                    ),
                  height: 110,
            );
} else {
return Shimmer.fromColors(
      child: Container(
          child: ProgressCard(
            subtitle: 'Current', 
            progressNumber: 0.0, 
            textOne: '', textTwo: '', 
            textThree: '',),
                  height: 110,
            ), baseColor: Theme.of(context).backgroundColor, highlightColor: Theme.of(context).cardColor);
}
      });
    
  }
}

class ProgressCardData {
  final Plan unreadchapter;
  final double progressvalue;
  final bool showExpected;
  final ReadingPlans readingPlan;
  ProgressCardData({this.progressvalue, this.unreadchapter, this.showExpected, this.readingPlan});
}
