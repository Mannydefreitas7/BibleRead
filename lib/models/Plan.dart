// To parse this JSON data, do
//
//     final plan = planFromJson(jsonString);

import 'dart:convert';
import 'JwBibleBook.dart';

// List<Plan> planFromJson(String str) => List<Plan>.from(json.decode(str).map((x) => Plan.fromJson(x)));

String planToJson(List<Plan> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Plan {
    int bookNumber;
    String longName;
    String chapters;
    int isRead;
    bool hasAudio;
    String shortName;
    String chaptersData;
    int id;
    int planId;

    Plan({
        this.shortName,
        this.hasAudio,
        this.chaptersData,
        this.longName,
        this.bookNumber,
        this.chapters,
        this.isRead,
        this.planId,
        this.id
    });

    factory Plan.fromJson(Map<String, dynamic> json, Map<String, dynamic> data) => Plan(
        longName: data['longName'],
        shortName: data['shortName'],
        planId: json['PlanNumber'],
        hasAudio: data['hasAudio'] == 1 ? true : false,
        bookNumber: json["BookNumber"],
        chapters: json['Chapters'],
        chaptersData: json['Chapters_data'],
        isRead: json["IsRead"],
        id: json['Id']
    );

    Map<String, dynamic> toJson() => {
        "longName": longName,
        "bookNumber": bookNumber,
        "chaptersData": chaptersData,
        "chapters": chapters,
        "isRead": isRead,
        "id": id
    };
}


