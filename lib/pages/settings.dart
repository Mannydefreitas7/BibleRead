import 'package:BibleRead/components/BibleReadingCard.dart';
import 'package:BibleRead/components/ReminderCard.dart';
import 'package:flutter/material.dart';
import '../components/InformationCard.dart';
import '../components/SupportCard.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final String title = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Container(
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
           SupportCard(),
           SizedBox(height: 20),
         ]
       )
    );
  }
}