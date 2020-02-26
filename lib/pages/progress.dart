import 'dart:async';

import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:BibleRead/pages/progressview/ProgressCard.dart';

import '../components/bibleBooksList.dart';
import '../components/progressCard.dart';
import 'package:flutter/material.dart';

class Progress extends StatefulWidget {


  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {

  _refresh() {
    setState(() {});
    return ProgressViewCard().createState().refresh();
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(

        children: <Widget>[
          
            Container(
              margin: EdgeInsets.only(top:50),
              child: BibleBookList()
            ),

            Container(
              padding: EdgeInsets.only(left:15, right:15),
              child: ProgressViewCard(),
            )
        ],
      ),
    );
  }
}
