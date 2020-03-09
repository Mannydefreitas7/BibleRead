import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressCircle extends StatelessWidget {

  final double progressNumber;
  final String progressText;
  final double radiusWidth;
  final double lineWidth;
  final double fontSize;

  ProgressCircle({this.progressNumber, this.progressText, this.radiusWidth, this.lineWidth, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
              animation: true,
              backgroundColor: Theme.of(context).canvasColor,
              animateFromLastPercent: true,      
              radius: radiusWidth == null ? 60.0 : radiusWidth,
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: lineWidth == null ? 6.0 : lineWidth,
              percent: progressNumber,

              center: Text(progressText, style: TextStyle(
                fontSize: fontSize == null ? 14.0 : fontSize,
                color: Theme.of(context).textTheme.title.color,
                fontFamily: 'Avenir Next',
                fontWeight: FontWeight.bold
              ),),
              progressColor: Theme.of(context).accentColor,
              reverse: true,
    );
  }
}
