import 'dart:async';

import 'package:BibleRead/classes/database/LocalDataBase.dart';
import 'package:BibleRead/classes/service/FirstLaunch.dart';
import 'package:BibleRead/classes/service/JwOrgApiHelper.dart';
import 'package:BibleRead/classes/service/SharedPrefs.dart';
import 'package:BibleRead/models/ChapterAudio.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:rxdart/rxdart.dart';

class ReadingProgressData extends ChangeNotifier {

  List<Plan> unReadChapters;
  List<Plan> unReadList = [];
  List<Plan> allChapters;
  int bookNumber;
  int selectedPlan;
  String bookName;
  List<ChapterAudio> audios;
  List<String> chapters;
  bool loading = false;
  List<AudioInfo> audioInfos = [];


  List<String> getchapters(String chapters) {
    List<String> _chapters = [];
    List<String> tempChapters = chapters.split(' ');
    for (var i = int.parse(tempChapters.first); i <= int.parse(tempChapters.last) ; i++) {
      _chapters.add(i.toString());
    }
  return _chapters;
}

Future<List<AudioInfo>> setupAudioList() async {
    List<AudioInfo> _audioInfos = [];
    this.bookNumber = this.unReadChapters.length > 0 ? this.unReadChapters[0].bookNumber : 1;
    this.bookName = this.unReadChapters.length > 0 ? this.unReadChapters[0].longName : 'Genesis';
    var selectedPlan = await SharedPrefs().getSelectedPlan();
    this.audios = await JwOrgApiHelper().getAudioFile(bookNumber);
    this.chapters = getchapters(this.unReadChapters.length > 0 ? this.unReadChapters[0].chapters : '1');
    audios.forEach((item) => {
      chapters.forEach((chapter) {

        if ('${item.bibleChapterNumber}' == chapter) {
            _audioInfos.add(
              AudioInfo(item.audioUrl,
              title: '${item.title}', 
              desc: '$bookName',
              coverUrl: 'assets/images/plan_${selectedPlan}_sqr.jpg')
        );
      }
    })
  });
  return _audioInfos;
}


Stream<ReadCardData> readTodayCardData = Rx.combineLatest2<List<Plan>, int, ReadCardData>(DatabaseHelper().unReadChapters().asStream(), SharedPrefs().getSelectedPlan().asStream(), (plans, currenPlan) => ReadCardData(currentPlan: currenPlan, plans: plans));

  Future<List<Plan>> getAllChapters() async {
      this.allChapters = await DatabaseHelper().allChapters();
      return this.allChapters;
  } 


  Future<List<Plan>> getUnReadChapters() async {
    this.unReadChapters = await DatabaseHelper().unReadChapters();
    return this.unReadChapters;
  } 

Future<void> markTodayRead() async {
    await DatabaseHelper().markTodayRead();
  
   //  this.unReadChapters = await DatabaseHelper().unReadChapters();
    notifyListeners();
    this.audioInfos = await this.setupAudioList();
    await SharedPrefs().setBookMarkFalse();
    AudioManager.instance.stop();
    AudioManager.instance.audioList = this.audioInfos;
    await AudioManager.instance.play(index:0, auto: false);
    notifyListeners();
}

showRatingDialog() async {
  int launches = await FirstLaunch().launches();
  print(launches);
  bool hasRated = await FirstLaunch().hasRated();
  print(hasRated);
  if (!hasRated || hasRated == null) {
     switch (launches) {
    case 7:
    case 14:
    case 28:
    case 56:
    case 64:
    LaunchReview.launch(iOSAppId: '1472187500', androidAppId: 'com.wolinweb.BibleRead', writeReview: false);
    print('rating dialog');
      break;
    default:
  }
  }
}

removeBookMark() {
    SharedPrefs().setBookMarkFalse();
    notifyListeners();
}

setReadingPlan(int planid) async {
  await SharedPrefs().setSelectedPlan(planid);
  notifyListeners();
}

Future<int> getReadingPlan() async {
  int selectedPlan = await SharedPrefs().getSelectedPlan();
  return selectedPlan;
}


void initialize() async {
    this.unReadChapters = await DatabaseHelper().unReadChapters();
    this.allChapters = await DatabaseHelper().allChapters();
    //  DatabaseHelper().unReadChapters().then((value) => {
    //   this.unReadList = [...value]
    // });
    this.audioInfos = await this.setupAudioList();
    
    if (AudioManager.instance.isPlaying == false || AudioManager.instance.audioList.length != 0) {
          AudioManager.instance.audioList = this.audioInfos;
          AudioManager.instance.intercepter = true;
         await AudioManager.instance.play(auto: false);
    }
  }
}

class ReadCardData {
  ReadCardData({this.currentPlan, this.plans});
  final List<Plan> plans;
  final int currentPlan;
}
