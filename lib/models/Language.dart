
class Language {

  int id;
  String name;
  String vernacularName;
  String locale;
  String audioCode;
  String api;
  String contentApi;
  bool isSelected;
  String bibleTranslation;

  Language({
    this.id,
    this.api,
    this.audioCode,
    this.contentApi,
    this.locale,
    this.name,
    this.isSelected,
    this.vernacularName,
    this.bibleTranslation
    });

    factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["index"],
        api: json["api"],
        audioCode: json["audioCode"],
        contentApi: json['contentApi'],
        locale: json['locale'],
        name: json['name'],
        bibleTranslation: json['bibleTranslation'],
        vernacularName: json['vernacularName']
    );


}
