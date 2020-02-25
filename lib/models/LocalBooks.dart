import 'package:flutter/material.dart';

class LocalBook {

  String shortName;
  String longName;
  String chapterCount;
  int hasAudio;
  int bookID;

  LocalBook({
    this.chapterCount,
    this.longName,
    this.bookID,
    this.shortName,
    this.hasAudio
  });

  factory LocalBook.fromJson(Map json) {
    json = json ?? { };
    return LocalBook(
      chapterCount: json['chapterCount'],
      hasAudio: json['hasAudio'] ? 1 : 0,
      longName: json['standardName'],
      shortName: json['officialAbbreviation']
    );
  }

}
