import 'package:BibleRead/classes/Notifications.dart';
import 'package:BibleRead/helpers/FirstLaunch.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/app_localizations.dart';
import 'package:BibleRead/models/AllChapterListBloc.dart';
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:BibleRead/pages/OnBoardingPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

Notifications notifications = Notifications();

Future<void> main() async { 
WidgetsFlutterBinding.ensureInitialized();
  notifications.initializeNotifications();
  runApp(BibleReadApp());
}

class BibleReadApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
            ChangeNotifierProvider<BibleBookListData>(create: (_) => BibleBookListData()),
            Provider<AllChapterListBloc>(create: (_) => AllChapterListBloc()),
            StreamProvider<List<Plan>>(create: (_) => AllChapterListBloc().allChapters)
      ],
      
      child: MaterialApp(
      initialRoute: '/',
      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en'),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
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
