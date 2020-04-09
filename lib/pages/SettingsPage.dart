import 'package:BibleRead/components/BibleReadingCard.dart';
import 'package:BibleRead/components/ReminderCard.dart';
import 'package:BibleRead/helpers/app_localizations.dart';
import 'package:flutter/material.dart';
import '../components/InformationCard.dart';
import '../classes/BibleReadScaffold.dart';

class SettingsPage extends StatelessWidget {

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
