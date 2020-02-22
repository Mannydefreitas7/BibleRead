


class JwBibleBook {
    String chapterCount;
    String standardName;
    String standardAbbreviation;
    String officialAbbreviation;
    String standardSingularBookName;
    String standardSingularAbbreviation;
    String officialSingularAbbreviation;
    String standardPluralBookName;
    String standardPluralAbbreviation;
    String officialPluralAbbreviation;
    String bookDisplayTitle;
    String chapterDisplayTitle;
    String urlSegment;
    String url;
    bool hasAudio;
    bool hasMultimedia;
    bool hasStudyNotes;

    JwBibleBook({
        this.chapterCount,
        this.standardName,
        this.standardAbbreviation,
        this.officialAbbreviation,
        this.standardSingularBookName,
        this.standardSingularAbbreviation,
        this.officialSingularAbbreviation,
        this.standardPluralBookName,
        this.standardPluralAbbreviation,
        this.officialPluralAbbreviation,
        this.bookDisplayTitle,
        this.chapterDisplayTitle,
        this.urlSegment,
        this.url,
        this.hasAudio,
        this.hasMultimedia,
        this.hasStudyNotes,
    });

    factory JwBibleBook.fromMap(Map json) {

        json = json ?? { };
        return JwBibleBook(
        chapterCount: json["chapterCount"],
        standardName: json["standardName"],
        officialAbbreviation: json["officialAbbreviation"],
        bookDisplayTitle: json["bookDisplayTitle"],
        chapterDisplayTitle: json["chapterDisplayTitle"],
        urlSegment: json["urlSegment"],
        url: json["url"],
        hasAudio: json["hasAudio"],
        hasMultimedia: json["hasMultimedia"],
        hasStudyNotes: json["hasStudyNotes"],
    );

    }


    Map<String, dynamic> toJson() => {
        "chapterCount": chapterCount,
        "standardName": standardName,
        "standardAbbreviation": standardAbbreviation,
        "officialAbbreviation": officialAbbreviation,
        "standardSingularBookName": standardSingularBookName,
        "standardSingularAbbreviation": standardSingularAbbreviation,
        "officialSingularAbbreviation": officialSingularAbbreviation,
        "standardPluralBookName": standardPluralBookName,
        "standardPluralAbbreviation": standardPluralAbbreviation,
        "officialPluralAbbreviation": officialPluralAbbreviation,
        "bookDisplayTitle": bookDisplayTitle,
        "chapterDisplayTitle": chapterDisplayTitle,
        "urlSegment": urlSegment,
        "url": url,
        "hasAudio": hasAudio,
        "hasMultimedia": hasMultimedia,
        "hasStudyNotes": hasStudyNotes,
    };
}
