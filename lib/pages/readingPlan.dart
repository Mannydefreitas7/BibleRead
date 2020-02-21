import 'dart:convert';

import 'package:BibleRead/classes/card.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/LocalJsonHelper.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:BibleRead/models/ReadingPlan.dart';
import 'package:flutter/material.dart';
import 'readingplanview/ReadingPlanView.dart';

class ReadingPlan extends StatefulWidget {
  @override
  _ReadingPlanState createState() => _ReadingPlanState();
}

class _ReadingPlanState extends State<ReadingPlan> {
  final String title = 'Reading Plans';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Stack(children: <Widget>[
        FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/json/readingPlans.json'),
            builder: (context, snapshot) {
              List _readingPlans = json.decode(snapshot.data.toString());
              //  print(snapshot);
              if (snapshot.hasData) {
                return Container(
                  margin: EdgeInsets.only(top: 50),
                  child: ListView.builder(
                      padding: EdgeInsets.only(
                          top: 70, left: 10, right: 10, bottom: 10),
                      itemCount: _readingPlans.toList().length,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                            future: SharedPrefs().getSelectedPlan(),
                            builder: (context, selectedPlan) {
                              return ReadingPlanTile(
                                  selectedIndex: selectedPlan.data,
                                  index: index,
                                  planTitle: _readingPlans[index]['name'],
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) {
                                            return ReadingPlanView(
                                                readingPlanTitle:
                                                    _readingPlans[index]
                                                        ['name'],
                                                planId: index);
                                          })));
                            });
                      }),
                );
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
    );
  }
}
