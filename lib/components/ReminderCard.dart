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
            color: Theme.of(context).textTheme.title.color, 
            size: 35,),
            title: new Text(
              "Reminder",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Theme.of(context).textTheme.title.color,
              ),
            ),
          ),
          ListTile(
            leading: new Text(
              "Daily Reminder",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.title.color,
              ),
            ),
            trailing: XlivSwitch(
              onChanged: (reminder) => setState(() {
                reminderOn = !reminderOn;
              }),
              value: reminderOn,
              activeColor: Theme.of(context).accentColor,
              unActiveColor: Theme.of(context).backgroundColor,
              thumbColor: Theme.of(context).cardColor,
            )
            
          ),
         reminderOn ? ListTile(
            leading: new Text(
              "Time",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.title.color,
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
                  onTap: () {
                    
                  },  
                  child: Text(
                "7h00",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textTheme.title.color,
                ),
              ),
            ),
    )
          ) : Text(''),
          
        ],
      ),
    );
  }
}
