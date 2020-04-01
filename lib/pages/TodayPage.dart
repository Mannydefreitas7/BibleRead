
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
import 'package:flutter_spinkit/flutter_spinkit.dart';




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
  String verses = '';
  bool isSingle = true;
  double slider = 0.0;
  String _platformVersion = 'Unknown';
  double _sliderVolume;
  String _error;
  String bookmarkdata = '';
 bool hasBookmark = false;

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
  player.stop();
  await DatabaseHelper().markTodayRead();
  await SharedPrefs().setBookMarkFalse();

  unReadChapters = await DatabaseHelper().unReadChapters();
  setState(() => { 
      _unReadChapters = DatabaseHelper().unReadChapters(),
      _progressValue = DatabaseHelper().countProgressValue(),
      hasBookmark = false
    });
    await initialize();
    
}

bibleViewMarkRead() {
  _markTodayRead();
  Navigator.pop(context);
}

  _setBookMarkFalse() async {
await SharedPrefs().setBookMarkFalse();
setState(() => {  });
}  

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
  await player.stop();
}

  void onChanged(double value) {
    setState(() {
        slider = value;
    });
}

void onChangeEnd(Duration newPosition) async {
      await player.seek(newPosition);
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

    if (list.length == 1) {
      isSingle = true;
    } else {
      isSingle = false;
    }

       SharedPrefs().getHasBookMark().then((value) => {
            hasBookmark = value
          });

       SharedPrefs().getBookMarkData().then((value) => {
            if (value.length > 0) {
              bookmarkdata = SharedPrefs().parseBookMarkedVerse(value)
            } else {
              bookmarkdata = ''
            }
          });

         DatabaseHelper().getLanguages().then((value) => print(value[0].name));

}


  initialize() async {
    list = await audioPayerController.setupAudioList();
    await player.setUrl(list[currentAudio].url);
   
  }

@override
  void dispose() {
   // releaseAudio();
    super.dispose();
    
  }

void next() async {
   await player.stop();
     currentAudio = currentAudio + 1;
     String url;
     if (currentAudio < list.length) {
          url = list[currentAudio].url;
            await player.setUrl(url);
               setState(() {});
          } else {
            currentAudio = 0;
            url = list[currentAudio].url;
            await player.setUrl(url);
              setState(() {});
     }
    await player.play();
}

void previous() async {
   await player.stop();
     String url;
     if (currentAudio > 0) {
          currentAudio = currentAudio - 1;
          url = list[currentAudio].url;
            await player.setUrl(url);
               setState(() {});
          } else {
            currentAudio = 0;
            url = list[currentAudio].url;
            await player.setUrl(url);
              setState(() {});
     }
  //  await player.play();
 
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
         setState(() { });
    }

    return BibleReadScaffold(
      title: 'Today', 
      hasLeadingIcon: false,
      hasBottombar: true,     
      hasFloatingButton: true,
      floatingActionOnPress: _markTodayRead,
      selectedIndex: 0,
      bodyWidget: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Stack(
          overflow: Overflow.clip,
          children: <Widget>[
          FutureBuilder(
                   future: _unReadChapters,
                    builder: (BuildContext context, AsyncSnapshot snapshot) { 
                  if (snapshot.hasData) {
                         unReadPlan = snapshot.data;
                          
                            String lastChapter() {
                              if (unReadPlan[0].chapters.contains('-') == true) {
                                return ' - ${unReadPlan[0].chapters.split('-')[1]}';
                              } else {
                              return '';
                              }
                            }
             
                          return ListView(
                            addAutomaticKeepAlives: true,
                            padding: const EdgeInsets.only(top: 70),
                            
                            scrollDirection: Axis.vertical,
                            children: <Widget>[

                               Container(
                                  margin: EdgeInsets.only(top:50),
                                  child: ReadTodayCard(
                                  markRead: _markTodayRead,
                                  removeBookMark: _setBookMarkFalse,
                                  isDisabled: isConnected,
                                  bibleViewMarkRead: bibleViewMarkRead,
                                  bookName: unReadPlan[0].longName,
                                  chapters: hasBookmark ? '$bookmarkdata${lastChapter()}' : unReadPlan[0].chapters,
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
                                            isPlaying = false;
                                      } else if (state == AudioPlaybackState.playing) {
                                            isPlaying = true;
                                       } else if (state == AudioPlaybackState.completed) {
                                           isPlaying = false;
                                           next();
                                      } else {
                                          isPlaying = false;
                                      }
              
                                   return ListenCard(
                                        bookName: '',
                                        isAudioPlaying: isPlaying,
                                        slider: slider,
                                        isSingle: isSingle,
                                        next: () => isSingle ? null : next(),
                                        previous: () => isSingle ? null : previous(),
                                        playPause: () => isPlaying ? pauseAudio() : playAudio(),
                                        isReady: isConnected,
                                        sliderChange: (value) => onChangeEnd(value),
                                        duration: duration,
                                        position: position,
                                        durationText: _formatDuration(duration),
                                        startTime: _formatDuration(position),
                                        chapter: list[currentAudio].title,
                                      );
                                  } else {
                                      return Container(
                                    height: 120,
                                    child: Center(
                                    child: SpinKitDoubleBounce(
                                      color: Theme.of(context).accentColor,
                                    )
                                    ),
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








