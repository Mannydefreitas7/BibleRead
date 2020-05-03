// import '../data/user.dart';
// import '../pages/chapters.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../data/preferences.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import '../data/readingProgress.dart';



//   FirebaseDatabase db = FirebaseDatabase.instance;
//   var bibleRef =
//       FirebaseDatabase.instance.reference().child('languages/en/bible_book');
//   final userRef = FirebaseDatabase.instance
//       .reference()
//       .child('users/BvE3IKiyrJTfgMSk4EammFl5Brl1');


//   Map userData = {};
//   List bibleData = [];
//   List bibleReadData = [];
//   List allChapters = [];
//   bool bookRead = false;

//   Future<void> getUserData() async {
//     await for (var data in userRef.onValue) {
//       if (data.snapshot.value != null) {
//         userData = await data.snapshot.value;
//       }
//     }
//     return userData;
//   }


//   Future<void> getBibleData() async {
//     await for (var data in bibleRef.onValue) {
//       if (data.snapshot.value != null) {
//         bibleData = await data.snapshot.value;
//         bibleData = bibleData.toList();
//         bibleData.removeAt(0);
//       }
//     }
//     return bibleData;
//   }

//   Future<void> getUserBibleData() async {
//     await for (var data in userRef.child('readingProgress/bibleBook').onValue) {
//       if (data.snapshot.value != null) {
//         bibleReadData = await data.snapshot.value;
//         // setState(() {
//         //   bibleReadData = bibleReadData.toList();
//         // });
//         bibleReadData.removeAt(0);
//       }
//     }
//     return bibleReadData;
//   }

//   bool bookIsRead(int index) {
//     if (bibleReadData[index]['isRead']) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<void> updateBookRead(bool bookRead, int index) async {
//    await  userRef
//         .child('readingProgress/bibleBook')
//         .child('${index + 1}')
//         .update({
//       'isRead': bookRead,
//     });
//   }