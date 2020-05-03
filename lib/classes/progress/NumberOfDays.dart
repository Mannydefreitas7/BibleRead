import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/database/LocalDataBase.dart';
import 'package:flutter/material.dart';


class NumberOfDays extends StatelessWidget {
  const NumberOfDays({Key key, this.planId}) : super(key: key);
  
  final int planId;

    int _countDays(AsyncSnapshot progressData) {
      List _allDays = progressData.data;
      final int numberDays = _allDays.toList().length;
      return numberDays;      
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseHelper().queryPlan(planId),
        builder: (context, data) {
            return Column(
              children: [
            Text(AppLocalizations.of(context).translate('number_of_days'),
            style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.caption.color)),
            Text(data.data != null ?  '${_countDays(data)}' : 'Calculating...',
            style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.headline6.color))
              ]
            );
        },
     
    );
  }
}
