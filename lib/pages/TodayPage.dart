
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

  Future<List> _unReadChapters;
  List<Plan> unReadChapters;
  Future _progressValue;
  Future<List<ChapterAudio>> _chaptersAudio;
  List<ChapterAudio> chapterAudios;
  List<Plan> unReadPlan;
  int currentChapter;
  double position = 0.0;
  int minute;
  String currentTime = '00:00';
  String durationTime = '00:00';
  int seconds;
   Future<List<ChapterAudio>> _chapterAudios;
  Duration _position;
  Duration _duration;
  AudioPlaybackEvent playbackEvent;


List<ChapterAudio> _audios;
  Map _source = {ConnectivityResult.none: false};
  ConnectivityCheck _connectivity = ConnectivityCheck.instance;
 final player = new AudioPlayer();

  bool isPlaying = false;
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

    _initPlayer();
}
    
    Function _playAudio() {
        setState(() {
          isPlaying = true;
        });
        player.play();
      }

  Function _pauseAudio() {
      setState(() {
        isPlaying = false;
      });
      player.pause();
    }

    Function _stopAudio() {
      setState(() {
        isPlaying = false;
        });
      player.stop();

    }
 
 Future<void> _initPlayer() async {
    
    List<Plan> _unReadChapters = await DatabaseHelper().unReadChapters();
    List<ChapterAudio> _chapterAudios = await JwOrgApiHelper().getAudioFile();
    int currentChapter = int.parse(getchapters(_unReadChapters[0].chapters)[0]);
    player.getPositionStream().drain();
    player.setUrl(_chapterAudios[currentChapter].audioUrl);

      player.playbackEventStream.listen((event) {
      setState(() => playbackEvent = event);
      switch (playbackEvent.state) {
        case AudioPlaybackState.playing :
          isPlaying = true;
          break;
        case AudioPlaybackState.connecting :
        case AudioPlaybackState.none :
        case AudioPlaybackState.paused :
        case AudioPlaybackState.stopped :
            isPlaying = false;
          break;
        default:
          isPlaying = false;
      }
    });
    var _duration = await player.durationFuture;
    var qualifier = 100 / (_duration.inSeconds / 60);

    durationTime = _printDuration(await player.durationFuture);

    player.getPositionStream().listen((event) {
 
      setState(() => _position = event);
      
      position = (((_position.inSeconds / 60) * qualifier) / 100);
     //print(((_position.inSeconds / 60) * qualifier) / 100);
      currentTime = _printDuration(_position);

    });
}

@override
  void dispose() {
    super.dispose();
    player.stop();
    player.dispose();
  }



 List<String> getchapters(String chapters) {
      List<String> _chapters = [];
      List<String> tempChapters = chapters.split(' ');

      for (var i = int.parse(tempChapters.first); i <= int.parse(tempChapters.last) ; i++) {
        _chapters.add(i.toString());
      }
      return _chapters;
    }

    String _printDuration(Duration duration) {
        String twoDigits(int n) {
          if (n >= 10) return "$n";
          return "0$n";
        }

        String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
        String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
        return "$twoDigitMinutes:$twoDigitSeconds";
      }

         
    _markTodayRead() async => {
      await player.stop(),
      await player.dispose(),

      await DatabaseHelper().markTodayRead(),
      await SharedPrefs().setBookMarkFalse(),
      unReadChapters = await DatabaseHelper().unReadChapters(),
      chapterAudios = await JwOrgApiHelper().getAudioFile(),
       setState(() => {
    
          _unReadChapters = DatabaseHelper().unReadChapters(),
          _progressValue = DatabaseHelper().countProgressValue(),
           _initPlayer()
        }),
      
    };

        _setBookMarkFalse() async {
     await SharedPrefs().setBookMarkFalse();
      setState(() => {  });
    }

  @override
  Widget build(BuildContext context) {
 

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

      await  _markTodayRead(),
        await  _setBookMarkFalse(),
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
         
                                if (audioController.hasData) {

                                  List<ChapterAudio> _chapterAudio = audioController.data;
                                

                              return  ListenCard(
                              bookName: unReadPlan[0].longName,
                              isAudioPlaying: isPlaying,
                              playPause: isPlaying ? _pauseAudio : _playAudio,
                              duration: position,
                              position: 1.5,
                              durationText: durationTime,
                              startTime: currentTime,
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








