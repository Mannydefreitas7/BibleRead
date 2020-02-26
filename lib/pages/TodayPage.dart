
import 'dart:async';
import 'package:BibleRead/classes/connectivityCheck.dart';
import 'package:BibleRead/helpers/DateTimeHelpers.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/models/Plan.dart';
import '../components/listenCard.dart';
import '../components/readTodayCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../components/progressCard.dart';
import '../classes/BibleReadScaffold.dart';
import 'package:connectivity/connectivity.dart';
import '../helpers/LocalDataBase.dart';



class TodayPage extends StatefulWidget  {


  @override
  _TodayPageState createState() => _TodayPageState();
}



class _TodayPageState extends State<TodayPage> {

  Future _unReadChapters;
  Future _progressValue;

  Map _source = {ConnectivityResult.none: false};
  ConnectivityCheck _connectivity = ConnectivityCheck.instance;

  @override
void initState() { 
  super.initState();

  _unReadChapters = DatabaseHelper().unReadChapters();
  _progressValue = DatabaseHelper().countProgressValue();

  _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
}

@override
  void dispose() {
  _connectivity.disposeStream();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {

   // _unReadChapters.then((value) => print(value));

    _markTodayRead() async => {
       await DatabaseHelper().markTodayRead(),
       setState(() => {
          _unReadChapters = DatabaseHelper().unReadChapters(),
          _progressValue = DatabaseHelper().countProgressValue(),
        }),
        Navigator.of(context).pop()
    };

     bool isConnected;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        isConnected = false;
        break;
      case ConnectivityResult.mobile:
        isConnected = true;
        break;
      case ConnectivityResult.wifi:
       isConnected = true;
    }


    return BibleReadScaffold(
      title: 'Today',
      hasFloatingButton: true,
      floatingActionOnPress: () async => {
        await DatabaseHelper().markTodayRead(),
        setState(() => {
          _unReadChapters = DatabaseHelper().unReadChapters(),
          _progressValue = DatabaseHelper().countProgressValue(),
        }),
      },
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
                    builder: (BuildContext context, AsyncSnapshot snapshot) {

                      if (snapshot.hasData) {
                         List<Plan> unReadPlan = snapshot.data;
                          return ReadTodayCard(
                              markRead: _markTodayRead,
                             isDisabled: isConnected,
                             bookName: unReadPlan[0].longName,
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

          FutureBuilder(
            future: _progressValue,
            builder: (BuildContext context, AsyncSnapshot snapshot) {

            return Container(
            height: 110,
            child: ProgressCard(
                subtitle: 'Welcome!',
                progressNumber: snapshot.hasData ? snapshot.data : 0,
                textOne: DateTimeHelpers().todayWeekDay(),
                textTwo: DateTimeHelpers().todayMonth(),
                textThree: DateTimeHelpers().todayDate(),
            )
          );
        },
      ),

          
        ]
        )
    ),
    );
  }
}








