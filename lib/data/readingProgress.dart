// import '../data/bible.dart';
// import '../pages/chapters.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'dart:async';

// class ProgressService {

//   DatabaseReference userChaptersRef = FirebaseDatabase.instance.reference().child('users/BvE3IKiyrJTfgMSk4EammFl5Brl1/readingProgress').child('chapters');

//   DatabaseReference userBooksRef = FirebaseDatabase.instance.reference().child('users/BvE3IKiyrJTfgMSk4EammFl5Brl1/readingProgress').child('bibleBook');
  

//   List allChapters;
//   List allBooks;

// Future<List> allChaptersList() async {
//   DataSnapshot snapshot = await userChaptersRef.once();
//   var result = snapshot.value;
//     allChapters = result;
//     allChapters = allChapters.toList();
//     allChapters.removeAt(0);
//  return allChapters;
// }



// Future<List> allBooksList() async {
//   await for (var data in userBooksRef.onValue) {
//       if (data.snapshot.value != null) {
//         allBooks = data.snapshot.value;
//         allBooks = allBooks.removeAt(0);
//       }
//     }
//     return allBooks;
// }

//   Future<void> updateBookRead(bool bookRead, int index, List bookFilteredChaptersList) async {
//    await userBooksRef
//         .child('${index + 1}')
//         .update({
//       'isRead': bookRead,
//     }).then((_) async {
//       for (var chapter in bookFilteredChaptersList) {
//         await userChaptersRef.child(chapter['chapterID'])
//           .update({
//             'isRead': bookRead,
//           });
//         }
//     });

//   }

// List bookFilteredList(int bookID, List allChaptersList) {
//     List bookFiltered = allChaptersList.where((d) => d['bookID'] == bookID).toList();
//     return bookFiltered;
// }


// List<Chapters> unReadChaptersList(List allChapters) {
//     List unReadChapters = allChapters.where((d) => d['isRead'] == false);
//     return unReadChapters;
// }

// int getCurrentProgressNumber(List unReadChapters, List allChapters) {
//     double number = 100 / allChapters.length;
//     int total = (number * unReadChapters.length).toInt();
//   return total;
// }

// double getCurrentProgress(int progressNumber) {
//     double total = progressNumber / 100;
//   return total;
// }




// }
