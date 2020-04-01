import 'package:BibleRead/classes/datepicker/date_picker.dart';
import 'package:BibleRead/helpers/DateTimeHelpers.dart';
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

  void _setStartDate(value) {
    DatabaseHelper().updateReadingPlanDate(widget.planId, value);
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
            _showDatePicker(context, 'Reading Start Date');
          },
          child: FutureBuilder(
            future: DatabaseHelper().queryReadingPlan(widget.planId),
            builder: (context, data) {
             if (data.hasData) {
               return Text(data.data[0]['StartDate'] != null ? DateTimeHelpers().dateFormatted(data.data[0]['StartDate']) : startDate,
                style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color:Theme.of(context).textTheme.title.color)
            ); 
             }  else {
               return Text(startDate,
                style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.title.color)
            );
             }
              
            })
          )
          
          ),
      ]
    );
  }
}
