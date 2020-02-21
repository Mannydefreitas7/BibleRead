import 'package:flutter/material.dart';

class ButtonsCard extends StatelessWidget {
  const ButtonsCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0)
         ),
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(color: Colors.grey[100],
            padding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10),
              ),
            textColor: Theme.of(context).primaryColor,
            child: Row(
              children: <Widget>[
                Padding(
                 padding: EdgeInsets.only(right: 10), 
                 child: Icon(Icons.description),
                ),
                Text('Read', style: TextStyle(fontSize: 20),),
              ],
            ),
            onPressed:  () => {
            print('button pressed')
            },
          ),
          FlatButton(color: Colors.grey[100],
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10),
              ),
          textColor: Theme.of(context).primaryColor,
            child: Row(
              children: <Widget>[
                Padding(
                 padding: EdgeInsets.only(right: 10), 
                 child: Icon(Icons.play_circle_outline),
                ),
                Text('Play', style: TextStyle(fontSize: 20)),
              ],
            ),
            onPressed: () => {
            print('button pressed')
            },
          ),
        ],
      ),
    ),
    color: Theme.of(context).cardColor,
    );
  }
}