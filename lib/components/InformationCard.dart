import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:launch_review/launch_review.dart';


class InformationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      //height: 231.00,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(36.00),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.info_outline, color: Theme.of(context).textTheme.title.color, size: 35,),
            title: new Text(
              "Information",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Theme.of(context).textTheme.title.color,
              ),
            ),
          ),
          ListTile(
            leading: new Text(
              "App Name",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.title.color,
              ),
            ),
            trailing: new Text(
              "Bible Read",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xffaeaeae),
              ),
            ),
          ),
          ListTile(
            leading: new Text(
              "Version",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.title.color,
              ),
            ),
            trailing: new Text(
              "5.0",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xffaeaeae),
              ),
            ),
          ),
          ListTile(
              title: new Center(
            child: FlatButton(
                onPressed: () => LaunchReview.launch(writeReview: true),
                child: new Text(
                  "Review us on App Store",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).accentColor,
                  ),
                )),
          )
          ),
        ],
      ),
    );
  }
}
