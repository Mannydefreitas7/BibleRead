
import 'dart:async';
import 'package:BibleRead/AudioPlayerController.dart';
import 'package:BibleRead/classes/AudioController.dart';
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

  Future<List> _unReadChapters;
  List<Plan> unReadChapters;
  Future _progressValue;

  List<Plan> unReadPlan;
  int currentChapter;
  Map _source = {ConnectivityResult.none: false};
  ConnectivityCheck _connectivity = ConnectivityCheck.instance;
    List<ChapterAudio> chaptersAudio;
   List<AudioPlayerItem> list = [];

  bool isPlaying = false;
  bool isReady = false;
  double slider = 0.0;
  String _platformVersion = 'Unknown';
  double _sliderVolume;
  String _error;
 int currentAudio = 0;

  Future<List<ChapterAudio>> _chaptersAudio;

  AudioPlayer player;

  //AudioController audioController = AudioController();

  AudioPlayerController  audioPayerController = AudioPlayerController();


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
  //  AudioManager.instance.stop(); 
  await DatabaseHelper().markTodayRead();
  await SharedPrefs().setBookMarkFalse();
  unReadChapters = await DatabaseHelper().unReadChapters();
  
  setState(() => { 
      _unReadChapters = DatabaseHelper().unReadChapters(),
      _progressValue = DatabaseHelper().countProgressValue(),
  //  setAudio()
    });
}

  _setBookMarkFalse() async {
await SharedPrefs().setBookMarkFalse();
setState(() => {  });
}  

// void playPause() async {
//   await AudioManager.instance.playOrPause();
// } 

// void setAudio() async {

//      _list = await audioController.setupAudioList();
//    AudioManager.instance.audioList = _list;
//     AudioManager.instance.intercepter = true;
//     AudioManager.instance.start(_list[0].url, _list[0].title);
//     setState(() => { 
//       _unReadChapters = DatabaseHelper().unReadChapters(),
//       _progressValue = DatabaseHelper().countProgressValue(),
//     });
// }

void playAudio() async {
 await player.play();
}

void pauseAudio() async {
 await player.pause();
}

void stopAudio() async {
  await player.stop();
}

void releaseAudio() async {
  await player.pause();
  await player.dispose();
}

  void sliderChange(double value) {
    setState(() {
        audioPayerController.slider = value;
    });
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
        _source = source,
      } );
      }
    });
    player = AudioPlayer();
    initialize();

}


  initialize() async {
    list = await audioPayerController.setupAudioList();
    await player.setUrl(list[currentAudio].url);
  }

@override
  void dispose() {
    super.dispose();
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
        setState(() {
           
        });
        break;
      case ConnectivityResult.wifi:
       isConnected = true;
         setState(() {
    
          });
    }

    // AudioManager.instance.onEvents((events, args) {
        
    //   switch (events) {
        
    //     case AudioManagerEvents.start:
    //       AudioManager.instance.play();
    //       position = AudioManager.instance.position;
    //       duration = AudioManager.instance.duration;
    //       slider = 0;
    //       isPlaying = false;
    //       isReady = true;
    //       setState(() {});

    //       break;
    //     case AudioManagerEvents.ready:
    //     AudioManager.instance.play();
    //       _sliderVolume = AudioManager.instance.volume;
    //       position = AudioManager.instance.position;
    //       duration = AudioManager.instance.duration;
  
    //        AudioManager.instance.seekTo(Duration(seconds: 0));
    //      setState(() {});
    //       break;
    //     case AudioManagerEvents.seekComplete:
    //       position = AudioManager.instance.position;
    //       slider = position.inMilliseconds / duration.inMilliseconds;
    //   setState(() {});
    //       break;
    //     case AudioManagerEvents.buffering:

    //       break;
    //     case AudioManagerEvents.playstatus:
    //       isPlaying = AudioManager.instance.isPlaying;
    //   setState(() {});
    //       break;
    //     case AudioManagerEvents.timeupdate:
    //       position = AudioManager.instance.position;
    //       slider = position.inMilliseconds / duration.inMilliseconds;
    //   setState(() {});
    //       break;
    //     case AudioManagerEvents.error:
    //       _error = args;
    //   setState(() {});
    //       break;
    //     case AudioManagerEvents.ended:
    //       AudioManager.instance.next();
    //   setState(() {});
    //       break;
    //     case AudioManagerEvents.volumeChange:
    //       _sliderVolume = AudioManager.instance.volume;
    //   setState(() {});
    //       break;
    //     default:
    //     return;
    //       break;
    //   }
     
    // });

 

    return BibleReadScaffold(
      title: 'Today',      
      hasFloatingButton: true,
      floatingActionOnPress: () => _markTodayRead(),
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
                          
                               StreamBuilder<FullAudioPlaybackState>(
                        stream: player.fullPlaybackStateStream,
                        builder:(BuildContext context, AsyncSnapshot playStateSnapshot) {
                          if (playStateSnapshot.hasData) {
                              return StreamBuilder(
                            stream: player.durationStream,
                            builder: (BuildContext context, AsyncSnapshot durationSnapshot) {

                              return StreamBuilder(
                                stream: player.getPositionStream(),
                                builder: (BuildContext context, AsyncSnapshot positionSnapshot) {

                                  if (durationSnapshot.hasData && positionSnapshot.hasData) {
                                      final fullState = playStateSnapshot.data;
                                      final state = fullState?.state;
                                      final buffering = fullState?.buffering;
                                      Duration position = positionSnapshot.data;
                                      Duration duration = durationSnapshot.data;
                                      double slider = position.inMilliseconds / duration.inMilliseconds;

                                      if (state == AudioPlaybackState.connecting ||
                                          buffering == true) {
                                           // isReady = false;
                                            isPlaying = false;
                                      } else if (state == AudioPlaybackState.playing) {
                                          //  isReady = true;
                                            isPlaying = true;
                                      } else {
                                          isPlaying = false;
                                      }
              
                                   return ListenCard(
                                        bookName: unReadPlan[0].longName,
                                        isAudioPlaying: isPlaying,
                                        slider: slider,
                                        playPause: () => isPlaying ? pauseAudio() : playAudio(),
                                        isReady: isConnected,
                                        sliderChange: (value) => sliderChange(value),
                                        duration: duration,
                                        durationText: _formatDuration(duration),
                                        startTime: _formatDuration(position),
                                        chapter: unReadPlan[0].chapters,
                                      );
                                  } else {
                                      return Container(
                                    height: 120,
                                    child: Center(
                                    child: CircularProgressIndicator()),
                               );
                                }
                                });
                              });
                          } else {
                            return Container();
                          }
                      
                        }),
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








