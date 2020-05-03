import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class SupportCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(36.00),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(LineAwesomeIcons.headset, color: Theme.of(context).textTheme.headline6.color, size: 35,),
            title: new Text(
             AppLocalizations.of(context).translate('support'),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
          ),
          ListTile(
            leading: new Text(
              AppLocalizations.of(context).translate('author'),
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
            trailing: new Text(
              "Manuel De Freitas",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xffaeaeae),
              ),
            ),
          ),
          ListTile(
            leading: new Text(
              AppLocalizations.of(context).translate('email'),
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
            trailing: new Text(
              "support@wolinweb.com",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xffaeaeae),
              ),
            ),
          ),
          ListTile(
              leading: new Text(
              "Donate",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
            trailing: new Text(
              "paypal.me",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xffaeaeae),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
