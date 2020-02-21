

// To parse this JSON data, do
//
//     final ReadingPlans = ReadingPlansFromJson(jsonString);

import 'dart:convert';

List<ReadingPlans> ReadingPlansFromJson(String str) => List<ReadingPlans>.from(json.decode(str).map((x) => ReadingPlans.fromJson(x)));

String ReadingPlansToJson(List<ReadingPlans> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReadingPlans {
    int index;
    bool isRead;
    String name;
    String startDate;
    int numberDaysTotal;

    ReadingPlans({
        this.index,
        this.isRead,
        this.name,
        this.startDate,
        this.numberDaysTotal,
    });

    factory ReadingPlans.fromJson(Map<String, dynamic> json) => ReadingPlans(
        index: json["index"],
        isRead: json["isRead"],
        name: json["name"],
        startDate: json['StartDate'],
        numberDaysTotal: json["numberDaysTotal"],
    );

    Map<String, dynamic> toJson() => {
        "index": index,
        "isRead": isRead,
        "name": name,
        "startDate": startDate,
        "numberDaysTotal": numberDaysTotal,
    };
}
