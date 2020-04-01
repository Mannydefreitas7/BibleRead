import 'dart:convert';
import 'dart:ui';
import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/LocalJsonHelper.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/models/JwBibleBook.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:BibleRead/pages/readingplanview/NumberOfDays.dart';
import 'package:BibleRead/pages/readingplanview/PlanBibleBooks.dart';
import 'package:BibleRead/pages/readingplanview/ProgressPlanCircle.dart';
import 'package:BibleRead/pages/readingplanview/ReadingStartDate.dart';
import 'package:provider/provider.dart';

import '../../classes/datepicker/date_picker.dart';

import 'package:BibleRead/classes/textHelper.dart';
import 'package:BibleRead/helpers/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ReadingPlanView extends StatefulWidget {
  final String readingPlanTitle;
  final int planId;

  static String dateFormat(DateTime date) {
    String formattedDate = '${date.month}/${date.day}/${date.year}';
    return formattedDate;
  }

  ReadingPlanView({this.readingPlanTitle, this.planId});

  @override
  _ReadingPlanViewState createState() => _ReadingPlanViewState();
}

class _ReadingPlanViewState extends State<ReadingPlanView> {
 

  @override
  Widget build(BuildContext context) {
    final bibleBookListData = Provider.of<BibleBookListData>(context);
    return Scaffold(
        body: Stack(fit: StackFit.loose, overflow: Overflow.visible, children: <
            Widget>[
      Positioned(
          top: 0,
          child: Image(
              width: MediaQuery.of(context).size.width,
              height: 240,
              fit: BoxFit.cover,
              image:
                  AssetImage('assets/images/plan_${widget.planId}_pnr.jpg'))),
      Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      Positioned(
          right: 15,
          top: 30,
          child: IconButton(
              icon: Icon(Icons.clear, color: Colors.white, size: 25),
              onPressed: () => Navigator.of(context).pop())),
      Positioned(
          height: 180,
          width: MediaQuery.of(context).size.width - 30,
          top: 0,
          left: 15,
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PageTitleText(
                title: widget.readingPlanTitle,
                textColor: Colors.white,
              ),
            ],
          )
        ),
      Positioned(
        bottom: 0,
        child: Container(
        //  clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
          color: Theme.of(context).cardColor, 
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), 
          topRight: Radius.circular(30))),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 30, bottom: 150),
                child: Center(
                child: Column(
                  children: <Widget>[

                   ProgressPlanCircle(planId: widget.planId),
                    SizedBox(height: 20),
                   NumberOfDays(planId: widget.planId),

                    SizedBox(height: 30),
                    ReadingStartDate(planId: widget.planId,),
                    SizedBox(height: 50),

                    PlanBibleBooks(planId: widget.planId,),
                   
                    SizedBox(height: 10),
                  ],
                ),
              ),
            )),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            tileMode: TileMode.clamp,
            colors: [
                Theme.of(context).cardColor,
                Theme.of(context).cardColor,
                Theme.of(context).cardColor.withOpacity(0.7),
                Theme.of(context).cardColor.withOpacity(0.0),
            ],
          ),
        ),
        )
      ),
      Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: FlatButton(

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
            //    color: Theme.of(context).backgroundColor,
                onPressed: () {
                  bibleBookListData.selectReadingPlan(widget.planId);
                  SharedPrefs().setBookMarkFalse();
                  Navigator.popAndPushNamed(context, '/readingplans');
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Start Plan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                )),
          ))
    ]));
  }
}
