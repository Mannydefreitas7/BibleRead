
import 'package:BibleRead/helpers/FirstLaunch.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/pages/OnBoardingPage.dart';
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
      providers: [
            ChangeNotifierProvider<BibleBookListData>(create: (_) => BibleBookListData()),
     
      ],
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
      darkTheme: Theme.brThemeDataDark,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/': 
            return CustomNavigation(builder: (context)=> MainApp());
            break;
          case '/today':
            return CustomNavigation(builder: (context)=> TodayPage());
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
  Future<bool> _firstLaunch;
  bool isfirstLaunch;
  @override
  void initState() {
    super.initState();
      _initialSetup();
   _firstLaunch = firstLaunch;
   FirstLaunch().isNotFirstLaunch().then((value) => isfirstLaunch =  value);

}

Future<bool> get firstLaunch => FirstLaunch().isNotFirstLaunch();

 Future<void> _initialSetup() async {
   bool isFirstLaunch = await FirstLaunch().isNotFirstLaunch();
    if (isFirstLaunch == null) {
          await DatabaseHelper().setupDatabase();
          await FirstLaunch().setDefaults();
    }
  }

  @override
  Widget build(BuildContext context) {
   
  return FutureBuilder(
    initialData: isfirstLaunch,
    future: _firstLaunch, 
    builder: (BuildContext context, AsyncSnapshot snapshot) {

      if (snapshot.hasData) {
        return TodayPage();

      } else if (!snapshot.hasData) {

        return OnBoardingPage();
        
      } else {

        return Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      }

    });
}
}
