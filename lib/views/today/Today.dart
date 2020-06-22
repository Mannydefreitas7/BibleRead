import 'dart:async';
import 'package:BibleRead/classes/audio/AudioPlayer.dart';
import 'package:BibleRead/classes/audio/AudioPlayerController.dart';
import 'package:BibleRead/classes/card/CompletedCard.dart';
import 'package:BibleRead/classes/card/progressCard.dart';
import 'package:BibleRead/classes/card/readTodayCard.dart';
import 'package:BibleRead/classes/custom/BibleReadScaffold.dart';
import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/database/LocalDataBase.dart';
import 'package:BibleRead/classes/date/DateTimeHelpers.dart';
import 'package:BibleRead/classes/network/connectivityCheck.dart';
import 'package:BibleRead/classes/notifications/Notifications.dart';
import 'package:BibleRead/classes/service/FirstLaunch.dart';
import 'package:BibleRead/classes/service/ReadingProgressData.dart';
import 'package:BibleRead/classes/service/SharedPrefs.dart';
import 'package:BibleRead/models/ChapterAudio.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:strings/strings.dart';

class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  Notifications notifications = Notifications();

  List<Plan> unReadPlan;
  int currentChapter;
  Map _source = {ConnectivityResult.none: false};
  ConnectivityCheck _connectivity = ConnectivityCheck.instance;
  List<ChapterAudio> chaptersAudio;

  bool isReady = false;
  String verses = '';
  bool isSingle = true;
  bool isCompleted = false;
  String bookmarkdata = '';
  bool hasBookmark = false;
  bool loading = false;


  ReadingProgressData _readingProgressData = ReadingProgressData();
  AudioPlayerController audioPayerController = AudioPlayerController();


 // _markTodayRead() async {

  //  await DatabaseHelper().markTodayRead();
   // await SharedPrefs().setBookMarkFalse();
    // setState(() => {
    //       hasBookmark = false
    //     });
    // await initialize();

    // bool hasReminderOn = await SharedPrefs().getReminder();

    // if (hasReminderOn) {
    //   bool isBadgesupported = await FlutterAppBadger.isAppBadgeSupported();
    //   print(isBadgesupported);
    //   if (isBadgesupported) {
    //     int badgeNumber = await SharedPrefs().getBadgeNumber();
    //     await SharedPrefs().setBadgeNumber(badgeNumber - 1);
    //     FlutterAppBadger.updateBadgeCount(badgeNumber - 1);
    //   }
    // }
 // }

  _setBookMarkFalse() async {
    await SharedPrefs().setBookMarkFalse();
    setState(() => {});
  }

  @override
  void initState() {
    super.initState();

    _connectivity.initialise();
    _readingProgressData.initialize();

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
    initialize();
  }

  initialize() async {

    hasBookmark = await SharedPrefs().getHasBookMark();
    if (hasBookmark) {
      bookmarkdata = await SharedPrefs().getBookMarkData();
      bookmarkdata = bookmarkdata.length > 0 ? SharedPrefs().parseBookMarkedVerse(bookmarkdata) : '';
      }
    }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    bool isConnected;
    ReadingProgressData readingProgressData = Provider.of<ReadingProgressData>(context);
    Notifications notifications = Provider.of<Notifications>(context);
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

    readingProgressData.getUnReadChapters().asStream().listen((event) {
        if (event.length == 0) {
          setState(() {
            isCompleted = true;
          });
        }
    });
    bool loading = false;
   // List<Plan> unReadList = [...readingProgressData.unReadList];

    return BibleReadScaffold(
      title: AppLocalizations.of(context).translate('today'),
      hasLeadingIcon: false,
      hasBottombar: true,
      isLoading: loading,
      hasFloatingButton: !isCompleted,
      floatingActionOnPress: () => {

       // unReadList[0].isRead = true;

        readingProgressData.markTodayRead(),
        notifications.setDailyAtTime(context),
         FirstLaunch().addLaunch(1),
        readingProgressData.showRatingDialog()
      },
      selectedIndex: 0,
      bodyWidget: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Stack(
              children: <Widget>[
                FutureBuilder(
                    future: readingProgressData.getUnReadChapters(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        unReadPlan = snapshot.data;
                 
                        return ListView(
                            addRepaintBoundaries: true,
                            padding: EdgeInsets.only(top: 130),
                            scrollDirection: Axis.vertical,
                            children: <Widget>[
                              if (unReadPlan.length != 0)
                                Container(
                                    child: ReadTodayCard(
                                  isDisabled: isConnected,
                                //  selectedPlan: readingProgressData.selectedPlan,  
                                  bookName: unReadPlan[0].longName,
                                  chapters: unReadPlan[0].chapters,
                                  chaptersData: unReadPlan[0].chaptersData,
                                )),
                              if (unReadPlan.length != 0) SizedBox(height: 20),
                              if (unReadPlan.length != 0)
                              BRAudioPlayer(isReady: isConnected),
                              if (unReadPlan.length == 0) CompletedCard(),
                              SizedBox(height: 100),
                            ]);
                      } else {
                        return Container(
                          height: 120,
                          child: Center(
                              child: SpinKitDoubleBounce(
                            color: Theme.of(context).accentColor,
                          )),
                        );
                      }
                    }),
                StreamBuilder(
                  stream: Rx.combineLatest3<String, String, double,
                          TodayProgressCard>(
                      DateTimeHelpers().todayMonthFuture().asStream(),
                      DateTimeHelpers().todayWeekDayFuture().asStream(),
                      DatabaseHelper().countProgressValue().asStream(),
                      (month, weekDay, progressValue) => TodayProgressCard(
                          month: month,
                          weekDay: weekDay,
                          progressValue: progressValue)),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    TodayProgressCard todayProgressCard = snapshot.hasData
                        ? snapshot.data
                        : TodayProgressCard(
                            month: DateTimeHelpers().todayMonth(),
                            weekDay: DateTimeHelpers().todayWeekDay(),
                            progressValue: 0);
                    return Container(
                        height: 110,
                        child: ProgressCard(
                          subtitle:
                              AppLocalizations.of(context).translate('welcome'),
                          showExpected: false,
                          progressNumber: todayProgressCard.progressValue > 1.0
                              ? 1.0
                              : todayProgressCard.progressValue,
                          textOne: capitalize(todayProgressCard.weekDay),
                          textTwo: capitalize(todayProgressCard.month),
                          textThree: DateTimeHelpers().todayDate(),
                        ));
                  },
                ),
              ])),
    );

  }
}

class TodayProgressCard {
  TodayProgressCard({this.month, this.progressValue, this.weekDay});

  final String month;
  final String weekDay;
  final double progressValue;
}


   