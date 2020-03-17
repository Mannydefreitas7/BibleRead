import 'dart:convert';
import 'dart:io';
import 'package:BibleRead/classes/ChapterAudio.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/models/JwBibleBook.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class JwOrgApiHelper {

  JwOrgApiHelper();


 Future<Map<dynamic, dynamic>> getBibleBooks() async {
  Map<dynamic, dynamic> list;
    String link =
          "https://www.jw.org/en/library/bible/nwt/books/json/html/";
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

      if (res.statusCode == 200) {

        var data = json.decode(res.body);
        list = data['editionData']['books'];
      }

    return list;
  }


  Future<List<ChapterAudio>> getAudioFile(int booknumber) async  {
     // List<Plan> _unreadChapters = await DatabaseHelper().unReadChapters();
     // int bookNumber = _unreadChapters[0].bookNumber;
     
      String uri = 'https://pubmedia.jw-api.org/GETPUBMEDIALINKS?booknum=$booknumber&output=json&pub=nwt&fileformat=MP3&alllangs=0&langwritten=E&txtCMSLang=E';
      List<dynamic> audioLinks;
      List<ChapterAudio> _chaptersAudio = [];
      

      var res = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});

      if (res.statusCode == 200) {

        var data = json.decode(res.body);
        audioLinks = data['files']['E']['MP3'];

        for (var audioLink in audioLinks) {
          
          _chaptersAudio.add(ChapterAudio.fromJson(audioLink));
        }
      }

        if (_chaptersAudio.isEmpty) {
          
           String uri = 'https://pubmedia.jw-api.org/GETPUBMEDIALINKS?booknum=$booknumber&output=json&pub=bi12&fileformat=MP3&alllangs=0&langwritten=E&txtCMSLang=E';

           var res = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});

         if (res.statusCode == 200) {

        var data = json.decode(res.body);
        audioLinks = data['files']['E']['MP3'];

        for (var audioLink in audioLinks) {
          
          _chaptersAudio.add(ChapterAudio.fromJson(audioLink));
        }
      }
          
      }

      return _chaptersAudio;
  }

  Future<Map<dynamic, dynamic>> bibleBooks(String url) async {
  Map<dynamic, dynamic> list;
    String link = url;
    
    var res = await http
        .get(url, headers: {"Accept": "application/json"});

      if (res.statusCode == 200) {

        var data = json.decode(res.body);
        list = data['editionData']['books'];
      }

    

    return list;
  }

  Future<Map<dynamic, dynamic>> getLanguages() async {

    Map<dynamic, dynamic> list;
     String link =
          "https://www.jw.org/en/library/bible/json/";
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {

        var data = json.decode(response.body);
        list = data['langs'];

      }

  return list;

  }

   Future<List<JwBibleBook>> getBibleHtmlList(List chapters) async {
    List list = [];

     for (var chapter in chapters) {
        String link =
          "https://www.jw.org/en/library/bible/nwt/books/json/html/$chapter";
      var res = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

      if (res.statusCode == 200) {
        dynamic data = json.decode(res.body);
        list.add(data['ranges'][chapter]['html']);
      }

     }

    return list;
  }

   Future<String> getBibleHtml(chaptersData) async {
    String html;

        String link =
          "https://www.jw.org/en/library/bible/nwt/books/json/html/$chaptersData";
      var res = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

      if (res.statusCode == 200) {
        dynamic data = json.decode(res.body);
        html = data['ranges'][chaptersData]['html'];
      }

    return html;
  }


}
