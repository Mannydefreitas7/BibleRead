
// List<ReadingPlans> ReadingPlansFromJson(String str) => List<ReadingPlans>.from(json.decode(str).map((x) => ReadingPlans.fromJson(x)));

// String ReadingPlansToJson(List<ReadingPlans> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
        index: json["id"],
        isRead: json["isRead"] == 0 ? false : true,
        name: json["Name"],
        startDate: json['StartDate'] == null ? DateTime.now().toString() : json['StartDate'],
        numberDaysTotal: json["NumberDaysTotal"],
    );

    Map<String, dynamic> toJson() => {
        "id": index,
        "isRead": isRead,
        "name": name,
        "startDate": startDate,
        "numberDaysTotal": numberDaysTotal,
    };
}
