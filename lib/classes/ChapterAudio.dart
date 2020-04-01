
import 'package:flutter/material.dart';

class ChapterAudio extends ChangeNotifier {

  ChapterAudio({
    this.title,
    this.duration,
    this.audioUrl,
    this.bibleBookNumber,
    this.bibleChapterNumber
    });

  String title;
  String audioUrl;
  var duration;
  int bibleChapterNumber;
  int bibleBookNumber;

  factory ChapterAudio.fromJson(dynamic json) => ChapterAudio(
        title: json['title'],
        audioUrl: json['file']['url'],
        duration: json["duration"],
        bibleChapterNumber: json['track'],
        bibleBookNumber: json['booknum'],
    );

}
