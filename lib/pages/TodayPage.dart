
import 'dart:async';
import 'package:BibleRead/classes/ChapterAudio.dart';
import 'package:BibleRead/classes/connectivityCheck.dart';
import 'package:BibleRead/helpers/DateTimeHelpers.dart';
import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/Plan.dart';
import '../components/listenCard.dart';
import '../components/readTodayCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../components/progressCard.dart';
import '../classes/BibleReadScaffold.dart';
import 'package:connectivity/connectivity.dart';
import '../helpers/LocalDataBase.dart';
import 'package:just_audio/just_audio.dart';




class TodayPage extends StatefulWidget  {


  @override
  _TodayPageState createState() => _TodayPageState();
}



class _TodayPageState extends State<TodayPage> {

  Future _unReadChapters;
  Future _progressValue;
  Future<List<ChapterAudio>> _chaptersAudio;
  List<Plan> unReadPlan;
List<ChapterAudio> _audios;
  Map _source = {ConnectivityResult.none: false};
  ConnectivityCheck _connectivity = ConnectivityCheck.instance;
 final player = AudioPlayer();
  @override
void initState() { 
  super.initState();

  _unReadChapters = DatabaseHelper().unReadChapters();
  _progressValue = DatabaseHelper().countProgressValue();
   _chaptersAudio = JwOrgApiHelper().getAudioFile();

 

  _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

   
    JwOrgApiHelper().getAudioFile().then((value) => {
      _audios = value,
      player.setUrl(_audios[0].audioUrl)
    });
    

  
}

@override
  void dispose() {
    super.dispose();
    
  }


 List<String> getchapters(String chapters) {
      List<String> _chapters = [];
      List<String> tempChapters = chapters.split(' ');

      for (var i = int.parse(tempChapters.first); i <= int.parse(tempChapters.last) ; i++) {
        _chapters.add(i.toString());
      }
      return _chapters;
    }

  @override
  Widget build(BuildContext context) {
    
    _markTodayRead() async => {
       await DatabaseHelper().markTodayRead(),
       await SharedPrefs().setBookMarkFalse(),
       setState(() => {
          _unReadChapters = DatabaseHelper().unReadChapters(),
          _progressValue = DatabaseHelper().countProgressValue(),
        }),
        Navigator.of(context).pop()
    };
    _setBookMarkFalse() async {
     await SharedPrefs().setBookMarkFalse();
      setState(() => {  });
    }

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
        await SharedPrefs().setBookMarkFalse(),
        setState(() => {
          _unReadChapters = DatabaseHelper().unReadChapters(),
          _progressValue = DatabaseHelper().countProgressValue(),
        }),
      },
      selectedIndex: 0,
      bodyWidget: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Stack(children: <Widget>[

          FutureBuilder(
                   future: _unReadChapters,
                    builder: (BuildContext context, AsyncSnapshot snapshot) { 
                  if (snapshot.hasData) {

                         unReadPlan = snapshot.data;
                       
                          return ListView(
                            padding: const EdgeInsets.only(top: 70),
                            scrollDirection: Axis.vertical,
                            children: <Widget>[

                               Container(
                                  margin: EdgeInsets.only(top:50),
                                  child: ReadTodayCard(
                                  markRead: _markTodayRead,
                                  removeBookMark: _setBookMarkFalse,
                                  isDisabled: isConnected,
                                  bookName: unReadPlan[0].longName,
                                  chapters: unReadPlan[0].chapters,
                                  chaptersData: unReadPlan[0].chaptersData,
                           )),
                           SizedBox(height: 20),

                            FutureBuilder(
                              
                              future: _chaptersAudio,
                              builder: (BuildContext context, AsyncSnapshot audioController) {
                                int chapterNumber = int.parse(getchapters(unReadPlan[0].chapters)[0]);
                              
                               
                                //bool isPlaying = _isPlaying > 0 ? true : false;
                                if (audioController.hasData) {

                                  List<ChapterAudio> _chapterAudio = audioController.data;
                                

                           
                                
                              Function _playAudio() {
                                  setState(() {
                                    //isPlaying = isPlaying;
                                  });
                                  player.play();
                                }

                              Function _pauseAudio() {
                                  setState(() {
                                  //  isPlaying = isPlaying;
                                  });
                                  player.pause();
                                }

                              Function _stopAudio() {
                                setState(() {
                                //    isPlaying = isPlaying;
                                  });
                                player.dispose();
                              }
                       
                                       
                                  return  ListenCard(
                              bookName: unReadPlan[0].longName,
                           //   isAudioPlaying: isPlaying,
                            //  playPause: isPlaying ? _pauseAudio : _playAudio,
                              duration: 3.7,
                              position: 1.5,
                              durationText: '3:07',
                              startTime: '0.0',
                              chapter: getchapters(unReadPlan[0].chapters)[0],
                            );
                                } else {
                                  return Container();
                                }
                                 

                        }),
                          SizedBox(height: 100),
                         ]); 
                          
                        } else {
                        return Container(
                          height: 120,
                          child: Center(
                            child: CircularProgressIndicator()),
                        );    
                      }    
                    }
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
        ])
      ),
    );
  }
}








