
import 'dart:async';
import 'package:BibleRead/AudioPlayerController.dart';
import 'package:BibleRead/classes/AudioController.dart';
import 'package:BibleRead/classes/AudioServiceController.dart';
import 'package:BibleRead/classes/ChapterAudio.dart';
import 'package:BibleRead/classes/connectivityCheck.dart';
import 'package:BibleRead/helpers/DateTimeHelpers.dart';
import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../components/listenCard.dart';
import '../components/readTodayCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../components/progressCard.dart';
import '../classes/BibleReadScaffold.dart';
import 'package:connectivity/connectivity.dart';
import '../helpers/LocalDataBase.dart';
import 'package:audio_service/audio_service.dart';


class TodayPage extends StatefulWidget  {

  @override
  _TodayPageState createState() => _TodayPageState();
}



class _TodayPageState extends State<TodayPage>  {

  Future<List> _unReadChapters;
  List<Plan> unReadChapters;
  Future _progressValue;
  BackgroundAudioTask audioTask;

  List<Plan> unReadPlan;
  int currentChapter;
  Map _source = {ConnectivityResult.none: false};
  ConnectivityCheck _connectivity = ConnectivityCheck.instance;
    List<ChapterAudio> chaptersAudio;
   List<AudioPlayerItem> list = [];
AudioPlayerController  audioPayerController = AudioPlayerController();

 int currentAudio = 0;



   String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }

  _markTodayRead() async {
  AudioService.stop();
  await DatabaseHelper().markTodayRead();
  await SharedPrefs().setBookMarkFalse();
  unReadChapters = await DatabaseHelper().unReadChapters();
  setState(() => { 
      _unReadChapters = DatabaseHelper().unReadChapters(),
      _progressValue = DatabaseHelper().countProgressValue(),

    });
    await audioPayerController.initialize();

}

  _setBookMarkFalse() async {
await SharedPrefs().setBookMarkFalse();
setState(() => {  });
}  


  @override
void initState() { 
     
  super.initState();

  _unReadChapters = DatabaseHelper().unReadChapters();
  _progressValue = DatabaseHelper().countProgressValue();
 
  _connectivity.initialise();
   
    _connectivity.myStream.listen((source) {
      if (mounted) {
        setState(() => {
        _source = source
      } );
      }
    });

     connect();
    

}



void connect() async {
 await AudioService.connect();
  }

  void disconnect() async {
  await AudioService.disconnect();
  }





@override
  void dispose() {
    disconnect();
    super.dispose();
    
  }



  @override
  Widget build(BuildContext context) {
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);
     bool isConnected;

    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        isConnected = false;
        break;
      case ConnectivityResult.mobile:
        isConnected = true;
        setState(() {
        });
        break;
      case ConnectivityResult.wifi:
       isConnected = true;
         setState(() { });
    }


    return WillPopScope(
        onWillPop: () {
         disconnect();
         return Future.value(true);
        },
        child:BibleReadScaffold(
      title: 'Today',      
      hasFloatingButton: true,
      floatingActionOnPress: () => _markTodayRead(),
      selectedIndex: 0,
      bodyWidget: Container(
        child: Stack(
          children: <Widget>[
          FutureBuilder(
                   future: _unReadChapters,
                    builder: (BuildContext context, AsyncSnapshot snapshot) { 

                  if (snapshot.hasData) {
                         unReadPlan = snapshot.data;
             
                          return ListView(

                           padding: EdgeInsets.only(left: 15, right: 15, top: 70),
                            scrollDirection: Axis.vertical,

                            children: <Widget>[

                               Container(
                               //  padding: EdgeInsets.only(left: 15, right: 15),
                                  margin: EdgeInsets.only(top: 50),
                                  child: ReadTodayCard(
                                  markRead: _markTodayRead,
                                  removeBookMark: _setBookMarkFalse,
                                  isDisabled: isConnected,
                                  bookName: unReadPlan[0].longName,
                                  chapters: unReadPlan[0].chapters,
                                  chaptersData: unReadPlan[0].chaptersData,
                           )),

                          SizedBox(height: 20),
                          WillPopScope(
                          onWillPop: () {
                              disconnect();
                              return Future.value(true);
                            },
                           child: ListenCard(isReady: isConnected,)),
                                         
                        SizedBox(height: 100),
                            ]);
                  } else {
                    return Container();
                  }
                }),

                    

          FutureBuilder(
            future: _progressValue,
            builder: (BuildContext context, AsyncSnapshot snapshot) {

            return Container(
            height: 110,
            padding: EdgeInsets.only(left: 15, right: 15),
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
        ])
      ),


    ));
  }
}




