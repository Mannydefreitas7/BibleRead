import 'package:BibleRead/classes/card/ReadingPlanTile.dart';
import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/service/SharedPrefs.dart';
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/views/plans/detail/PlanDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ReadingPlansList extends StatelessWidget {
  ReadingPlansList({Key key, this.readingPlans}) : super(key: key);

  final List readingPlans;

  @override
  Widget build(BuildContext context) {
    final bibleBookListData = Provider.of<BibleBookListData>(context);
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: ListView.builder(
          padding: EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 10),
          itemCount: readingPlans.toList().length,
          itemBuilder: (context, index) {
            return FutureBuilder(
                future: SharedPrefs().getSelectedPlan(),
                builder: (context, selectedPlan) {
                  int selectedPlan = bibleBookListData.selectedPlan;
                  return ReadingPlanTile(
                      selectedIndex: selectedPlan,
                      index: index,
                      planTitle: AppLocalizations.of(context).translate('plan_$index'),
                      onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              maintainState: false,
                              fullscreenDialog: true,
                              builder: (context) {
                                return ReadingPlanView(
                                    readingPlanTitle: AppLocalizations.of(context).translate('plan_$index'),
                                    planId: readingPlans[index]['index']);
                              })));
                });
          }),
    );
  }
}