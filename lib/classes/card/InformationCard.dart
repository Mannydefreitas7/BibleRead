import 'package:BibleRead/classes/custom/app_localizations.dart';
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
            leading: Icon(Icons.info_outline, color: Theme.of(context).textTheme.headline6.color, size: 35,),
            title: new Text(
              AppLocalizations.of(context).translate('information'),
             overflow: TextOverflow.ellipsis,
              style: TextStyle( 
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
          ),
          ListTile(
            leading: new Text(
              AppLocalizations.of(context).translate('app_name'),
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.headline6.color,
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
              AppLocalizations.of(context).translate('version'),
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
            trailing: new Text(
              "5.1.1",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xffaeaeae),
              ),
            ),
          ),
          ListTile(
            leading: new Text(
              AppLocalizations.of(context).translate('support'),
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
            trailing: new Text(
              "wolinweb@gmail.com",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xffaeaeae),
              ),
            ),
          ),
          ListTile(
              title: new Center(
            child: FlatButton(
                onPressed: () => LaunchReview.launch(iOSAppId: '1472187500', androidAppId: 'com.wolinweb.BibleRead', writeReview: true),
                child: new Text(
                   AppLocalizations.of(context).translate('review_us_on_app_store'),
                   textAlign: TextAlign.center,
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
