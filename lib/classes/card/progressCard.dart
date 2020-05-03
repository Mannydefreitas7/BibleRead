import 'package:BibleRead/classes/custom/animations.dart';
import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {

  final String subtitle;
  final String textOne;
  final String textTwo;
  final String textThree;
  final double progressNumber;
  final Color backgroundColor;
  final Color textColor;
  final bool isToday;
  final double expectedValue;
  final bool showExpected;

  ProgressCard({this.subtitle, this.showExpected, this.isToday, this.textColor, this.backgroundColor, this.expectedValue, this.textOne, this.textTwo, this.textThree, this.progressNumber});

  @override
  Widget build(BuildContext context) {
   
    return Container(
      child: Card(

        elevation: 0,
        color: backgroundColor == null ? Theme.of(context).cardColor : backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          padding: EdgeInsets.all(18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    subtitle,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        fontFamily: 'Avenir Next',
                        color: textColor == null ? Theme.of(context).textTheme.subtitle2.color : textColor),
                  ),
                  Row(
                    children: <Widget>[
                    Text(
                    textOne,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Avenir Next',
                        fontSize: 20.0,
                        color: textColor == null ? Theme.of(context).textTheme.headline6.color : textColor ),
                  ),
                   SizedBox(width: textOne.length != 0 ? 5 : 0,),
                     Text(
                    textTwo,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Avenir Next',
                        fontSize: 20.0,
                        color:
                            textColor == null ? Theme.of(context).textTheme.headline6.color : textColor),
                  ),
                  SizedBox(width: 5),
                  Text(
                    textThree,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Avenir Next',
                        fontSize: 20.0,
                        color: textColor == null ? Theme.of(context).textTheme.headline6.color : textColor),
                  )
                    ],
                  )
                  ,
                ],
              ),
          
              AnimatedProgressCircle(
                endValue: progressNumber,
                expectedValue: showExpected == null ? 0 : expectedValue,
                showExpected: showExpected == null ? false : showExpected,
              )
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),

        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(0, 5),
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 2.0,
            blurRadius: 10.0
        )
      ],
    )
    );
  }
}
