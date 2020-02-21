import 'dart:convert';
import 'package:BibleRead/classes/card.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:flutter/material.dart';
import './readingplanview/ReadinPlansList.dart';
import '../classes/BibleReadScaffold.dart';

class ReadingPlanPage extends StatelessWidget {

  @override  
  Widget build(BuildContext context) {
    return BibleReadScaffold(
      title: 'Reading Plans',
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
                return ReadingPlansList(readingPlans: _readingPlans,);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        Container(
          child: FutureBuilder(
              initialData: 0,
              future: SharedPrefs().getSelectedPlan(),
              builder: (context, selectedPlan) {
                if (selectedPlan.data == null) {
                  return PlanCard(
                    subtitle: 'Reading Now',
                    textPlan: 'Regular',
                    planImage: 'assets/images/plan_0_sqr.jpg',
                  );
                } else {
                  return FutureBuilder(
                      future: DefaultAssetBundle.of(context)
                          .loadString('assets/json/readingPlans.json'),
                      builder: (context, plans) {
                        if (plans.data == null) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          final planData = json.decode(plans.data);
                          return PlanCard(
                            subtitle: 'Reading Now',
                            textPlan: planData[selectedPlan.data]['name'],
                            planImage:
                                'assets/images/plan_${selectedPlan.data}_sqr.jpg',
                          );
                        }
                      });
                }
              }),
          height: 110,
        )
      ]),
    )
  );
}
}
