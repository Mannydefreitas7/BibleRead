import 'dart:convert';
import 'package:BibleRead/classes/card/PlanCard.dart';
import 'package:BibleRead/classes/card/ReadingPlanTile.dart';
import 'package:BibleRead/classes/custom/BibleReadScaffold.dart';
import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/service/ReadingProgressData.dart';
import 'package:BibleRead/classes/service/SharedPrefs.dart';
import 'package:BibleRead/views/plans/ReadinPlansList.dart';
import 'package:BibleRead/views/plans/detail/PlanDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Plans extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ReadingProgressData readingProgressData = Provider.of<ReadingProgressData>(context);

    return BibleReadScaffold(
        title: AppLocalizations.of(context).translate('reading_plan'),
        hasBottombar: true,
        hasLeadingIcon: false,
        hasFloatingButton: false,
        selectedIndex: 2,
        bodyWidget: 
        FutureBuilder(
          future: readingProgressData.getReadingPlan(),
          builder: (BuildContext context, AsyncSnapshot selectedPlanSnapshot) {
          return Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Stack(children: <Widget>[

            FutureBuilder(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/json/readingPlans.json'),
                    builder: (context, plansSnapshot) {
                    List plans = json.decode(plansSnapshot.data.toString());
                     return ListView.builder(
                        padding: EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 10),
                        itemCount: plansSnapshot.hasData ? plans.toList().length : 10,
                        itemBuilder: (context, index) {

                          if (plansSnapshot.hasData) {
                             List readingPlans = json.decode(plansSnapshot.data.toString());
                              return ReadingPlanTile(
                              selectedIndex: selectedPlanSnapshot.hasData ? selectedPlanSnapshot.data : 0,
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
                          } else {
                            return Shimmer.fromColors(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                              ), 
                              baseColor: Theme.of(context).cardColor, 
                              highlightColor: Theme.of(context).backgroundColor
                            );
                          }
                       }
                      ); 
                }),
            Container(
              height: 110,
              child: selectedPlanSnapshot.hasData ? PlanCard(
                subtitle: AppLocalizations.of(context).translate('reading_now'),
                textPlan: AppLocalizations.of(context).translate('plan_${selectedPlanSnapshot.data}'),
                planImage:'assets/images/plan_${selectedPlanSnapshot.data}_sqr.jpg',
              ) : Shimmer.fromColors(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ), 
                  baseColor: Theme.of(context).cardColor, 
                  highlightColor: Theme.of(context).backgroundColor
                )
              )
          ]),
        );
      })
    );
  }
}
