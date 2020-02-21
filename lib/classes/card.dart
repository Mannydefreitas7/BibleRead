import 'package:BibleRead/helpers/animations.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../classes/textHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BRCard extends StatelessWidget {

 final Container container;
 final BorderRadiusGeometry borderRadius;

BRCard({this.container, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0.0,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius
         ),
        child: container
    );
  }
}

class HeaderCard extends StatelessWidget {

 final Container container;
 final SubTitleText title;
 final IconData cardIcon;

HeaderCard({this.container, this.title, this.cardIcon});

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      child: Card(
          elevation: 0.0,
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))
           ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(cardIcon,
                    color: Theme.of(context).iconTheme.color,
                    size: 22,
                    ),
                  title
                ],
              ),
              container
            ],
          )
      ),
      decoration: new BoxDecoration(boxShadow: [
        new BoxShadow(
          color: Colors.black,
          blurRadius: 20.0,
        ),
      ]),
    );
  }
}


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
                        fontWeight: FontWeight.w300,
                        fontSize: 16.0,
                        fontFamily: 'Avenir Next',
                        color: Theme.of(context).textTheme.subtitle.color),
                  ),
                  Row(
                    children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                      textPlan,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(

                          fontWeight: FontWeight.w600,
                          fontFamily: 'Avenir Next',
                          fontSize: 20.0,
                          color:
                              Theme.of(context).textTheme.title.color),
                  ),
                    ),
                   
                    ],
                  )
                  ,
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
            
            color: Colors.grey[300].withOpacity(0.2),
            spreadRadius: 2.0,
            blurRadius: 7.0
        )
      ],
    )
    );
  }
}


class ReadingPlanTile extends StatelessWidget {

  final int selectedIndex;
  final int index;
  final Function onTap;
  final String planTitle;
 // final AssetImage image;

  ReadingPlanTile({
    this.onTap,
    this.index, 
    this.selectedIndex, 
    this.planTitle
   // this.image
    });

    

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: InkWell(
          onTap: onTap,
          child: Container(
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          decoration: BoxDecoration(
            color: selectedIndex == index ? Theme.of(context).accentColor : Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          height: 100,
          child: Stack(
            children: <Widget>[
              Image(width: 100,
              height: 100,
                //  image: widget.image,
              image: AssetImage('assets/images/plan_${index}_sqr.jpg')
              ),
              Positioned(
                left: 80,
                  child: Container(
                decoration: BoxDecoration(
                  color: selectedIndex == index ? Theme.of(context).accentColor : Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                height: 100,
               
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                       width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(planTitle,
                      maxLines: 4,
                      textAlign: TextAlign.start,
                        style: TextStyle(
                      color: selectedIndex == index ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20
                      ),
                        ),
                    ),
                  ],
                ),
                  ),
              )
            ],
          )
        ),
      ),
    );
  }
}