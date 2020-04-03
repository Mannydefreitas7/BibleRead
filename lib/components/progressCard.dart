import 'package:BibleRead/helpers/animations.dart';
import 'package:flutter/material.dart';
import '../classes/progressCircle.dart';


class ProgressCard extends StatelessWidget {

  final String subtitle;
  final String textOne;
  final String textTwo;
  final String textThree;
  final double progressNumber;
  final Color backgroundColor;
  final Color textColor;
  final bool isToday;

  ProgressCard({this.subtitle, this.isToday, this.textColor, this.backgroundColor, this.textOne, this.textTwo, this.textThree, this.progressNumber});

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
                        color: textColor == null ? Theme.of(context).textTheme.subtitle.color : textColor),
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
                        color: textColor == null ? Theme.of(context).textTheme.title.color : textColor ),
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
                            textColor == null ? Theme.of(context).textTheme.title.color : textColor),
                  ),
                  SizedBox(width: 5),
                  Text(
                    textThree,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Avenir Next',
                        fontSize: 20.0,
                        color: textColor == null ? Theme.of(context).textTheme.title.color : textColor),
                  )
                    ],
                  )
                  ,
                ],
              ),
          
              AnimatedProgressCircle(
                endValue: progressNumber,
              )

            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),

        boxShadow: <BoxShadow>[
          BoxShadow(
            
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 2.0,
            blurRadius: 7.0
        )
      ],
    )
    );
  }
}
