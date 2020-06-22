
import 'dart:io';
import 'package:BibleRead/classes/service/FirstLaunch.dart';
import 'package:BibleRead/classes/service/JwOrgApiHelper.dart';
import 'package:BibleRead/classes/service/SharedPrefs.dart';
import 'package:BibleRead/models/CoreData.dart';
import 'package:BibleRead/models/Language.dart';
import 'package:BibleRead/models/LocalBooks.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:BibleRead/models/ReadingPlan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class DatabaseHelper extends ChangeNotifier {
  DatabaseHelper();

  Future copyDatabase() async {
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
  String databasesPath = await getDatabasesPath();
  final _databaseName = "BibleRead.db";
 // final _databaseVersion = 1;
  String dbPath = join(databasesPath, _databaseName);
  ByteData data = await rootBundle.load("assets/BibleRead.db");
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(dbPath).writeAsBytes(bytes);
 // await openDatabase(dbPath, version: _databaseVersion);
}

  Future<Database> get database async {
    Database _database;
    final _databaseName = "BibleRead.db";
    final _databaseVersion = 1;
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, _databaseName);
  // if (dbPath != null) { 
     _database = await openDatabase(dbPath, version: _databaseVersion); 
 // } else {  
// _database = await _copyDatabase(); 
 //}
    return _database;
  }

  Future<bool> hasPreviousData() async {
    final _databaseName = "bibleModel.sqlite";
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, _databaseName);
    bool hasPreviousData = await databaseExists(dbPath);
    return hasPreviousData;
  }

  Future<List<CoreDataObject>> getCoreDataProgress() async {
    
    List<CoreDataObject> unreadCoreDataObjects = [];
    Database coredb = await coreData;
    List chapters = await coredb.rawQuery('SELECT * FROM ZCHAPTER WHERE ZREAD = 0');
     chapters.forEach((element) {
       print(element);
      unreadCoreDataObjects.add(CoreDataObject.fromJson(element));
    });
    return unreadCoreDataObjects;
  }

Future<void> updateProgress() async {
 final _databaseName = "bibleModel.sqlite";
 String databasesPath = await getDatabasesPath();
 String dbPath = join(databasesPath, _databaseName);
 bool dbExist = await databaseExists(dbPath);
  print('checking if has coredata...');
    List<CoreDataObject> coreDataObjects = [];
    if (dbExist) {
    print('updating progress...');
    Database coredb = await coreData;
    Database db = await database;
    List chapters = await coredb.query('ZCHAPTER');
    chapters.forEach((element) {
      coreDataObjects.add(CoreDataObject.fromJson(element));
    });
    coreDataObjects.forEach((item) {
      var isRead = item.zread;
      var id = item.zPk;
      if (isRead == true) {
         db.rawUpdate('UPDATE plan_1 SET IsRead = 1 WHERE Id = $id');
      }
    });
      await SharedPrefs().setSelectedPlan(1);
  }
   FirstLaunch().setVersion520();
   notifyListeners();
}

 Future<Database> get coreData async {
    Database _database;
    final _databaseName = "bibleModel.sqlite";
    final _databaseVersion = 1;
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, _databaseName);
    print(dbPath);
     _database = await openDatabase(dbPath, version: _databaseVersion); 
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

void updateProgressDialog(BuildContext context) {
     showCupertinoDialog(
      context: context,
      builder: (context) {

        TextStyle titleStyle = TextStyle(
          color: Theme.of(context).textTheme.headline6.color,
          fontSize: 20.0,
          );

          TextStyle contentStyle = TextStyle(
          color: Theme.of(context).textTheme.headline6.color,
          fontSize: 16.0,
          );

          TextStyle resetButton = TextStyle(
          color: Theme.of(context).accentColor,
          fontSize: 16.0,
          );

          TextStyle cancelButton = TextStyle(
          color: Colors.red,
          fontSize: 16.0,
          );

        Text title = Text('Retrieve Reading Progress', style: titleStyle,);
        Text content = Text('We were able to retrieve your lost reading progress. You can decide to update it now', style: contentStyle,);
        Text reset = Text('Update Data', style: resetButton,);
        Text cancel = Text('No, it\' ok', style: cancelButton,);

        List<FlatButton> actions = [
          FlatButton(
              child: reset,
              onPressed: () {
                DatabaseHelper().updateProgress();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: cancel,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
        ];

        if (Platform.isIOS) {
          return CupertinoAlertDialog(
          title:  title,
          content: content,
          actions: actions
            );
        } else {
            return AlertDialog(
              title:  title,
              content: content,
              actions: actions
            );
        }
      }); 
  }

Future<ReadingPlans> queryReadingPlan(int id) async {
  Database db = await database;
  List<Map<String, dynamic>> readingPlans = await db.rawQuery('SELECT * FROM readingplans WHERE id = $id');
  ReadingPlans readingPlan = ReadingPlans.fromJson(readingPlans[0]);
   return readingPlan;
}

Future<ReadingPlans> queryCurrentPlan() async {
  Database db = await database;
  int id = await SharedPrefs().getSelectedPlan();
  List<Map<String, dynamic>> readingPlans = await db.rawQuery('SELECT * FROM readingplans WHERE id = $id');
 
  ReadingPlans readingPlan = ReadingPlans.fromJson(readingPlans[0]);
   print(readingPlan);
   return readingPlan;
}

Future<List<Map<String, dynamic>>> getCurrentBibleLocale() async {
  Database db = await database;
  String currentLocale = await FirstLaunch().getBibleLocale();
  List<Map<String, dynamic>> currentBibleLocaleData = await db.query('languages', where: "locale = ?", whereArgs: [currentLocale]);
  return currentBibleLocaleData;
}

Future<List<Plan>> queryBookChapters(int id) async {
    Database db = await database;
    int planId = await SharedPrefs().getSelectedPlan();
    String selectedLocale = await SharedPrefs().getSelectedLocale();
  List localeBooks = await getLocaleBooks(selectedLocale);
  List _chapters = await db.rawQuery("SELECT * FROM plan_$planId WHERE BookNumber = ?", [id]);
 
  List<Plan> chapters = [];
  for (var _chapter in _chapters) {
    chapters.add(Plan.fromJson(_chapter, localeBooks[id - 1]));
  }
   return chapters;
}

Future<List<Map<String, dynamic>>> queryChapters(int planId) async {
  Database db = await database;

   return await db.query('plan_$planId');
}
Future<List<Plan>> getAllChapters() async {
  Database db = await database;
  int planId = await SharedPrefs().getSelectedPlan();
  String selectedLocale = await SharedPrefs().getSelectedLocale();
  List localeBooks = await getLocaleBooks(selectedLocale);
  List _chapters = await db.query('plan_$planId');
  int bookId;
  List<Plan> chapters = [];
  for (var _book in _chapters) {
      bookId = _book["BookNumber"];
    chapters.add(Plan.fromJson(_book, localeBooks[bookId - 1]));
  }
  return chapters;

}

Future<List<Plan>> filterBooks() async {
  Database db = await database;
  int planId = await SharedPrefs().getSelectedPlan();
  String selectedLocale = await SharedPrefs().getSelectedLocale();
  List localeBooks = await getLocaleBooks(selectedLocale);
  List _books = await db.rawQuery("SELECT DISTINCT BookNumber, PlanNumber FROM plan_$planId");
 
  List<Plan> books = [];
  for (var _book in _books) {

    int bookId = _book["BookNumber"];
    books.add(Plan.fromJson(_book, localeBooks[bookId - 1]));
  }
  return books;
}

Future<void> markBookRead(int id) async {
   Database db = await database;
   int planId = await SharedPrefs().getSelectedPlan();
  await db.rawUpdate('UPDATE plan_$planId SET IsRead = 1 WHERE BookNumber = $id');
}

Future<void> markChapterRead(int id) async {
   Database db = await database;
   int planId = await SharedPrefs().getSelectedPlan();
  await db.rawUpdate('UPDATE plan_$planId SET IsRead = 1 WHERE Id = $id');
}

Future<void> markTodayRead() async {
   Database db = await database;
   int _selectedPlan = await SharedPrefs().getSelectedPlan();
   List<Plan> _allUnReadChapters = await unReadChapters();
   int _chapterID = _allUnReadChapters[0].id;
  return db.rawUpdate('UPDATE plan_$_selectedPlan SET IsRead = 1 WHERE Id = $_chapterID');
}

Future<void> markChapterUnRead(int id) async {
   Database db = await database;
   int planId = await SharedPrefs().getSelectedPlan();
  return queryBookChapters(id).then((data) => {
  db.rawUpdate('UPDATE plan_$planId SET IsRead = 0 WHERE Id = $id')
   });
}

Future getLocaleBooks(String locale) async {
Database db = await database;
//print(db.rawQuery("SELECT * FROM '$locale'"));
return db.rawQuery("SELECT * FROM '$locale'");
// return db.query('$locale');
}

Future<List<Plan>> unReadChapters() async {
  int planId = await SharedPrefs().getSelectedPlan();
  String selectedLocale = await SharedPrefs().getSelectedLocale();
  List allChapters = await queryChapters(planId);
  List localeBooks = await getLocaleBooks(selectedLocale);
  List _allUnReadChapters = allChapters.where((i) => i['IsRead'] == 0).toList();
  List<Plan> unReadChapters = [];

   for (var chapters in _allUnReadChapters) {
    int bookId = chapters["BookNumber"];
    unReadChapters.add(Plan.fromJson(chapters, localeBooks[bookId - 1]));
  } 
  return unReadChapters;
}

Future<List<Plan>> allChapters() async {
  int planId = await SharedPrefs().getSelectedPlan();
  String selectedLocale = await SharedPrefs().getSelectedLocale();
  List<Plan> allChapters = [];
  List _allChapters = await queryChapters(planId);
  List localeBooks = await getLocaleBooks(selectedLocale);

   for (var chapters in _allChapters) {
    int bookId = chapters["BookNumber"];
    allChapters.add(Plan.fromJson(chapters, localeBooks[bookId - 1]));
  } 
  return allChapters;
}


Future<void> markBookUnRead(int id) async {
   Database db = await database;
   int planId = await SharedPrefs().getSelectedPlan();
  return queryBookChapters(id).then((data) => {
  db.rawUpdate('UPDATE plan_$planId SET IsRead = 0 WHERE BookNumber = $id')
   });
}

Future<List<Language>> getLanguages() async {
  Database db = await database;
  List<Language> languages = [];
  List<Map<String, dynamic>> data = await db.rawQuery("SELECT * FROM languages");
  data.forEach((item) { 
    languages.add(Language.fromJson(item));
  });
  return languages;
}

Future<void> setBookNames(String locale, int edition) async {

  Map languages = await JwOrgApiHelper().getLanguages();
  String insertSql;
  String tableName = languages['$locale']['lang']['symbol'];
  String bookNamesApiUrl = languages['$locale']['editions'][edition]['contentAPI'];
  List<LocalBook> books = [];
   Database db = await database;
  Map bookNames = await JwOrgApiHelper().bibleBooks(bookNamesApiUrl);
  
  String sql = '''CREATE TABLE "$tableName" (
    shortName TEXT,
    longName TEXT,
    chapterCount TEXT,
    bookID INTEGER,
    hasAudio INTEGER
)''';
  db.execute(sql);
  for (var book in bookNames.values) {
    books.add(LocalBook.fromJson(book));
  }
  for (var i = 0; i < books.length; i++) {
    insertSql = '''
    INSERT INTO "$tableName" ('shortName', 'longName', 'chapterCount', 'bookID', 'hasAudio')  
    VALUES ('${books[i].shortName}', '${books[i].longName}', '${books[i].chapterCount}', '${i + 1}', ${books[i].hasAudio})''';

    db.execute(insertSql);
  }
}

void removeLanguage(String locale) async {
    Database db = await database;
  await db.rawQuery("DROP TABLE $locale");
}

void removeLocaleFromLanguage(String locale) async {
  Database db = await database;
  await db.rawQuery("DELETE FROM languages WHERE locale = '$locale'");
}

Future<List<ReadingPlans>> getReadingPlans() async {
  Database db = await database;
  List<ReadingPlans> readingPlans = [];
  List<Map<String, dynamic>> data = await db.rawQuery("SELECT * FROM readingplans");
  data.forEach((element) {
    readingPlans.add(ReadingPlans.fromJson(element));
  });
  return readingPlans;
}

void setReadingPlanStartDate(DateTime dateTime, int selectedPlan) async {
  Database db = await database;
  String date = dateTime.toString();
  db.rawUpdate("UPDATE readingplans SET StartDate = '$date' WHERE id = $selectedPlan");
}

Future<String> getReadingPlanStartDate(int selectedPlan) async {
  Database db = await database;
  String dateTime;
  List readingPlans = await db.rawQuery("SELECT StartDate FROM readingplans WHERE id = $selectedPlan");
  ReadingPlans readingPlan = ReadingPlans.fromJson(readingPlans[0]);
  dateTime = readingPlan.startDate;
  return dateTime;
}

Future<String> getCurrentReadingPlanDate() async {
  Database db = await database;
  String dateTime;
  int selectedPlan = await SharedPrefs().getSelectedPlan();
  List readingPlans = await db.rawQuery("SELECT StartDate FROM readingplans WHERE id = $selectedPlan");
  ReadingPlans readingPlan = ReadingPlans.fromJson(readingPlans[0]);
  dateTime = readingPlan.startDate;
  return dateTime;
}


Future<void> setLanguages(String locale, int edition) async {
  Map languages = await JwOrgApiHelper().getLanguages();
  String insertSql;
  String _locale = languages['$locale']['lang']['symbol'];
  String name = languages['$locale']['lang']['name'];
  String audioCode = languages['$locale']['lang']['langcode'];
  String vernacular = languages['$locale']['lang']['vernacularName'];
  String bookNamesApiUrl = languages['$locale']['editions'][edition]['contentAPI'];
  String bibleTranslation = languages['$locale']['editions'][edition]['title'];
  List url = bookNamesApiUrl.split('/');
  String currentLocaleApiUrl = 'https://www.jw.org/' + url[3] + '/' + url[4] + '/' + url[5] + '/json/';
   Database db = await database;  
    insertSql = '''
    INSERT INTO 'languages' ('name', 'vernacularName', 'locale', 'audioCode', 'api', 'contentApi', 'bibleTranslation')  
    VALUES ('$name', '$vernacular', '$_locale', '$audioCode', '$currentLocaleApiUrl', '$bookNamesApiUrl', '$bibleTranslation')''';
    db.execute(insertSql);
}

Future<void> setLanguagesName() async {
  Database db = await database;
  String deviceLocale = await FirstLaunch().getDeviceLocale();
  List<Language> dataLanguages = await getLanguages();
  List<Language> currentLocaleInfo = dataLanguages.where((language) => language.locale == deviceLocale).toList();
  String link = currentLocaleInfo[0].api;
  List languages = await JwOrgApiHelper().getLanguagesName(link);

    languages.forEach((language) {
      Map _language = language;
      dataLanguages.forEach((dataLanguage) {
          if (_language.keys.first == dataLanguage.locale) {
              String dataLocale = dataLanguage.locale;
               String name = _language['$dataLocale']['lang']['name'];
              db.rawUpdate("UPDATE languages SET name = '$name' WHERE locale = '$dataLocale'");
          }
       });
   });
}

void addNewLanguage(String locale, int edition) async {
  await DatabaseHelper().setLanguages(locale, edition);
  await DatabaseHelper().setBookNames(locale, edition);
}


void resetEverything() async {
Database db = await database;
for (var i = 0; i <= 12; i++) {
  await db.rawQuery("UPDATE plan_$i SET IsRead = 0");
}
}


// Future<bool> bookIsRead(int planId, int id) async {
//   final List read = [];
//   final List unread = [];
//   bool bookIsRead;
//   return await queryBookChapters(id).then((data) {

//     for (var book in data) {
//         if (book['IsRead'] == 1) {
//           read.add(book['IsRead']);
//         } else if (book['IsRead'] == 0) {
//           unread.add(book['IsRead']);
//         }
//     }
//     if (data.length == read.length) {
//       bookIsRead = true;
//     } else if (data.length == unread.length) {
//       bookIsRead = false;
//     }
//       return bookIsRead;
//   });

// }

  //   List getUnReadDays(progressData) {
  //     List _allDays = progressData;   
  //     List _isReadDays = _allDays.where((i) => i['IsRead'] == 0).toList();
  //     return _isReadDays;
  // }


    // void  _markChapterRead() {
    //   SharedPrefs().getSelectedPlan().then((selectedplan) {
    //     DatabaseHelper().queryChapters(selectedplan).then((plan) {
    //         final int chapterId = _getUnReadDays(plan)[0]['Id'];
    //       DatabaseHelper().markChapterRead(chapterId, selectedplan);
    //     });
    //   });
      
    // }


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
