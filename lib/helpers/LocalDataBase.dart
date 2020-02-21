import 'dart:io';
import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import '../models/ReadingPlan.dart';
import '../models/ReadingPlan.dart';
import '../models/ReadingPlan.dart';



class DatabaseHelper {
  DatabaseHelper();

  Future<void> databasesPath = getDatabasesPath();

  
  static final _databaseName = "BibleRead.db";
  static final _databaseVersion = 1;
  static Database _database;

  _copyDatabase() async {
  String databasesPath = await getDatabasesPath();
  String dbPath = join(databasesPath, _databaseName);
  await deleteDatabase(dbPath);
  ByteData data = await rootBundle.load("assets/BibleRead.db");
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(dbPath).writeAsBytes(bytes);
  var database = await openDatabase(dbPath, version: _databaseVersion);
  return database;
}

  Future<Database> get database async {
    String databasesPath = await getDatabasesPath();
      String dbPath = join(databasesPath, _databaseName);
    if (dbPath != null) { 

      _database = await openDatabase(dbPath, version: _databaseVersion); 
   
  } else { _database = await _copyDatabase(); }
    return _database;
  
// _database = await _copyDatabase();
// return _database;
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

Future<List> filterBooks(int planId) async {
  Database db = await database;

  return await db.rawQuery('SELECT DISTINCT BookNumber FROM plan_$planId');
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

Future<void> markChapterUnRead(int id, int planId) async {
   Database db = await database;
  return queryBookChapters(planId, id).then((data) => {
  db.rawUpdate('UPDATE plan_$planId SET IsRead = 0 WHERE Id = $id')
   });
}


Future<void> markBookUnRead(int id, int planId) async {
   Database db = await database;
  return queryBookChapters(planId, id).then((data) => {
  db.rawUpdate('UPDATE plan_$planId SET IsRead = 0 WHERE BookNumber = $id')
   });
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

  Future<double> countProgressValue(AsyncSnapshot progressData) async {
       List _allDays;
  
          _allDays = await progressData.data;  
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
