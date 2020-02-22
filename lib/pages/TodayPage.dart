
import 'package:BibleRead/helpers/DateTimeHelpers.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:provider/provider.dart';
import 'package:BibleRead/models/JwBibleBook.dart';
import '../components/listenCard.dart';
import '../components/readTodayCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../components/progressCard.dart';
import '../classes/BibleReadScaffold.dart';



class TodayPage extends StatefulWidget  {


  @override
  _TodayPageState createState() => _TodayPageState();
}



class _TodayPageState extends State<TodayPage> {

  Future _unReadChapters;

  @override
void initState() { 
  super.initState();

  _unReadChapters = DatabaseHelper().unReadChapters();
  
}

  @override
  Widget build(BuildContext context) {


    return BibleReadScaffold(
      title: 'Today',
      hasFloatingButton: true,
      selectedIndex: 0,
      bodyWidget: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Stack(children: <Widget>[

          Container(
            margin: EdgeInsets.only(top:50),
            child: ListView(
                padding: const EdgeInsets.only(top: 70),
                scrollDirection: Axis.vertical,
                children: <Widget>[

                  FutureBuilder(
                   future: _unReadChapters,
                   // initialData: _unReadChapters,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {

                      if (snapshot.hasData) {
                         List<Plan> unReadPlan = snapshot.data;
                          return ReadTodayCard(
                             bookName: unReadPlan[0].bookName,
                             chapters: unReadPlan[0].chapters,
                             chaptersData: unReadPlan[0].chaptersData,
                           ); 
                      } else {
                        return Container(
                          height: 120,
                          child: Center(
                            child: CircularProgressIndicator()),
                        );    
                      }    
                    }
                  ),
                  
                  SizedBox(height: 20),

                  ListenCard(),

                  SizedBox(height: 100),

                ]),
          ),
          Container(
            height: 110,
            child: ProgressCard(
                subtitle: 'Welcome!',
                progressNumber: 0.2,
                textOne: DateTimeHelpers().todayWeekDay(),
                textTwo: DateTimeHelpers().todayMonth(),
                textThree: DateTimeHelpers().todayDate(),
            )
          )
        ]
        )
    ),
    );
  }
}








