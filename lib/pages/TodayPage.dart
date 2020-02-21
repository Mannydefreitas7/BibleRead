
import 'package:BibleRead/helpers/DateTimeHelpers.dart';
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
  @override
  Widget build(BuildContext context) {

    var bibleBooks = Provider.of<List<JwBibleBook>>(context);

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

                  ReadTodayCard(),

                  SizedBox(height: 20),

                  ListenCard()

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








