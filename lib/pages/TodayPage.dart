import 'dart:async';
import 'package:BibleRead/AudioPlayerController.dart';
import 'package:BibleRead/classes/ChapterAudio.dart';
import 'package:BibleRead/classes/Notifications.dart';
import 'package:BibleRead/classes/connectivityCheck.dart';
import 'package:BibleRead/components/CompletedCard.dart';
import 'package:BibleRead/helpers/DateTimeHelpers.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/helpers/app_localizations.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../components/listenCard.dart';
import '../components/readTodayCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../components/progressCard.dart';
import '../classes/BibleReadScaffold.dart';
import 'package:connectivity/connectivity.dart';
import '../helpers/LocalDataBase.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  Future<List> _unReadChapters;
  List<Plan> unReadChapters = [];
  Future _progressValue;
  Notifications notifications = Notifications();

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
  bool isCompleted = false;
  String bookmarkdata = '';
  bool hasBookmark = false;

  int currentAudio = 0;

  AudioPlayer player;

  //AudioController audioController = AudioController();

  AudioPlayerController audioPayerController = AudioPlayerController();

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
    if (player.playbackState == AudioPlaybackState.playing) {
        await player.stop();
    }

    await DatabaseHelper().markTodayRead();
    await SharedPrefs().setBookMarkFalse();
    setState(() => {
          _unReadChapters = DatabaseHelper().unReadChapters(),
          _progressValue = DatabaseHelper().countProgressValue(),
          hasBookmark = false
        });
    await initialize();
    bool isBadgesupported = await FlutterAppBadger.isAppBadgeSupported();
    bool hasReminderOn = await SharedPrefs().getReminder();

    if (isBadgesupported && hasReminderOn) {
      int badgeNumber = await SharedPrefs().getBadgeNumber();
     await SharedPrefs().setBadgeNumber(badgeNumber - 1);
      FlutterAppBadger.updateBadgeCount(badgeNumber - 1);
    }
  }

  bibleViewMarkRead() {
    _markTodayRead();
    Navigator.pop(context);
  }

  _setBookMarkFalse() async {
    await SharedPrefs().setBookMarkFalse();
    setState(() => {});
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
    if (player.playbackState == AudioPlaybackState.playing) {
        await player.pause();
        await player.stop();
        await player.dispose();
    }
   
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

    _unReadChapters.asStream().listen((event) {
       if (mounted) { 
         if (event.length > 0) 
          setState(() {
            isCompleted = false;
          });
          else 
          setState(() {
            isCompleted = true;
          });
       }
    });

       // DatabaseHelper().removeLanguage('he');
      //  DatabaseHelper().removeLocaleFromLanguage('fa');
   // DatabaseHelper().addNewLanguage('ro', 0);

    _connectivity.myStream.listen((source) {
      if (mounted) {
        setState(() => {
              _source = source,
            });
      }
    });
    player = AudioPlayer();

    initialize();

    SharedPrefs().getHasBookMark().then((value) => {hasBookmark = value});

    SharedPrefs().getBookMarkData().then((value) => {
          if (value.length > 0)
            {bookmarkdata = SharedPrefs().parseBookMarkedVerse(value)}
          else
            {bookmarkdata = ''}
        });
  }

  initialize() async {
    list = await audioPayerController.setupAudioList();
    await player.setUrl(list[currentAudio].url);
    if (list.length > 1) {
      isSingle = false;
    } else {
      isSingle = true;
    }
  }

  @override
  void dispose() {
    releaseAudio();
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
    if (player.playbackState != AudioPlaybackState.connecting) {
      await player.play();
    } else {
      await player.pause();
    }
    
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
        setState(() {});
        break;
      case ConnectivityResult.wifi:
        isConnected = true;
        setState(() {});
    }

    if (list.length > 1) {
      isSingle = false;
    } else {
      isSingle = true;
    }



    return BibleReadScaffold(
      title: AppLocalizations.of(context).translate('today'),
      hasLeadingIcon: false,
      hasBottombar: true,
      hasFloatingButton:isCompleted ? false : true,
      floatingActionOnPress: _markTodayRead,
      selectedIndex: 0,
      bodyWidget: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Stack(
          //  overflow: Overflow.clip, 
            children: <Widget>[

            FutureBuilder(
                future: _unReadChapters,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    unReadPlan = snapshot.data;

                    return ListView(
                      //  addAutomaticKeepAlives: true,
                        addRepaintBoundaries: true,
                        padding: EdgeInsets.only(top: 130),
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          if (unReadPlan.length != 0)
                            Container(
                               // margin: EdgeInsets.only(top: 50),
                                child: ReadTodayCard(
                                  markRead: _markTodayRead,
                                  removeBookMark: _setBookMarkFalse,
                                  isDisabled: isConnected,
                                  bibleViewMarkRead: bibleViewMarkRead,
                                  bookName: unReadPlan[0].longName,
                                  chapters: unReadPlan[0].chapters,
                                  chaptersData: unReadPlan[0].chaptersData,
                                )),
                          if (unReadPlan.length != 0) SizedBox(height: 20),
                          if (unReadPlan.length != 0)
                            StreamBuilder<PlayerDataStream>(
                                stream: Rx.combineLatest3<FullAudioPlaybackState, Duration, Duration, PlayerDataStream>(player.fullPlaybackStateStream,  player.getPositionStream(), player.durationStream, (fullAudioPlaybackState, position, duration) => PlayerDataStream(durationStream: duration, positionStream: position, fullAudioPlaybackState: fullAudioPlaybackState)),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {

                                  if (snapshot.hasData) {
                                      PlayerDataStream playerDataStream = snapshot.data;
                
                                                  final fullState =
                                                      playerDataStream.fullAudioPlaybackState;
                                                  final state =
                                                      fullState?.state;
                                                  final buffering =
                                                      fullState?.buffering;
                                                  Duration position =
                                                      playerDataStream.positionStream;
                                                  Duration duration =
                                                      playerDataStream.durationStream;
                                                  double slider = position
                                                          .inMilliseconds /
                                                      duration.inMilliseconds;

                                                  if (state ==
                                                          AudioPlaybackState
                                                              .connecting ||
                                                      buffering == true) {
                                                    isPlaying = false;
                                                  } else if (state ==
                                                      AudioPlaybackState
                                                          .playing) {
                                                    isPlaying = true;
                                                  } else if (state ==
                                                      AudioPlaybackState
                                                          .completed) {
                                                    isPlaying = false;
                                                    next();
                                                  } else {
                                                    isPlaying = false;
                                                  }
                                                  return ListenCard(
                                                    bookName: '',
                                                    isAudioPlaying: isPlaying,
                                                    slider: slider != null ? slider : 0.0,
                                                    isSingle: isSingle,
                                                    next: () => isSingle
                                                        ? null
                                                        : next(),
                                                    previous: () => isSingle
                                                        ? null
                                                        : previous(),
                                                    playPause: () => isPlaying
                                                        ? pauseAudio()
                                                        : playAudio(),
                                                    isReady: isConnected,
                                                    sliderChange: (value) =>
                                                        onChangeEnd(value),
                                                    duration: duration,
                                                    position: position,
                                                    durationText:
                                                        _formatDuration(
                                                            duration),
                                                    startTime: _formatDuration(
                                                        position),
                                                    chapter: list[currentAudio]
                                                        .title,
                                                  );
                                                } else {
                                                  return Container(
                                                    );
                                                }
                                              }),
                                
                          if (unReadPlan.length == 0) CompletedCard(),
                          SizedBox(height: 100),
                        ]);
                      } else {
                        return Container(
                          height: 120,
                          child: Center(
                              child:
                                  SpinKitDoubleBounce(
                            color: Theme.of(context)
                                .accentColor,
                          )),
                        );
                      }
                  }),
          
          StreamBuilder(
              stream: Rx.combineLatest3<String, String, double, TodayProgressCard>(
                DateTimeHelpers().todayMonthFuture().asStream(), 
                DateTimeHelpers().todayWeekDayFuture().asStream(), 
                DatabaseHelper().countProgressValue().asStream(), (month, weekDay, progressValue) => TodayProgressCard(
                  month: month, 
                  weekDay: weekDay, 
                  progressValue: progressValue
                )),
              builder: (BuildContext context, AsyncSnapshot snapshot) {

                TodayProgressCard todayProgressCard = snapshot.hasData ? snapshot.data : TodayProgressCard(
                  month: DateTimeHelpers().todayMonth(),
                  weekDay:  DateTimeHelpers().todayWeekDay(),
                  progressValue: 0
                  );
                return Container(
                    height: 110,
                    child: ProgressCard(
                      subtitle:  AppLocalizations.of(context).translate('welcome'),
                      showExpected: false,
                      progressNumber:
                          todayProgressCard.progressValue > 1.0 ? 1.0 : todayProgressCard.progressValue,
                      textOne:todayProgressCard.weekDay,
                      textTwo: todayProgressCard.month,
                      textThree: DateTimeHelpers().todayDate(),
                    ));
              },
            ),

          ])),
    );
  }
}


class PlayerDataStream {
  PlayerDataStream({this.durationStream, this.fullAudioPlaybackState, this.positionStream});
  FullAudioPlaybackState fullAudioPlaybackState;
  Duration positionStream;
  Duration durationStream;
}

class TodayProgressCard {

  TodayProgressCard({
    this.month,
    this.progressValue,
    this.weekDay
  });

  final String month;
  final String weekDay;
  final double progressValue;

}
