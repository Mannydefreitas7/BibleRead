import 'dart:async';
import 'dart:convert';

import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/pages/progressview/BibleBookCard.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class BibleBookList extends StatefulWidget {
  BibleBookList({Key key, this.duration, this.notifyProgress}) : super(key: key);
  final Function notifyProgress;
  final Duration duration;
  @override
  _BibleBookListState createState() => _BibleBookListState();
}

class _BibleBookListState extends State<BibleBookList>
    with SingleTickerProviderStateMixin {
//AnimationController _controller;




@override
void initState() {
super.initState();

}

@override
void dispose() {
  super.dispose();
}

  _markRead(int id, int planId) {
    return DatabaseHelper().markBookRead(id, planId);
  }

  _markUnRead(int id, int planId) {
    return DatabaseHelper().markBookUnRead(id, planId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: JwOrgApiHelper().getBibleBooks(),
    builder: (context, bible) {
    return FutureBuilder(
    future: SharedPrefs().getSelectedPlan(),
    builder: (context, selectedPlan) {
    return FutureBuilder(
    future: DatabaseHelper().filterBooks(selectedPlan.data)
                        ,
    builder: (context, planData) {
      if (bible.hasData && selectedPlan.hasData &&
        planData.hasData) {
         final List plan = planData.data;

         return ListView.builder(
          
        padding: const EdgeInsets.only(
        top: 70, left: 20, right: 20),
        scrollDirection: Axis.vertical,
        itemCount: plan.length,
        itemBuilder: (context, index) {
        return Container(
         margin: EdgeInsets.only(bottom: 10),
         child: BibleBookCard(
           notifyProgress: widget.notifyProgress,
          bookLongName: bible.data['${plan[index]['BookNumber']}']['standardName'],
          bookShortName: bible.data['${plan[index]['BookNumber']}']['officialAbbreviation'],
          selectedPlan: selectedPlan.data,
          bookId: plan[index]['BookNumber'],
         )
       );
    });
  } else {
    return Center(child: CircularProgressIndicator());
  }
       });
     });
  });
  }
}
