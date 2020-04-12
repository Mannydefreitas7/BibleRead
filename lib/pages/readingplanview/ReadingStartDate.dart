import 'package:BibleRead/classes/datepicker/date_picker.dart';
import 'package:BibleRead/helpers/app_localizations.dart';

import 'ReadingPlanView.dart';
import 'package:flutter/material.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:toast/toast.dart';
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

        title: AppLocalizations.of(context).translate('start_date'),
        initialDateTime: DateTime.now(),
        onChange: (date, _) => {
           if (date.isAfter(DateTime.now())) {
            Toast.show(
            AppLocalizations.of(context).translate('cannot_select_a_date_in_the_future'), 
            context, 
            backgroundColor: Colors.red[900],
            duration: Toast.LENGTH_LONG, 
            gravity:  Toast.CENTER),

          } 
        },
        onConfirm: (date, _) => {
          if (date.isAfter(DateTime.now())) {
            Toast.show(
            AppLocalizations.of(context).translate('cannot_select_a_date_in_the_future'), 
            context, 
            duration: Toast.LENGTH_LONG, 
            gravity:  Toast.CENTER),
          } else {
            setState(() => {
            _setStartDate(date)
          }) 
          }
        },
        pickerMode: DateTimePickerMode.date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context).translate('reading_start_date'),
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
            _showDatePicker(context, AppLocalizations.of(context).translate('start_date'));
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
