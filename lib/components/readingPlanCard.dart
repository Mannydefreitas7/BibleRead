import 'package:flutter/material.dart';
import '../classes/card.dart';

class ReadingPlanCard extends StatefulWidget {
  ReadingPlanCard({Key key}) : super(key: key);

  @override
  _ReadingPlanCardState createState() => _ReadingPlanCardState();
}

class _ReadingPlanCardState extends State<ReadingPlanCard> {


  @override
  Widget build(BuildContext context) {
    return BRCard(
      container: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage("assets/images/regular.jpg", ),
              ),
            ),
            ),
            Container(
              child: Text("Regular", style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.caption.color,
              ),),
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            ),
          ],
        ),
      ),
    );
  }
}
