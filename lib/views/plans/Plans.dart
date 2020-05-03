import 'dart:convert';
import 'package:BibleRead/classes/card/PlanCard.dart';
import 'package:BibleRead/classes/custom/BibleReadScaffold.dart';
import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/service/SharedPrefs.dart';
import 'package:BibleRead/views/plans/ReadinPlansList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Plans extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BibleReadScaffold(
        title: AppLocalizations.of(context).translate('reading_plan'),
        hasBottombar: true,
        hasLeadingIcon: false,
        hasFloatingButton: false,
        selectedIndex: 2,
        bodyWidget: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Stack(children: <Widget>[
            FutureBuilder(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/json/readingPlans.json'),
                builder: (context, snapshot) {
                  List _readingPlans = json.decode(snapshot.data.toString());

                  if (snapshot.hasData) {
                    return ReadingPlansList(
                      readingPlans: _readingPlans,
                    );
                  } else {
                    return Center(
                        child: SpinKitDoubleBounce(
                      color: Theme.of(context).accentColor,
                    ));
                  }
                }),
            Container(
              child: StreamBuilder(
                  initialData: 0,
                  stream: SharedPrefs().getSelectedPlan().asStream(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    int selectedPlan = snapshot.hasData ? snapshot.data : 0;
                    return FutureBuilder(
                        future: DefaultAssetBundle.of(context)
                            .loadString('assets/json/readingPlans.json'),
                        builder: (context, plans) {
                          if (plans.data == null) {
                            return Center(
                                child: SpinKitDoubleBounce(
                              color: Theme.of(context).accentColor,
                            ));
                          } else {
                            return PlanCard(
                              subtitle: AppLocalizations.of(context).translate('reading_now'),
                              textPlan: AppLocalizations.of(context).translate('plan_$selectedPlan'),
                              planImage:
                                  'assets/images/plan_${selectedPlan}_sqr.jpg',
                            );
                          }
                        });
                  }),
              height: 110,
            )
          ]),
        ));
  }
}
