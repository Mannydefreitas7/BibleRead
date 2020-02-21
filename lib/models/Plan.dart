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
    String chapters;
    int isRead;
    int id;

    Plan({
        this.bookName,
        this.bookNumber,
        this.chapters,
        this.isRead,
        this.id
    });

    factory Plan.fromJson(Map<String, dynamic> json, JwBibleBook bible) => Plan(
        bookName: bible.standardName,
        bookNumber: json["BookNumber"],
        chapters: json['Chapters'],
        isRead: json["IsRead"],
        id: json['Id']
    );

    Map<String, dynamic> toJson() => {
        "bookName": bookName,
        "bookNumber": bookNumber,
        "chapters": chapters,
        "isRead": isRead,
        "id": id
    };
}


