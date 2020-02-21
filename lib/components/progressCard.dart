import 'package:BibleRead/helpers/animations.dart';
import 'package:flutter/material.dart';
import '../classes/progressCircle.dart';


class ProgressCard extends StatelessWidget {

  final String subtitle;
  final String textOne;
  final String textTwo;
  final String textThree;
  final double progressNumber;

  ProgressCard({this.subtitle, this.textOne, this.textTwo, this.textThree, this.progressNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(

        elevation: 0,
        color: Theme.of(context).cardColor,
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
                        fontWeight: FontWeight.w300,
                        fontSize: 16.0,
                        fontFamily: 'Avenir Next',
                        color: Theme.of(context).textTheme.subtitle.color),
                  ),
                  Row(
                    children: <Widget>[
                    Text(
                    textOne,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Avenir Next',
                        fontSize: 20.0,
                        color:
                            Theme.of(context).textTheme.title.color),
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
                            Theme.of(context).textTheme.title.color),
                  ),
                  SizedBox(width: 5),
                  Text(
                    textThree,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Avenir Next',
                        fontSize: 20.0,
                        color:
                            Theme.of(context).textTheme.title.color),
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
            
            color: Colors.grey[300].withOpacity(0.2),
            spreadRadius: 2.0,
            blurRadius: 7.0
        )
      ],
    )
    );
  }
}
