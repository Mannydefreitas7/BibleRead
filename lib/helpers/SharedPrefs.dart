import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs();

  Future<void> setSelectedPlan(int planId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedPlan', planId);
  } 

  Future<void> setBookMarkData(String bookMarkData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('bookmark', bookMarkData);
  } 

    Future<bool> setBookMarkTrue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('hasBookmark', true);
  } 

      Future<bool> getHasBookMark() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasBookmark');
  } 

   Future<String> getSelectedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bibleLocale');
  }


      Future<String> getBookMarkData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bookmark');
  } 

      Future<void> setBookMarkFalse() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('bookmark', '');
    return prefs.setBool('hasBookmark', false);
  } 

  Future<int> getSelectedPlan() async {
    final prefs = await SharedPreferences.getInstance();
    int selectedPlan = prefs.getInt('selectedPlan');
    return selectedPlan;
  } 

    bool showFloatingButton(int pageIndex) {
    switch (pageIndex) {
      case 0: 
      return true;
      case 1:
      return false;
      case 2:
      return false;
      case 3:
      return false;
        break;
      default:
      return false;
    }
  }

  String parseBookMarkedVerse(String verse) {
    String chapter;
    String verses;

  if (verse.length == 7) {
        chapter = verse.substring(1, 4);
        verses = verse.substring(4, 7);
  } else if (verse.length == 8) {
        chapter = verse.substring(2, 5);
        verses = verse.substring(5, 8);
  }


    if (chapter.split('0').length == 3) {

      if (chapter.split('0')[0].isEmpty) {
        chapter = '${chapter.split('0')[1]} ${chapter.split('0')[2]}';
      } else if  (chapter.split('0')[1].isEmpty) {
         chapter = '${chapter.split('0')[0]} ${chapter.split('0')[2]}';
      } else if  (chapter.split('0')[2].isEmpty) {
          chapter = '${chapter.split('0')[0]} ${chapter.split('0')[1]}';
      }

    } else if (chapter.split('0').length == 2) {


      if (chapter.split('0')[0].isEmpty) {
        chapter = '${chapter.split('0')[1]}';
      } else if  (chapter.split('0')[1].isEmpty) {
         chapter = '${chapter.split('0')[0]}${chapter.split('0')[1]}0';
      } 

    } else if (chapter.split('0').length == 1) {
      chapter = chapter.split('0')[0];
    }

    if (verses.split('0').length == 3) {

        if (verses.split('0')[0].isEmpty && verses.split('0')[2].isNotEmpty) {
            verses = '${verses.split('0')[1]} ${verses.split('0')[2]}';
          } else if  (verses.split('0')[1].isEmpty) {
            verses = '${verses.split('0')[0]} ${verses.split('0')[2]}';
          } else if  (verses.split('0')[0].isEmpty && verses.split('0')[2].isEmpty) {
          verses = '${verses.split('0')[1]}0';
          } else if  (verses.split('0')[2].isEmpty) {
              verses = '${verses.split('0')[0]} ${verses.split('0')[1]}';
          }


    } else if (verses.split('0').length == 2) {

    
    if (verses.split('0')[0].isEmpty) {
        verses = '${verses.split('0')[1]}';
       } else if  (verses.split('0')[0].isEmpty && verses.split('0')[2].isEmpty) {
          verses = '${verses.split('0')[1]}0';
      } else if  (verses.split('0')[1].isEmpty) {
         verses = '${verses.split('0')[0]}${verses.split('0')[1]}0';
      } 


    } else if (verses.split('0').length == 1) {

      verses = verses.split('0')[0];
     
    }

    return '$chapter:$verses';
  }

}

