import 'dart:io';

import 'package:BibleRead/classes/audio/AudioPlayerController.dart';
import 'package:BibleRead/classes/custom/CustomNavigation.dart';
import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/custom/scrollBehavior.dart';
import 'package:BibleRead/classes/database/LocalDataBase.dart';
import 'package:BibleRead/classes/notifications/Notifications.dart';
import 'package:BibleRead/classes/service/FirstLaunch.dart';
import 'package:BibleRead/classes/service/ReadingProgressData.dart';
import 'package:BibleRead/models/BibleBookListData.dart';
import 'package:BibleRead/views/onboarding/OnBoarding.dart';
import 'package:BibleRead/views/plans/Plans.dart';
import 'package:BibleRead/views/progress/Progress.dart';
import 'package:BibleRead/views/settings/Settings.dart';
import 'package:BibleRead/views/today/Today.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BibleRead/classes/custom/theme.dart' as Theme;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

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
            ChangeNotifierProvider<AudioPlayerController>(create: (_) => AudioPlayerController(),),
            ChangeNotifierProvider<ReadingProgressData>(create: (_) => ReadingProgressData(),)
      ],
      child: MaterialApp(
      initialRoute: '/',
      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
        Locale('de'),
        Locale('es'),
        Locale('fr'),
        Locale('hi'),
        Locale('it'),
        Locale('ja'),
        Locale('ru'),
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
          if (locale == null) {
                debugPrint("*language locale is null!!!");
            return supportedLocales.first;
          }

        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode ||
        supportedLocale.countryCode == locale.countryCode) {
            debugPrint("*language ok $supportedLocale");
            return supportedLocale;
          }
        }
        debugPrint("*language to fallback ${supportedLocales.first}");
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
            return CustomNavigation(builder: (context)=> Today());
            break;
          case '/progress':
            return CustomNavigation(builder: (context)=> Progress());
          case '/readingplans':
            return CustomNavigation(builder: (context)=> Plans());
          case '/settings':
            return CustomNavigation(builder: (context)=> Settings());
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
      getDocuments();
   _firstLaunch = firstLaunch;
   FirstLaunch().isNotFirstLaunch().then((value) => isfirstLaunch =  value);

}

getDocuments() async {
//   Directory appDocDir = await getApplicationDocumentsDirectory();
// Stream<FileSystemEntity> appDocPath = appDocDir.list();
// appDocPath.listen((event) {
//   print(event);
// });
  Database db = await coreData;
  List chapters = await db.query('ZCHAPTER');
  chapters.forEach((element) {
    print(element);
  });
 final prefs = await SharedPreferences.getInstance();
  var keys = prefs.getKeys();
  print(keys);
}

 Future<Database> get coreData async {
    Database _database;
    final _databaseName = "bibleModel.sqlite";
    final _databaseVersion = 1;
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, _databaseName);
    print(dbPath);
     _database = await openDatabase(dbPath, version: _databaseVersion); 
    return _database;
  }

Future<bool> get firstLaunch => FirstLaunch().isNotFirstLaunch();

 Future<void> _initialSetup() async {
   bool isFirstLaunch = await FirstLaunch().isNotFirstLaunch();
    if (isFirstLaunch == null) {
          await DatabaseHelper().setupDatabase();
          await FirstLaunch().setDefaults();
          await DatabaseHelper().setLanguagesName();
    }
  }

  @override
  Widget build(BuildContext context) {
   
  return FutureBuilder(
    initialData: isfirstLaunch,
    future: _firstLaunch, 
    builder: (BuildContext context, AsyncSnapshot snapshot) {

      if (snapshot.hasData) {
        return Today();
        
      } else if (!snapshot.hasData) {

        return OnBoarding();
        
      } else {

        return Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      }
    });
  }
}
