import 'dart:convert';
import 'dart:io';
import 'package:BibleRead/classes/ChapterAudio.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/models/JwBibleBook.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class JwOrgApiHelper {
  JwOrgApiHelper();

  Future<Map<dynamic, dynamic>> getBibleBooks() async {
    Map<dynamic, dynamic> list;
    List currentBibleLocaleData =
        await DatabaseHelper().getCurrentBibleLocale();
    String jworgLocale = currentBibleLocaleData[0]['contentApi'];
    String link = "$jworgLocale";
    var res = await http.get(link, headers: {"Accept": "application/json"});

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      list = data['editionData']['books'];
    }

    return list;
  }

  Future<List<ChapterAudio>> getAudioFile(int booknumber) async {
    List currentBibleLocaleData =
        await DatabaseHelper().getCurrentBibleLocale();
    String localeAudioCode = currentBibleLocaleData[0]['audioCode'];
    Response response;

    String uri =
        'https://pubmedia.jw-api.org/GETPUBMEDIALINKS?booknum=$booknumber&output=json&pub=nwt&fileformat=MP3&alllangs=0&langwritten=$localeAudioCode&txtCMSLang=$localeAudioCode';
    List<dynamic> audioLinks;
    List<ChapterAudio> _chaptersAudio = [];
    print(uri);

    response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      audioLinks = data['files'][localeAudioCode]['MP3'];

      for (var audioLink in audioLinks) {
        _chaptersAudio.add(ChapterAudio.fromJson(audioLink));
      }
    } else if (response.statusCode == 404) {
      String uri =
          'https://pubmedia.jw-api.org/GETPUBMEDIALINKS?booknum=$booknumber&output=json&pub=bi12&fileformat=MP3&alllangs=0&langwritten=$localeAudioCode&txtCMSLang=$localeAudioCode';

      response = await http
          .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        audioLinks = data['files'][localeAudioCode]['MP3'];

        for (var audioLink in audioLinks) {
          _chaptersAudio.add(ChapterAudio.fromJson(audioLink));
        }
      } else {
        String uri =
            'https://pubmedia.jw-api.org/GETPUBMEDIALINKS?booknum=$booknumber&output=json&pub=bi12&fileformat=MP3&alllangs=0&langwritten=E&txtCMSLang=E';

        response = await http
            .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          audioLinks = data['files']['E']['MP3'];

          for (var audioLink in audioLinks) {
            _chaptersAudio.add(ChapterAudio.fromJson(audioLink));
          }
        }
      }
    }

    return _chaptersAudio;
  }

  Future<Map<dynamic, dynamic>> bibleBooks(String url) async {
    Map<dynamic, dynamic> list;

    var res = await http.get(url, headers: {"Accept": "application/json"});

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      list = data['editionData']['books'];
    }

    return list;
  }

  Future<Map<dynamic, dynamic>> getLanguages() async {
    Map<dynamic, dynamic> list;
    String link = "https://www.jw.org/en/library/bible/json/";
    var response =
        await http.get(link, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      list = data['langs'];
    }
    return list;
  }

  Future<List> getLanguagesName(String link) async {
    Map<dynamic, dynamic> langs;
    List languages = [];
    var response =
        await http.get(link, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      Map<dynamic, dynamic> data = json.decode(response.body);
      langs = data['langs'];

      langs.forEach((key, value) {
        languages.add({key: value});
      });
    }
    return languages;
  }

  Future<List<JwBibleBook>> getBibleHtmlList(List chapters) async {
    List list = [];
    List currentBibleLocaleData =
        await DatabaseHelper().getCurrentBibleLocale();
    String jworgLocale = currentBibleLocaleData[0]['contentApi'];
    for (var chapter in chapters) {
      String link = "$jworgLocale$chapter";
      var res = await http.get(link, headers: {"Accept": "application/json"});

      if (res.statusCode == 200) {
        dynamic data = json.decode(res.body);
        list.add(data['ranges'][chapter]['html']);
      }
    }

    return list;
  }

  Future<String> getBibleHtml(chaptersData) async {
    String html;
    List currentBibleLocaleData =
        await DatabaseHelper().getCurrentBibleLocale();
    String jworgLocale = currentBibleLocaleData[0]['contentApi'];

    String link = "${jworgLocale}html/$chaptersData";
    var res = await http.get(link, headers: {"Accept": "application/json"});

    if (res.statusCode == 200) {
      dynamic data = json.decode(res.body);
      html = data['ranges'][chaptersData]['html'];
    }

    return html;
  }
}
