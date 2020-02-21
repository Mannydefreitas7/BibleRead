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
      margin: EdgeInsets.symmetric(
        horizontal: 10),
          width: 120,
          height: 100,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius:BorderRadius.circular(20)),
          child: Column(children: [
            Text(shortName,
              style: TextStyle(
              fontSize: 22,
              fontWeight:FontWeight.w600,
              color: Colors.black),
            ),
              
            SizedBox(height: 2),

            Text(longName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black))
          ])
        );
  }
}