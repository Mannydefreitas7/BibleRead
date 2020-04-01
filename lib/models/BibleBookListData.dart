import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:BibleRead/models/ReadingPlan.dart';
import 'package:flutter/material.dart';

class BibleBookListData extends ChangeNotifier {
double progressValue;
Plan unReadFirst;
List<Plan> bibleBooks = [];
//bool isBookRead = false;
List<Plan> list = [];
List<Plan> bookchapters = [];
List<Plan> chapters = [];
List<ReadingPlans> readingPlans = [];
int selectedPlan;

BibleBookListData() {
  DatabaseHelper().filterBooks().then((value) => {
      bibleBooks = value,
  });
  DatabaseHelper().getAllChapters().then((value) => list = value);  
  SharedPrefs().getSelectedPlan().then((value) => selectedPlan = value);
}

// To read only
Future<List<Plan>> get books => DatabaseHelper().filterBooks();

Future<List<Plan>> getChapters(int id) async {
  List<Plan> bookChapters = await DatabaseHelper().queryBookChapters(id);
  return bookChapters;
}

List<Plan> getBookChapters(int id) {
List<Plan> chapters = list.where((chapter) => chapter.bookNumber == id).toList();
return chapters;
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




Future<bool> checkBookIsRead(int index) async {
  bookchapters = await getChapters(index);
  List<Plan> unreadChapters = bookchapters.where((item) => item.isRead == false).toList();
  if (unreadChapters.length == 0) {
    return true;
  } else {
    return false;
  }
 } 

markBookRead(int id) {
  bookchapters = list.where((chapter) => chapter.bookNumber == id).toList();
  bookchapters.forEach((chapter) { 
    chapter.isRead = true;
  });
//  isBookRead = true;
  notifyListeners();
  DatabaseHelper().markBookRead(id);

}

  selectReadingPlan(int id) async {
    selectedPlan = id; 
    await SharedPrefs().setSelectedPlan(selectedPlan);
    list = await DatabaseHelper().getAllChapters(); 

    notifyListeners();
  }

markBookUnRead(int id) {
  
  bookchapters = list.where((chapter) => chapter.bookNumber == id).toList();
  bookchapters.forEach((chapter) { 
    chapter.isRead = false;
  });
 // isBookRead = true;
   notifyListeners();
  DatabaseHelper().markBookUnRead(id);
 
}

markChapterRead(int id, List<Plan> chapters, int index) {
  chapters[index].isRead = true;
   DatabaseHelper().markChapterRead(id);
   notifyListeners();
}

markChapterUnRead(int id, List<Plan> chapters, int index) {

  chapters[index].isRead = false;
   DatabaseHelper().markChapterUnRead(id);
   notifyListeners();
}
  
}
