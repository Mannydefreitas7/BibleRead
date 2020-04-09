import 'package:BibleRead/components/progressCard.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:BibleRead/models/ReadingPlan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ProgressViewCard extends StatelessWidget {

  const ProgressViewCard({Key key, this.showExpected, this.subtitle, this.textOne, this.textThree, this.textTwo}) : super(key: key);
  final String textOne;
  final String textTwo;
  final String textThree;
  final String subtitle;
  final bool showExpected;

 double getExpectedProgressValue(String date, int numberDaysTotal) {
    DateTime dateTime = DateTime.parse(date);
    Duration duration = DateTime.now().difference(dateTime);
    double multiplier = 100 / numberDaysTotal;
    double value = (duration.inDays * multiplier) / 100;
    if (value < 0) {
      return 0;
    }
    return value > 1.0 ? 1.0 : value;
  }


  int getExpectedDuration(String date, int numberDaysTotal) {
    DateTime dateTime = DateTime.parse(date);
    Duration duration = DateTime.now().difference(dateTime);
    if (duration.inDays <= 0) {
      return 0;
    } else {
      if (duration.inDays >= numberDaysTotal) {
        return numberDaysTotal - 1;
      } else {
        return duration.inDays - 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bibleBookListData = Provider.of<BibleBookListData>(context);

    return StreamBuilder(
      stream: Rx.combineLatest5<Plan, double, bool, ReadingPlans, List<Plan>, ProgressCardData>(bibleBookListData.getUnReadBooks().asStream(), bibleBookListData.getProgressValue().asStream(), SharedPrefs().getExpectedProgress().asStream(), DatabaseHelper().queryCurrentPlan().asStream(), DatabaseHelper().allChapters().asStream(), (unreadchapter, progress, expectedProgress, currentReadingPlan, allChapters) => ProgressCardData(
        progressvalue: progress, 
        unreadchapter: unreadchapter,
        showExpected: expectedProgress,
        readingPlan: currentReadingPlan,
        allChapters: allChapters
      )),
      builder: (context, bibleBook) {

          if (bibleBook.hasData) {
            ProgressCardData progressdata = bibleBook.data;

          String longName() {
            if (textTwo == null) {
              if (progressdata.showExpected) {
                if (progressdata.unreadchapter.longName != null) {
                   return progressdata.allChapters[getExpectedDuration(progressdata.readingPlan.startDate, progressdata.readingPlan.numberDaysTotal)].longName;
                } else {
                   return progressdata.allChapters.last.longName;
                }
              } else {
                if (progressdata.unreadchapter.longName != null) {
                   return progressdata.unreadchapter.longName;
                } else {
                   return progressdata.allChapters.last.longName;
                }
              }
            } else {
              return textTwo;
            }
          }

          String chapters() {
            if (textThree == null) {
              if (progressdata.showExpected) {
                if (progressdata.unreadchapter.chapters != null) {
                   return progressdata.allChapters[getExpectedDuration(progressdata.readingPlan.startDate, progressdata.readingPlan.numberDaysTotal)].chapters;
                } else {
                   return progressdata.allChapters.last.chapters;
                }
              } else {
                if (progressdata.unreadchapter.chapters != null) {
                   return progressdata.unreadchapter.chapters;
                } else {
                   return progressdata.allChapters.last.chapters;
                }
              }
            } else {
              return textThree;
            }
          }

                return Container(
                  child: ProgressCard(
                    showExpected: progressdata.showExpected,
                    subtitle: progressdata.showExpected ?
                    'Expected' : subtitle,
                    expectedValue: getExpectedProgressValue(progressdata.readingPlan.startDate, progressdata.readingPlan.numberDaysTotal),
                    progressNumber:
                    progressdata.progressvalue != null ? progressdata.progressvalue : 1.0,
                    textOne: textOne == null ? '' : textOne,
                    textTwo: longName(),
                    textThree: chapters(),
                  ),
                  height: 110,
                );
            } else {
            return Container(
                    height: 110,
                    child: ProgressCard(
                        subtitle: 'Congrats!', 
                        progressNumber: 0.0, 
                        textOne: 'Plan is', textTwo: 'completed', 
                        textThree: '',
                      ),
                  );
                  }
                });
              }
            }

class ProgressCardData {
  final Plan unreadchapter;
  final double progressvalue;
  final bool showExpected;
  final ReadingPlans readingPlan;
  final List<Plan> allChapters;
  ProgressCardData({
    this.progressvalue, 
    this.unreadchapter, 
    this.showExpected, 
    this.readingPlan,
    this.allChapters
    });
}
