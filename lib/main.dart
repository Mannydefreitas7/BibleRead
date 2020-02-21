import 'package:BibleRead/helpers/FirstLaunch.dart';
import 'package:BibleRead/helpers/MultiProviderHelper.dart';

import 'package:provider/provider.dart';
import 'pages/ProgressPage.dart';
import 'pages/ReadingPlanPage.dart';
import 'pages/SettingsPage.dart';
import 'pages/TodayPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'classes/theme.dart' as Theme;
import 'classes/scrollBehavior.dart';

import 'classes/CustomNavigation.dart';

void main() => runApp(BibleReadApp());

class BibleReadApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MultiProviderHelper().multiprovider,
      child: MaterialApp(
      initialRoute: '/',
      builder: (context, child) {
    return ScrollConfiguration(
      behavior: ScrollingBehavior(),
      child: child,
    );
  },
      debugShowCheckedModeBanner: false,
      theme: Theme.brThemeData,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return CustomNavigation(builder: (context)=> MainApp());
            break;
          case '/progress':
            return CustomNavigation(builder: (context)=> ProgressPage());
          case '/readingplans':
            return CustomNavigation(builder: (context)=> ReadingPlanPage());
          case '/settings':
            return CustomNavigation(builder: (context)=> SettingsPage());
          default:
            return CustomNavigation(builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                )
            );
        }    
      }
    ),
    );
    
  }
}

class MainApp extends StatefulWidget {

  MainApp({Key key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  void initState() {
   
    super.initState();
    FirstLaunch().checkFirstUse();

  }
  @override
  Widget build(BuildContext context) {
    return TodayPage();
  }
}
