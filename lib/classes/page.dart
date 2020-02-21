import 'package:flutter/cupertino.dart';

class PageItem {

Widget pageWidget;
String route;
String title;
Function refresh;

PageItem({this.pageWidget, this.route, this.title, this.refresh});

}
