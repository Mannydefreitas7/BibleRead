import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:xlive_switch/xlive_switch.dart';
import '../classes/DataPicker.dart';



class BibleReadingCard extends StatefulWidget {
  @override
  _BibleReadingCardState createState() => _BibleReadingCardState();
}

class _BibleReadingCardState extends State<BibleReadingCard> {

  List<String> plans = ['Regular', 'Writings of Moses', 'Exile', 'Kings', ];

  void _showDataPicker(List<String> data, String title) {
       final bool showTitleActions = true;
       DataPicker.showDatePicker(
         context,
         showTitleActions: showTitleActions,
         locale: 'en',
         datas: data,
         title: title,
         onChanged: (data) {
           print('onChanged date: $data');
         },
         onConfirm: (data) {
           print('onConfirm date: $data');
         },
       );
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
            leading: Icon(LineAwesomeIcons.book, color: Theme.of(context).textTheme.title.color, size: 35,),
            title: new Text(
              "Bible Reading",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Theme.of(context).textTheme.title.color,
              ),
            ),
          ),
          ListTile(
            leading: new Text(
              "Expected Progress",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.title.color,
              ),
            ),
            trailing: 
            XlivSwitch(
              value: false, 
              unActiveColor: Theme.of(context).backgroundColor,
              thumbColor: Theme.of(context).cardColor,
              activeColor: Theme.of(context).accentColor,
              onChanged: (reminder) => print('$reminder changed'))
            ),
          ListTile(
            leading: new Text(
              "Language",
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
                     _showDataPicker(plans, 'Plans');
                  },  
                  child: Text(
                "English",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textTheme.title.color,
                ),
              ),
            ),
    )
  ),

           ListTile(
            leading: new Text(
              "Bible",
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
                  onTap: () {},  
                  child: Text(
                "NWT",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textTheme.title.color,
                ),
              ),
            ),
    )
          ),

          ListTile(
              title: new Center(
            child: FlatButton(
                onPressed: () => print('review us'),
                child: new Text(
                  "Start Reading Over",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.redAccent
                  ),
                )),
          )
        ),
          
        ],
      ),
    );
  }
}
