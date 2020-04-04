import 'package:BibleRead/classes/datepicker/date_picker.dart';

import 'ReadingPlanView.dart';
import 'package:flutter/material.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';

class ReadingStartDate extends StatefulWidget {

  ReadingStartDate({this.planId});

  final int planId;

  @override
  _ReadingStartDateState createState() => _ReadingStartDateState();
}

class _ReadingStartDateState extends State<ReadingStartDate> {
  final String startDate = ReadingPlanView.dateFormat(DateTime.now());

  void _setStartDate(DateTime dateTime) {
    DatabaseHelper().setReadingPlanStartDate(dateTime, widget.planId);
  }

  void _showDatePicker(BuildContext context, String title) {
    DatePicker.showDatePicker(
      context,

        title: 'Start Date',
        initialDateTime: DateTime.now(),
        onConfirm: (date, _) => {
          setState(() => {
            _setStartDate(date)
          }) 
        },
        pickerMode: DateTimePickerMode.date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Reading Start Date',
        style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).textTheme.caption.color)),
    Container(
        margin: EdgeInsets.all(5),
        padding:
            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () {
            _showDatePicker(context, 'Start Date');
          },
          child: StreamBuilder(
            stream: DatabaseHelper().getReadingPlanStartDate(widget.planId).asStream(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              String date;
           
              if(snapshot.hasData) {
                String data = snapshot.data;
                DateTime parseDate = DateTime.parse(data);
                 date = '${parseDate.year}/${parseDate.month}/${parseDate.day}';
              } else {
                DateTime parseDate = DateTime.parse(startDate);
                date = '${parseDate.year}/${parseDate.month}/${parseDate.day}';
              }
               return Text(date,
                style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color:Theme.of(context).textTheme.headline6.color)
            ); 
              
            })
          )
          ),
      ]
    );
  }
}
