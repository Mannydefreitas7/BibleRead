
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
import 'package:audio_service/audio_service.dart';



class TodayPage extends StatefulWidget  {


  @override
  _TodayPageState createState() => _TodayPageState();
}



class _TodayPageState extends State<TodayPage> with WidgetsBindingObserver  {

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
  // bool isPlaying = false;
  // bool isReady = false;
  // bool isSingle = true;
  // double slider = 0.0;
  String _platformVersion = 'Unknown';
  double _sliderVolume;
  String _error;
 int currentAudio = 0;

  Future<List<ChapterAudio>> _chaptersAudio;

  AudioPlayer _player; 

  


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

// void playAudio() async {
//  await _player.play();
// }

// void pauseAudio() async {
//  await player.pause();
// }

// void stopAudio() async {
//   await player.stop();
// }

// void releaseAudio() async {
//   await player.pause();
//   await player.stop();
// }

//   void onChanged(Duration value) {
//     setState(() {
//         slider = value;
//     });
// }

// void onChangeEnd(Duration newPosition) async {
//       await player.seek(newPosition);
//       }

  @override
void initState() { 
     
  super.initState();

  _unReadChapters = DatabaseHelper().unReadChapters();
  _progressValue = DatabaseHelper().countProgressValue();
 
  _connectivity.initialise();
   WidgetsBinding.instance.addObserver(this);
    _connectivity.myStream.listen((source) {
      if (mounted) {
         setState(() => {
        _source = source,
      } );
      }
    });

    connect();
   // player = AudioPlayer();
     _player = audioPayerController.player;
  //  initialize();
     // audioPayerController.initialize();
    // if (list.length == 1) {
    //   isSingle = true;
    // } else {
    //   isSingle = false;
    // }

  //  initialize();
     // audioPayerController.initialize();
    audioPayerController.onStart();

     
}

void connect() async {
    await AudioService.connect();
  }

  void disconnect() {
    AudioService.disconnect();
  }


  // initialize() async {
  //   list = await audioPayerController.audioList;
  //    print(list[0].title);
  //   await _player.setUrl(list[audioPayerController.currentAudio + 1].url);
  // }

@override
  void dispose() {
    audioPayerController.releaseAudio();
    disconnect();
    super.dispose();
    
  }



// void next() async {
//    await _player.stop();
//      currentAudio = currentAudio + 1;
//      String url;
//      if (currentAudio < list.length) {
//           url = list[currentAudio].url;
//             await _player.setUrl(url);
//                setState(() {});
//           } else {
//             currentAudio = 0;
//             url = list[currentAudio].url;
//             await _player.setUrl(url);
//               setState(() {});
//      }
//     await _player.play();
 
// }

// void previous() async {
//    await audioPayerController.player.stop();
//      String url;
//      if (audioPayerController.currentAudio > 0) {
//           audioPayerController.currentAudio = currentAudio - 1;
//           url = audioPayerController.list[currentAudio].url;
//             await audioPayerController.player.setUrl(url);
//                setState(() {});
//           } else {
//             currentAudio = 0;
//             url = audioPayerController.list[currentAudio].url;
//             await audioPayerController.player.setUrl(url);
//               setState(() {});
//      }
//     await audioPayerController.onPlay();
 
// }

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
       // clipBehavior: Clip.hardEdge
     //   padding: EdgeInsets.only(left: 15, right: 15),
        
        child: Stack(
        //  overflow: Overflow.clip,

          children: <Widget>[
          FutureBuilder(
                   future: _unReadChapters,
                    builder: (BuildContext context, AsyncSnapshot snapshot) { 

                  if (snapshot.hasData) {
                         unReadPlan = snapshot.data;
             
                          return ListView(
                           padding: EdgeInsets.only(top: 70),
                        //    scrollDirection: Axis.vertical,

                            children: <Widget>[

                               Container(
                                 padding: EdgeInsets.only(top: 70),
                                  margin: EdgeInsets.only(left: 15, right: 15),
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
                        stream: audioPayerController.player.fullPlaybackStateStream,
                        builder:(BuildContext context, AsyncSnapshot playStateSnapshot) {
                          print(playStateSnapshot);
                          if (playStateSnapshot.hasData) {
                              return StreamBuilder(
                            stream: _player.durationStream,
                            builder: (BuildContext context, AsyncSnapshot durationSnapshot) {

                              return StreamBuilder(
                                stream: _player.getPositionStream(),
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
                                           audioPayerController.isPlaying = false;
                                      } else if (state == AudioPlaybackState.playing) {
                                          //  isReady = true;
                                           audioPayerController.isPlaying = true;
                                       } else if (state == AudioPlaybackState.completed) {

                                          audioPayerController.isPlaying = false;
                                         //  next();
                                           audioPayerController.onSkipToNext();
                                           AudioService.skipToNext();
                                        
                                      } else {
                                          audioPayerController.isPlaying = false;
                                      }
              
                                   return ListenCard(
                                        bookName: '',
                                        isAudioPlaying: audioPayerController.isPlaying,
                                        slider: slider,
                                        isSingle: audioPayerController.isSingle,
                                        next: () => audioPayerController.isSingle ? null : audioPayerController.onSkipToNext(),
                                        previous: () => audioPayerController.isSingle ? null : audioPayerController.onSkipToPrevious(),
                                        playPause: () => audioPayerController.isPlaying ? AudioService.pause() : AudioService.play(),
                                        isReady: isConnected,
                                        sliderChange: (value) => audioPayerController.onChangeEnd(value),
                                        duration: duration,
                                        position: position,
                                        durationText: _formatDuration(duration),
                                        startTime: _formatDuration(position),
                                        chapter: audioPayerController.list[audioPayerController.currentAudio].title,
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


    ));
  }
}








