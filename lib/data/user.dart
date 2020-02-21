// import 'readingProgress.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class UserData extends StatelessWidget  {
//   UserData({Key key, this.uid}) : super(key: key);
//   final String uid;
//   final userRef = FirebaseDatabase.instance.reference().child('users/');

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: userRef.child('$uid').onValue,
//       builder:(context, snap) {
//          if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
//            DataSnapshot snapshot = snap.data.snapshot;
//            print(snapshot.value);
//            return snapshot.value;
//          } else {
//               return Center(child: CircularProgressIndicator());
//           }
//       });
//   }
// }

// class User {
//   String id;
//   String name;
//   bool reminder;
//   int reminderHour;
//   int reminderMinutes;
//   int selectedPlan;
//   DateTime startDate;
//   int currentProgress;
//   bool bookmarked;
//   String bookmarkData;
// }
