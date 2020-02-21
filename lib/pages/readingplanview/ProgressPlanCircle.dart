import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/animations.dart';
import 'package:flutter/material.dart';

class ProgressPlanCircle extends StatelessWidget {
  const ProgressPlanCircle({Key key, this.planId}) : super(key: key);
  final int planId;


  double _countProgressValue(AsyncSnapshot progressData)  {
    
        List _allDays = progressData.data;   
          List _isReadDays = _allDays.where((i) => i['IsRead'] == 1).toList();
          print(_isReadDays.length);
          final expo = 100 / _allDays.toList().length;
          final double endValue = (_isReadDays.length * expo) / 100;
          return endValue;
  
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        
          stream: DatabaseHelper().queryPlan(planId).asStream(),
          builder: (context, progress) {

            if (progress.hasData) {
               return AnimatedProgressCircle(
                fontSize: 20,
                lineWidth: 10.0,
                endValue: _countProgressValue(progress),
                radiusWidth: 120.0,
          );
        } else {
            return CircularProgressIndicator();
        }

             
                
         
    },
    );
  }
}