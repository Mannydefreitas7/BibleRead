import 'dart:io';
import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/JwBibleBook.dart';
import 'package:BibleRead/models/LocalBooks.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import '../models/ReadingPlan.dart';
import 'SharedPrefs.dart';


class DatabaseHelper {
  DatabaseHelper();

  Future _copyDatabase() async {
  String databasesPath = await getDatabasesPath();
  final _databaseName = "BibleRead.db";
  final _databaseVersion = 1;
  String dbPath = join(databasesPath, _databaseName);
  await deleteDatabase(dbPath);
  ByteData data = await rootBundle.load("assets/BibleRead.db");
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(dbPath).writeAsBytes(bytes);
  var database = await openDatabase(dbPath, version: _databaseVersion);
  return database;
}

Future setupDatabase() async {
//  Database _database;
  String databasesPath = await getDatabasesPath();
  final _databaseName = "BibleRead.db";
 // final _databaseVersion = 1;
  String dbPath = join(databasesPath, _databaseName);
  ByteData data = await rootBundle.load("assets/BibleRead.db");
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(dbPath).writeAsBytes(bytes);
}

  Future<Database> get database async {
    Database _database;
    final _databaseName = "BibleRead.db";
    final _databaseVersion = 1;
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, _databaseName);
    print(dbPath);
    if (dbPath != null) { 
   
      _database = await openDatabase(dbPath, version: _databaseVersion); 
  } else { 
    
     _database = await _copyDatabase(); 
  }
    return _database;
  }

  Future<List<ReadingPlans>> queryAllReadingPlans() async {
  Database db = await database;
  List<Map<String, dynamic>> _readingPlans = await db.query('readingplans');
  List<ReadingPlans> readingPlans;
  for (var plan in _readingPlans) {
    readingPlans.add(ReadingPlans.fromJson(plan));
  }
  return readingPlans;
}


Future<ReadingPlans> queryReadingPlan(int id) async {
  Database db = await database;
  List<Map<String, dynamic>> readingPlans = await db.query('readingplans', where: "index = ?", whereArgs: [id]);
  ReadingPlans readingPlan = ReadingPlans.fromJson(readingPlans[0]);
   return readingPlan;
 
}

Future<List<Map<String, dynamic>>> queryBookChapters(int planId,int id) async {
  Database db = await database;

   return await db.query('plan_$planId', where: "BookNumber = ?", whereArgs: [id]);
}

Future<List<Map<String, dynamic>>> queryBooks(int planId) async {
  Database db = await database;

   return await db.query('plan_$planId');
}

Future<List<Plan>> filterBooks() async {
  Database db = await database;
  int planId = await SharedPrefs().getSelectedPlan();
  String selectedLocale = await SharedPrefs().getSelectedLocale();
  List localeBooks = await getLocaleBooks(selectedLocale);
  List _books = await db.rawQuery('SELECT DISTINCT BookNumber FROM plan_$planId');
  List<Plan> books;
  for (var _book in _books) {
    int bookId = _book["BookNumber"];
    books.add(Plan.fromJson(_book, localeBooks[bookId]));
  }
  return books;
}

Future<void> markBookRead(int id, int planId) async {
   Database db = await database;
  return queryBookChapters(planId, id).then((data) => {
  db.rawUpdate('UPDATE plan_$planId SET IsRead = 1 WHERE BookNumber = $id')
   });
}

Future<void> markChapterRead(int id, int planId) async {
   Database db = await database;
  return queryBookChapters(planId, id).then((data) => {
  db.rawUpdate('UPDATE plan_$planId SET IsRead = 1 WHERE Id = $id')
   });
}

Future<void> markTodayRead() async {
   Database db = await database;
   int _selectedPlan = await SharedPrefs().getSelectedPlan();
   List<Plan> _allUnReadChapters = await unReadChapters();
   int _chapterID = _allUnReadChapters[0].id;
  return db.rawUpdate('UPDATE plan_$_selectedPlan SET IsRead = 1 WHERE Id = $_chapterID');
}

Future<void> markChapterUnRead(int id, int planId) async {
   Database db = await database;
  return queryBookChapters(planId, id).then((data) => {
  db.rawUpdate('UPDATE plan_$planId SET IsRead = 0 WHERE Id = $id')
   });
}

Future getLocaleBooks(String locale) async {
Database db = await database;
return db.query('$locale');
}

Future<List<Plan>> unReadChapters() async {
  int planId = await SharedPrefs().getSelectedPlan();
  String selectedLocale = await SharedPrefs().getSelectedLocale();
  List allChapters = await queryBooks(planId);
  List localeBooks = await getLocaleBooks(selectedLocale);
  List _allUnReadChapters = allChapters.where((i) => i['IsRead'] == 0).toList();
  List<Plan> unReadChapters = [];
  

   for (var chapters in _allUnReadChapters) {
    int bookId = chapters["BookNumber"];
    unReadChapters.add(Plan.fromJson(chapters, localeBooks[bookId]));
  } 
  return unReadChapters;
}


Future<void> markBookUnRead(int id, int planId) async {
   Database db = await database;
  return queryBookChapters(planId, id).then((data) => {
  db.rawUpdate('UPDATE plan_$planId SET IsRead = 0 WHERE BookNumber = $id')
   });
}

Future<void> setBookNames(String locale) async {

  Map languages = await JwOrgApiHelper().getLanguages();
  String insertSql;
  String tableName = languages['$locale']['lang']['symbol'];
  String bookNamesApiUrl = languages['$locale']['editions'][0]['contentAPI'];
  List<LocalBook> books = [];
   Database db = await database;
  Map bookNames = await JwOrgApiHelper().bibleBooks(bookNamesApiUrl);
  
  String sql = '''CREATE TABLE '$tableName' (
    shortName TEXT NOT NULL,
    longName TEXT NOT NULL,
    chapterCount TEXT NOT NULL,
    bookID INTEGER NOT NULL,
    hasAudio INTEGER
)''';
  db.execute(sql);

  for (var book in bookNames.values) {
    books.add(LocalBook.fromJson(book));
  }

  for (var i = 0; i < books.length; i++) {
    insertSql = '''
    INSERT INTO '$tableName' ('shortName', 'longName', 'chapterCount', 'bookID', 'hasAudio')  
    VALUES ('${books[i].shortName}', '${books[i].longName}', '${books[i].chapterCount}', '${i + 1}', ${books[i].hasAudio})''';

    db.execute(insertSql);
  }


}

Future<void> setLanguages(String locale) async {

  Map languages = await JwOrgApiHelper().getLanguages();
  String insertSql;
  String _locale = languages['$locale']['lang']['symbol'];
  String name = languages['$locale']['lang']['name'];
  String audioCode = languages['$locale']['lang']['langcode'];
  String vernacular = languages['$locale']['lang']['vernacularName'];
  String bookNamesApiUrl = languages['$locale']['editions'][0]['contentAPI'];
  List url = bookNamesApiUrl.split('/');
  String currentLocaleApiUrl = 'https://www.jw.org/' + url[3] + '/' + url[4] + '/' + url[5] + '/json/';
   Database db = await database;  
    insertSql = '''
    INSERT INTO 'languages' ('name', 'vernacularName', 'locale', 'audioCode', 'api', 'contentApi')  
    VALUES ('$name', '$vernacular', '$_locale', '$audioCode', '$currentLocaleApiUrl', '$bookNamesApiUrl')''';

    db.execute(insertSql);

}



Future<bool> bookIsRead(int planId, int id) async {
  final List read = [];
  final List unread = [];
  bool bookIsRead;
  return await queryBookChapters(planId, id).then((data) {

    for (var book in data) {
        if (book['IsRead'] == 1) {
          read.add(book['IsRead']);
        } else if (book['IsRead'] == 0) {
          unread.add(book['IsRead']);
        }
    }
    if (data.length == read.length) {
      bookIsRead = true;
    } else if (data.length == unread.length) {
      bookIsRead = false;
    }
      return bookIsRead;
  });

}

    List _getUnReadDays(progressData) {
      List _allDays = progressData;   
      List _isReadDays = _allDays.where((i) => i['IsRead'] == 0).toList();

      return _isReadDays;
  }


    void  _markChapterRead() {
      SharedPrefs().getSelectedPlan().then((selectedplan) {
        DatabaseHelper().queryBooks(selectedplan).then((plan) {
            final int chapterId = _getUnReadDays(plan)[0]['Id'];
          DatabaseHelper().markChapterRead(chapterId, selectedplan);
        });
      });
      
    }

Future<int> updateReadingPlanDate(int id, date) async {
  Database db = await database;
      // row to update
    final startDate = 'StartDate';
    Map<String, dynamic> row = {
      startDate : '$date',
    };
  return await db.update('readingplans', row, where: "ROWID = ?", whereArgs: [id + 1]);
}

  Future<List<Map<String, dynamic>>> queryPlan(int id) async {
  Database db = await database;

  return await db.query('plan_$id');
}

  Future<double> countProgressValue() async {
      List _allDays;
      int selectedPlan = await SharedPrefs().getSelectedPlan();
      _allDays = await queryPlan(selectedPlan);  
      List _isReadDays = _allDays.where((i) => i['IsRead'] == 1).toList();
      final expo = 100 / _allDays.toList().length;
      final double endValue = (_isReadDays.length * expo) / 100;
      return endValue;
  }

  Future<List> getUnReadDays(AsyncSnapshot progressData) async {
      List _allDays = await progressData.data;   
      List _isReadDays = _allDays.where((i) => i['IsRead'] == 0).toList();
      return _isReadDays;
  }


    Future<String> getUnReadDaysBookName(AsyncSnapshot progressData, AsyncSnapshot bibleData) async {
      List _allDays = await progressData.data;   
      List _isReadDays = _allDays.where((i) => i['IsRead'] == 0).toList();

      return await bibleData.data['${_isReadDays[0]['BookNumber']}']['standardName'];
  }


}
