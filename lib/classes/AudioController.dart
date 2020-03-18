// import 'dart:async';

// import 'package:BibleRead/classes/ChapterAudio.dart';
// import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
// import 'package:BibleRead/helpers/LocalDataBase.dart';
// import 'package:BibleRead/models/Plan.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class AudioController {

//   List<ChapterAudio> chaptersAudio;
//   List<ChapterAudio> list = [];

//   bool isPlaying = false;
//   bool isReady = false;
//   double slider = 0.0;
//   String _platformVersion = 'Unknown';
//   double _sliderVolume;
//   String _error;
//   num curIndex = 0;

//   Future<List<ChapterAudio>> _chaptersAudio;

//   int currentChapter;
//   AudioPlayerItem audioPlayerItem;
//   StreamController<AudioPlayerItem> audioStreamController = new StreamController();
//   Stream<AudioPlayerItem> get audiostream => audioStreamController.stream;

// AudioController();


// Future<List<ChapterAudio>> chapterAudioList() async {
//   List<Plan> _unReadChapters = await DatabaseHelper().unReadChapters();
//   List<ChapterAudio> audios = await JwOrgApiHelper().getAudioFile(_unReadChapters[0].bookNumber);
//   return audios;
// }

// Future<String> audioUrl() async {
//   List<Plan> _unReadChapters = await DatabaseHelper().unReadChapters();
//   chaptersAudio = await JwOrgApiHelper().getAudioFile(_unReadChapters[0].bookNumber);
//   currentChapter = int.parse(getchapters(_unReadChapters[0].chapters)[0]);
//   String url = chaptersAudio[currentChapter].audioUrl;
//   return url;
// }

// List<String> getchapters(String chapters) {
//   List<String> _chapters = [];
//   List<String> tempChapters = chapters.split(' ');
//   for (var i = int.parse(tempChapters.first); i <= int.parse(tempChapters.last) ; i++) {
//     _chapters.add(i.toString());
//   }
//   return _chapters;
// }


//    String formatDuration(Duration d) {
//     if (d == null) return "--:--";
//     int minute = d.inMinutes;
//     int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
//     String format = ((minute < 10) ? "0$minute" : "$minute") +
//         ":" +
//         ((second < 10) ? "0$second" : "$second");
//     return format;
//   }

//   Future<List<AudioInfo>> setupAudioList() async {
//     List<Plan> _unReadChapters = await DatabaseHelper().unReadChapters();
//     int bookNumber = _unReadChapters[0].bookNumber;
//     String bookName = _unReadChapters[0].longName;
//     List<ChapterAudio> audios = await JwOrgApiHelper().getAudioFile(bookNumber);
//     List chapters = getchapters(_unReadChapters[0].chapters);
//     List<AudioInfo> _audioInfos = [];
//     audios.removeAt(0);
//     audios.forEach((item) => {
//       chapters.forEach((chapter) {
//         if (item.title.split(' ')[1] == chapter) {
//       _audioInfos.add(AudioInfo(
//         item.audioUrl,
//         title: '$bookName - ${item.title}', 
//         desc: 'Playing from Bible Read',
//         coverUrl: 'https://assetsnffrgf-a.akamaihd.net/assets/m/1001061103/univ/art/1001061103_univ_sqs_lg.jpg')
//         );
//         }
//       })
//     });
//     return _audioInfos;
//   }
//     void sliderChange(double value) {
//     slider = value;
//     audioStreamController.sink.add(
//       AudioPlayerItem(slider: slider));
// }

//     Future<void> setupAudio() async {
    
//     _list = await setupAudioList();
//     AudioManager.instance.audioList = _list;
//     AudioManager.instance.intercepter = true;
//     AudioManager.instance.play();
//     position = AudioManager.instance.position;
//     duration = AudioManager.instance.duration;
//     slider = 0.0;
//     isPlaying = AudioManager.instance.isPlaying;

//   }

 

//    Future<void> initPlatformState() async {
//     String platformVersion;
//     try {
//       platformVersion = await AudioManager.instance.platformVersion;
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }
//       _platformVersion = platformVersion;
//   }
// }


// class AudioPlayerItem {

//   final Duration position;
//   final Duration duration;
//   final double slider;
//   final bool isPlaying;

//   AudioPlayerItem({
//     this.isPlaying,
//     this.position,
//     this.duration,
//     this.slider
//   });
  
// }

