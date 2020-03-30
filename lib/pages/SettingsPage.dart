import 'package:BibleRead/components/BibleReadingCard.dart';
import 'package:BibleRead/components/ReminderCard.dart';
import 'package:flutter/material.dart';
import '../components/InformationCard.dart';
import '../components/SupportCard.dart';
import '../classes/BibleReadScaffold.dart';

class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BibleReadScaffold(
      title: 'Settings',
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
