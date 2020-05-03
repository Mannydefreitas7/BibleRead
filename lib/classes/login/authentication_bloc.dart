  int bookID;
  String chapterID;
  String chapterRange;


// Future<void> _firstTimeLaunch() async {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //  prefs.remove('firstTime');
  //     FirebaseAuth auth = FirebaseAuth.instance;
  //     FirebaseDatabase db = FirebaseDatabase.instance;
  //     List temp = [];
  //     var today = new DateTime.now().toString();
  //     if (prefs.getBool('firstTime') == null) {
  //       try {
  //        await auth.signInAnonymously()
  //        .then((r) => {

  //         prefs.setString('uid', r.user.uid),
  //          db.reference().child('users/${r.user.uid}')
  //          .set({
  //            'id': r.user.uid,
  //            'name': null,
  //            'bibleDownloaded': false,
  //            'bibles': '',
  //            'bibleLocale': 'en',
  //            'reminder': false,
  //             'reminderHour': 0,
  //             'reminderMinutes': 0,
  //             'selectedPlan': 0,
  //             'startDate': today,
  //             'currentProgress': 0.00,
  //             'bookmarked': false,
  //             'bookmarkData': '',
  //          }),
  //         db.reference().child('plans/0/days').once().then((plan) => {

  //           temp = plan.value,
  //           temp = temp.toList(),
  //           temp.removeAt(0),

  //               for (var p in temp) {

  //                 bookID = p['bookNumber'],
  //                 chapterID = p['id'],
  //                 chapterRange = p['chapters'],

  //                 db.reference().child('users/${r.user.uid}/readingProgress/bibleBook').child('$bookID')
  //               .set({
  //                 'isRead': false,
  //                 'bookID': bookID,

  //                 }),

  //                 db.reference().child('users/${r.user.uid}/readingProgress/chapters').child(chapterID)
  //                   .set({
  //                     'isRead': false,
  //                     'bookID': bookID,
  //                     'chapterID': chapterID,
  //                     'chapterRange': chapterRange
  //                   })
  //               }
  //           })
  //         });
  //         } catch (e) {
  //           print(e);
  //       }
  //   }
  //   prefs.setBool('firstTime', false);
  //   //end of function
  // }