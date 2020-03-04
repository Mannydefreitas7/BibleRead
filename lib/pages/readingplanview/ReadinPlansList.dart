import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/card.dart';
import '../../helpers/SharedPrefs.dart';
import 'ReadingPlanView.dart';

class ReadingPlansList extends StatelessWidget {
  ReadingPlansList({Key key, this.readingPlans}) : super(key: key);

  final List readingPlans;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: ListView.builder(
          padding: EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 10),
          itemCount: readingPlans.toList().length,
          itemBuilder: (context, index) {
            return FutureBuilder(
                future: SharedPrefs().getSelectedPlan(),
                builder: (context, selectedPlan) {
                  return ReadingPlanTile(
                      selectedIndex: selectedPlan.data,
                      index: index,
                      planTitle: readingPlans[index]['name'],
                      onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              maintainState: false,
                              fullscreenDialog: true,
                              builder: (context) {
                                return ReadingPlanView(
                                    readingPlanTitle: readingPlans[index]
                                        ['name'],
                                    planId: index);
                              })));
                });
          }),
    );
  }
}
