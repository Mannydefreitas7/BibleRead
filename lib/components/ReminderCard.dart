import 'dart:io';

import 'package:BibleRead/classes/Notifications.dart';
import 'package:BibleRead/classes/datepicker/date_picker.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/helpers/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:xlive_switch/xlive_switch.dart';

class ReminderCard extends StatefulWidget {
  @override
  _ReminderCardState createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {

  bool reminderOn = false;
  Notifications notifications = Notifications();
  @override
  void initState() {
    super.initState();
    notifications.initializeNotifications();
  }

   void showTimePicker(BuildContext context, String title) async {

    DatePicker.showDatePicker(
      context,
        title: title,
        initialDateTime: DateTime.now(),
        onConfirm: (date, _) => {
          setState(() => {
            _setReminderTime(date, context)
            
          }) 
        },
        pickerMode: DateTimePickerMode.time);
  }

  _setReminderTime(DateTime time, BuildContext context) async {
     
    await notifications.cancelAllNotifications();
    await SharedPrefs().setReminderTime(time);
    await notifications.showDailyAtTime(time, context);
  }

  _setReminder(bool reminder) async {
    if (reminder == true) {
      if (Platform.isIOS) {
          notifications.requestIOSPermissions();
          await SharedPrefs().setReminder(reminder);
      } else {
           await SharedPrefs().setReminder(reminder);
      }
    } else {
      await notifications.cancelAllNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(36.00),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(LineAwesomeIcons.bell, 
            color: Theme.of(context).textTheme.headline6.color, 
            size: 35,),
            title: new Text(
              AppLocalizations.of(context).translate('reminder'),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
          ),
          ListTile(
            leading: new Text(
              AppLocalizations.of(context).translate('daily_reminder'),
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
            trailing: StreamBuilder<bool>(
             // initialData: false,
              stream: SharedPrefs().getReminder().asStream(),
              builder: (context, snapshot) {
                reminderOn = snapshot.hasData ? snapshot.data : false;
                return XlivSwitch(
                  onChanged: (reminder) => setState(() {
                     reminderOn = !reminderOn;
                    _setReminder(reminderOn);
                  }),
                  value: reminderOn,
                  activeColor: Theme.of(context).accentColor,
                  unActiveColor: Theme.of(context).backgroundColor,
                  thumbColor: Theme.of(context).cardColor,
                );
              }
            )
            
          ),
         StreamBuilder<Object>(
           stream: SharedPrefs().getReminder().asStream(),
           builder: (context, snapshot) {
            bool isReminderOn = snapshot.hasData ? snapshot.data : false;
             if (isReminderOn) {
               return ListTile(
                leading: new Text(
                  AppLocalizations.of(context).translate('time'),
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
                trailing: 
                new Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(20.00), 
                ), 
                child: InkWell(
                      onTap: () => showTimePicker(context, AppLocalizations.of(context).translate('reminder')),  
                      child: StreamBuilder<String>(
                        initialData: '7h00',
                        stream: SharedPrefs().getReminderTime().asStream(),
                        builder: (context, snapshot) {
                          
                          return Text(snapshot.hasData ? snapshot.data : '7h00',
                    style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.headline6.color,
                    ),
                  );
                        }),
                ),
    )); 
              } else {
               return Container();
              }
           }),
        ],
      ),
    );
  }
}
