
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:flutter/material.dart';

class BookmarkData extends ChangeNotifier {

  String bookMarkData;
  bool hasBookMark;
  String formattedData;

  Future<String> get _bookMarkData => SharedPrefs().getBookMarkData();
  Future<bool> get _hasBookmarkData =>  SharedPrefs().getHasBookMark();

  BookmarkData() {
      SharedPrefs().getBookMarkData().then((value) => bookMarkData = value);
      SharedPrefs().getHasBookMark().then((value) => hasBookMark = value);
       formattedData = SharedPrefs().parseBookMarkedVerse(bookMarkData);
  }


  Future removeBookMark() async { 
    await SharedPrefs().setBookMarkFalse();
    notifyListeners();
  }


  Future setBookMark(String data) async {
    await SharedPrefs().setBookMarkData(data);
    notifyListeners();
  } 

  

}
