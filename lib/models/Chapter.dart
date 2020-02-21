class Chapter {
    String chapters;
    String data;
    bool isRead;

    Chapter({
        this.chapters,
        this.data,
        this.isRead,
    });

    factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        chapters: json["chapters"],
        data: json["data"],
        isRead: json["isRead"],
    );

    Map<String, dynamic> toJson() => {
        "chapters": chapters,
        "data": data,
        "isRead": isRead,
    };
}