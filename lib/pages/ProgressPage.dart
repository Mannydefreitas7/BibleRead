
import 'package:BibleRead/components/ChaptersList.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/helpers/app_localizations.dart';
import 'package:BibleRead/pages/progressview/ProgressCard.dart';
import '../components/bibleBooksList.dart';
import 'package:flutter/material.dart';
import '../classes/BibleReadScaffold.dart';

class ProgressPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BibleReadScaffold(
      hasBottombar: true,
      hasLeadingIcon: false,
      title: AppLocalizations.of(context).translate('progress'),
      hasFloatingButton: false,
      selectedIndex: 1,
      bodyWidget: Container(
      child: Stack(
        children: <Widget>[  
            Container(
              margin: EdgeInsets.only(top:50),
              child: StreamBuilder<int>(
                stream: SharedPrefs().getSelectedPlan().asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int selectedPlan = snapshot.data;
                    if (selectedPlan != 2) {
                      return BibleBookList();
                    } else {
                      return ChaptersList();
                    }
                  }
                  return BibleBookList();
                }
              )
            ),
            Container(
              padding: EdgeInsets.only(left:15, right:15),
              child: ProgressViewCard(
                subtitle: AppLocalizations.of(context).translate('current'),
              ),
            )
        ],
      ),
    ),
    );
  }
}
