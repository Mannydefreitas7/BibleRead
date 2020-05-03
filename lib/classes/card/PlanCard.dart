import 'package:BibleRead/classes/custom/animations.dart';
import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {

  final String subtitle;
  final String textPlan;
  final String planImage;

  PlanCard({this.subtitle, this.textPlan, this.planImage});

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
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        fontFamily: 'Avenir Next',
                        color: Theme.of(context).textTheme.subtitle2.color),
                  ),
                  Row(
                    children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                      textPlan,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Avenir Next',
                          fontSize: 20.0,
                          color:Theme.of(context).textTheme.headline6.color),
                  ),
                    ),
                    ],
                  ),
                ],
              ),
              AnimatedReadingPlan(planImage: planImage,)
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2.0,
            blurRadius: 7.0
        )
      ],
    )
    );
  }
}
