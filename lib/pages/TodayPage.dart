
import 'dart:async';
import 'package:BibleRead/classes/ChapterAudio.dart';
import 'package:BibleRead/classes/connectivityCheck.dart';
import 'package:BibleRead/helpers/DateTimeHelpers.dart';
import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:flutter/services.dart';
import '../components/listenCard.dart';
import '../components/readTodayCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../components/progressCard.dart';
import '../classes/BibleReadScaffold.dart';
import 'package:connectivity/connectivity.dart';
import '../helpers/LocalDataBase.dart';
import 'package:audio_manager/audio_manager.dart';



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
  Duration _position;
    Duration _duration;
  Map _source = {ConnectivityResult.none: false};
  ConnectivityCheck _connectivity = ConnectivityCheck.instance;

  List<ChapterAudio> chaptersAudio;
  List<ChapterAudio> list = [];
  List<AudioInfo> _list = [];
  bool isPlaying = false;
  bool isReady = false;
  double _slider;
  String _platformVersion = 'Unknown';
  double _sliderVolume;
  String _error;
  num curIndex = 0;
  PlayMode playMode = AudioManager.instance.playMode;
  Future<List<ChapterAudio>> _chaptersAudio;





Future<List<ChapterAudio>> chapterAudioList() async {
  List<Plan> _unReadChapters = await DatabaseHelper().unReadChapters();
  List<ChapterAudio> audios = await JwOrgApiHelper().getAudioFile(_unReadChapters[0].bookNumber);
  return audios;
}

Future<String> audioUrl() async {
  List<Plan> _unReadChapters = await DatabaseHelper().unReadChapters();
  chaptersAudio = await JwOrgApiHelper().getAudioFile(_unReadChapters[0].bookNumber);
  currentChapter = int.parse(getchapters(_unReadChapters[0].chapters)[0]);
  String url = chaptersAudio[currentChapter].audioUrl;
  return url;
}

List<String> getchapters(String chapters) {
  List<String> _chapters = [];
  List<String> tempChapters = chapters.split(' ');
  for (var i = int.parse(tempChapters.first); i <= int.parse(tempChapters.last) ; i++) {
    _chapters.add(i.toString());
  }
  return _chapters;
}


   String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }

  Future<List<AudioInfo>> setupAudioList() async {
    List<Plan> _unReadChapters = await DatabaseHelper().unReadChapters();
    int bookNumber = _unReadChapters[0].bookNumber;
    String bookName = _unReadChapters[0].longName;
    List<ChapterAudio> audios = await JwOrgApiHelper().getAudioFile(bookNumber);
    List chapters = getchapters(_unReadChapters[0].chapters);
    List<AudioInfo> _audioInfos = [];
    audios.removeAt(0);
    audios.forEach((item) => {
      chapters.forEach((chapter) {
        if (item.title.split(' ')[1] == chapter) {
      _audioInfos.add(AudioInfo(
        item.audioUrl,
        title: '$bookName - ${item.title}', 
        desc: 'Playing from Bible Read',
        coverUrl: '')
        );
        }
      })
    });
    return _audioInfos;
  }



  void setupAudio() async {
    _list = await setupAudioList();
  //  AudioManager.instance.
    AudioManager.instance.audioList = _list;
    AudioManager.instance.intercepter = true;
    AudioManager.instance.play(auto: false);
    audioPlayBackEvent();
  }

  void audioPlayBackEvent() {
      AudioManager.instance.onEvents((events, args) {
      switch (events) {
        case AudioManagerEvents.start:
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          _slider = 0;
          isPlaying = false;
            isReady = true;
          setState(() {});
          break;
        case AudioManagerEvents.ready:

          _sliderVolume = AudioManager.instance.volume;
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          setState(() {});
          AudioManager.instance.seekTo(Duration(seconds: 0));
          break;
        case AudioManagerEvents.seekComplete:
          _position = AudioManager.instance.position;
          _slider = _position.inMilliseconds / _duration.inMilliseconds;
          setState(() { });

          break;
        case AudioManagerEvents.buffering:
        setState(() {
      
        });
       
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = AudioManager.instance.isPlaying;
          setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          _position = AudioManager.instance.position;
          _slider = _position.inMilliseconds / _duration.inMilliseconds;
          setState(() {});
         // AudioManager.instance.updateLrc(args["position"].toString());
          break;
        case AudioManagerEvents.error:
          _error = args;
          setState(() {  });
        //  AudioManager.instance.stop();
          break;
        case AudioManagerEvents.ended:
          AudioManager.instance.next();
          break;
        case AudioManagerEvents.volumeChange:
          _sliderVolume = AudioManager.instance.volume;
          setState(() {});
          break;
        default:
          break;
      }
    });
  }

  _markTodayRead() async {
    AudioManager.instance.stop(); 
  await DatabaseHelper().markTodayRead();
  await SharedPrefs().setBookMarkFalse();
  unReadChapters = await DatabaseHelper().unReadChapters();
  
  setState(() => { 
      _unReadChapters = DatabaseHelper().unReadChapters(),
      _progressValue = DatabaseHelper().countProgressValue(),
     setupAudio()
    });
    
  
}

  _setBookMarkFalse() async {
await SharedPrefs().setBookMarkFalse();
setState(() => {  });
}  

void playOrPause() async {
  await AudioManager.instance.playOrPause();
}

void sliderChange(double value) {
  setState(() {
     _slider = value;
  });
}

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await AudioManager.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
void initState() { 
  super.initState();

  _unReadChapters = DatabaseHelper().unReadChapters();
  _progressValue = DatabaseHelper().countProgressValue();
  _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

   initPlatformState();
    setupAudio();
}

@override
  void dispose() {
    AudioManager.instance.stop();
    super.dispose();
  }
   


  @override
  Widget build(BuildContext context) {

    print(AudioManager.instance.audioList);


     
     bool isConnected;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        isConnected = false;
        break;
      case ConnectivityResult.mobile:
        isConnected = true;
        setState(() {
          audioPlayBackEvent();
        });
        break;
      case ConnectivityResult.wifi:
      setState(() {
        audioPlayBackEvent();
      });
       isConnected = true;
    }


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
                          ListenCard(
                              bookName: unReadPlan[0].longName,
                              isAudioPlaying: isPlaying,
                             // playPause: () => playOrPause(),
                              slider: _slider,
                              isReady: isConnected,
                              sliderChange: (value) => sliderChange(value),
                              duration: _duration,
                              durationText: _formatDuration(_duration),
                              startTime: _formatDuration(_position),
                              chapter: unReadPlan[0].chapters,
                        ),
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








