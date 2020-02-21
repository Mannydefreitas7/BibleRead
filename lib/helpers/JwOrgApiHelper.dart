import 'dart:convert';
import 'dart:io';
import 'package:BibleRead/models/JwBibleBook.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class JwOrgApiHelper {

  JwOrgApiHelper();


 Future<List<JwBibleBook>> getBibleBooks() async {
  List<JwBibleBook> list;
    String link =
          "https://www.jw.org/en/library/bible/nwt/books/json/html/";
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

      if (res.statusCode == 200) {

        dynamic data = json.decode(res.body);
        
        list = data['editionData']['books'];
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