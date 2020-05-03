import 'package:BibleRead/classes/card/BibleReadingCard.dart';
import 'package:BibleRead/classes/card/InformationCard.dart';
import 'package:BibleRead/classes/card/ReminderCard.dart';
import 'package:BibleRead/classes/custom/BibleReadScaffold.dart';
import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:flutter/material.dart';


class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BibleReadScaffold(
      title: AppLocalizations.of(context).translate('settings'),
      hasBottombar: true,
      hasLeadingIcon: false,
      hasFloatingButton: false,
      selectedIndex: 3,
      bodyWidget: Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.height,
       child: ListView(
         children: [
           InformationCard(),
           SizedBox(height: 20),
           ReminderCard(),
           SizedBox(height: 20),
           BibleReadingCard(),
           SizedBox(height: 20),
          // SupportCard(),
           SizedBox(height: 20),
         ]
       )
    ),
    );  
  }
}
