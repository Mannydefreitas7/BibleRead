import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressCircle extends StatelessWidget {

  final double progressNumber;
  final String progressText;
  final double radiusWidth;
  final double lineWidth;
  final double fontSize;
  final Color backgroundColor;
  final Color progressColor;

  ProgressCircle({
    this.progressNumber, 
    this.progressText, 
    this.radiusWidth, 
    this.lineWidth, 
    this.fontSize,
    this.backgroundColor,
    this.progressColor
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
              animation: true,
              backgroundColor: backgroundColor == null ? Theme.of(context).canvasColor.withOpacity(0.3) : backgroundColor,
              animateFromLastPercent: true,
              radius: radiusWidth == null ? 60.0 : radiusWidth,
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: lineWidth == null ? 6.0 : lineWidth,
              percent: progressNumber,
              center: progressText != null ? Text(progressText, style: TextStyle(
                fontSize: fontSize == null ? 14.0 : fontSize,
                color: Theme.of(context).textTheme.headline6.color,
                fontFamily: 'Avenir Next',
                fontWeight: FontWeight.bold
              ),) : Container(),
              progressColor: progressColor == null ?  Theme.of(context).accentColor : progressColor,
              reverse: true,
    );
  }
}
