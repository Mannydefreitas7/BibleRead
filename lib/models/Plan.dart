// To parse this JSON data, do
//
//     final plan = planFromJson(jsonString);

import 'dart:convert';
import 'JwBibleBook.dart';

// List<Plan> planFromJson(String str) => List<Plan>.from(json.decode(str).map((x) => Plan.fromJson(x)));

String planToJson(List<Plan> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Plan {
    String bookName;
    int bookNumber;
    String localBookName;
    String chapters;
    int isRead;
    String chaptersData;
    int id;

    Plan({
        this.bookName,
        this.chaptersData,
        this.localBookName,
        this.bookNumber,
        this.chapters,
        this.isRead,
        this.id
    });

    factory Plan.fromJson(Map<String, dynamic> json, JwBibleBook bible) => Plan(
        bookName: bible.standardName != null ? bible.standardName : json['BookName'],
        bookNumber: json["BookNumber"],
        chapters: json['Chapters'],
        chaptersData: json['Chapters_data'],
        isRead: json["IsRead"],
        id: json['Id']
    );

    Map<String, dynamic> toJson() => {
        "bookName": bookName,
        "bookNumber": bookNumber,
        "chaptersData": chaptersData,
        "chapters": chapters,
        "isRead": isRead,
        "id": id
    };
}


