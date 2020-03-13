
import 'package:flutter/material.dart';

class ChapterAudio extends ChangeNotifier {

  ChapterAudio({
    this.title,
    this.duration,
    this.audioUrl,
    this.bibleBookNumber
    });

  String title;
  String audioUrl;
  var duration;
  int bibleBookNumber;

  factory ChapterAudio.fromJson(dynamic json) => ChapterAudio(
        title: json['title'],
        audioUrl: json['file']['url'],
        duration: json["duration"],
        bibleBookNumber: json['booknum'],
    );

}
