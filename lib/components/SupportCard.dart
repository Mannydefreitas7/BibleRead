import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';

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
            leading: Icon(LineAwesomeIcons.headset, color: Theme.of(context).textTheme.title.color, size: 35,),
            title: new Text(
              "Support",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Theme.of(context).textTheme.title.color,
              ),
            ),
          ),
          ListTile(
            leading: new Text(
              "Author",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.title.color,
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
              "Email",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.title.color,
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
                color: Theme.of(context).textTheme.title.color,
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
