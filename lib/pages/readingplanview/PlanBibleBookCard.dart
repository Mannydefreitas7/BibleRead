import 'package:flutter/material.dart';

class PlanBibleBookCard extends StatelessWidget {
  const PlanBibleBookCard({
    Key key,
    this.longName,
    this.shortName
  }) : super(key: key);

  final String longName;
  final String shortName;

  @override
  Widget build(BuildContext context) {
    return Container(
     // clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
        horizontal: 10),
          width: 100,
        //  height: 100,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius:BorderRadius.circular(20)),
          child: Column(children: [
            Text(shortName,
            overflow: TextOverflow.fade,
              style: TextStyle(
                
              fontSize: 22,
              fontWeight:FontWeight.w600,
              color: Theme.of(context).textTheme.title.color),
            ),
              
            SizedBox(height: 2),

            Text(longName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).textTheme.title.color))
          ])
        );
  }
}
