import 'package:BibleRead/classes/database/LocalDataBase.dart';
import 'package:BibleRead/classes/service/JwOrgApiHelper.dart';
import 'package:BibleRead/classes/service/SharedPrefs.dart';
import 'package:BibleRead/models/ChapterAudio.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';

class ReadingProgressData extends ChangeNotifier {

  List<Plan> unReadChapters;
  List<Plan> allChapters;
  int bookNumber;
  String bookName;
  List<ChapterAudio> audios;
  List<String> chapters;
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

  void getAllChapters() async {
      this.allChapters = await DatabaseHelper().allChapters();
  } 


  void getUnReadChapters() async {
    this.unReadChapters = await DatabaseHelper().unReadChapters();
  } 

markChapterRead() {

}

void initialize() async {
    this.unReadChapters = await DatabaseHelper().unReadChapters();
    this.allChapters = await DatabaseHelper().allChapters();
    this.audioInfos = await this.setupAudioList();
    print(AudioManager.instance.isPlaying);
    if (AudioManager.instance.isPlaying == false || AudioManager.instance.audioList.length != 0) {
          AudioManager.instance.audioList = this.audioInfos;
          AudioManager.instance.intercepter = true;
          AudioManager.instance.play(auto: false);
    }

}


}