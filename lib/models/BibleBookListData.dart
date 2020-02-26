import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:flutter/material.dart';

class BibleBookListData extends ChangeNotifier {
double progressValue;
Plan unReadFirst;
List<Plan> bibleBooks;


BibleBookListData() {
  DatabaseHelper().filterBooks().then((value) => {
   // print(value),
      bibleBooks = value
  });
}

Future<double> getProgressValue() async {
  progressValue = await DatabaseHelper().countProgressValue();
  return progressValue;
}

Future<Plan> getUnReadBooks() async {
  List<Plan> unReadChapters = await DatabaseHelper().unReadChapters();
  unReadFirst = unReadChapters[0];
  return unReadFirst;
}

markBookRead(int id) {
  DatabaseHelper().markBookRead(id);
  notifyListeners();
}

markBookUnRead(int id) {
  DatabaseHelper().markBookUnRead(id);
  notifyListeners();
}

markChapterRead(int id) {
   DatabaseHelper().markChapterRead(id);
   notifyListeners();
}

markChapterUnRead(int id) {
   DatabaseHelper().markChapterUnRead(id);
   notifyListeners();
}
  

  
}
