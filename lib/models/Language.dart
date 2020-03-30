
class Language {

  int id;
  String name;
  String vernacularName;
  String locale;
  String audioCode;
  String api;
  String contentApi;

  Language({
    this.id,
    this.api,
    this.audioCode,
    this.contentApi,
    this.locale,
    this.name,
    this.vernacularName
    });

    factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["index"],
        api: json["apie"],
        audioCode: json["audioCode"],
        contentApi: json['contentApi'],
        locale: json['locale'],
        name: json['name'],
        vernacularName: json['vernacularName']
    );


}