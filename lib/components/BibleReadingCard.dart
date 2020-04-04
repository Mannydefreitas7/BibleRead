import 'package:BibleRead/helpers/FirstLaunch.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/Language.dart';
import 'package:BibleRead/pages/settingsview/LanguagesView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xlive_switch/xlive_switch.dart';



class BibleReadingCard extends StatefulWidget {
  @override
  _BibleReadingCardState createState() => _BibleReadingCardState();
}

class _BibleReadingCardState extends State<BibleReadingCard> {
  bool showExpected = false;
  @override
  void initState() {
    super.initState();
  }

  void  _showExpectedProgress(bool showExpected) async {
    await SharedPrefs().setExpectedProgress(showExpected);
  }

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
            leading: Icon(LineAwesomeIcons.book, color: Theme.of(context).textTheme.headline6.color, size: 35,),
            title: new Text(
              "Bible Reading",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
          ),
          ListTile(
            leading: new Text(
              "Expected Progress",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
            trailing: 
            StreamBuilder<bool>(
              initialData: showExpected,
              stream: SharedPrefs().getExpectedProgress().asStream(),
              builder: (context, snapshot) {
                showExpected = snapshot.hasData ? snapshot.data : false;
                return XlivSwitch(
                  value: showExpected, 
                  unActiveColor: Theme.of(context).backgroundColor,
                  thumbColor: Theme.of(context).cardColor,
                  activeColor: Theme.of(context).accentColor,

                  onChanged: (expectedProgress) => setState(() {
                      showExpected = !showExpected;
                      _showExpectedProgress(showExpected);
                  }));
        })
            ),
          ListTile(
            leading: new Text(
              "Language",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.headline6.color,
              ),
            ),
            trailing: 
            new Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(20.00), 
            ), 
            child: InkWell(
                  onTap: () => Navigator.push(context, 
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => LanguagesView()
                    )
                  ),  
                  child: StreamBuilder(
                stream: Rx.combineLatest2<String, List<Language>, LanguagesData>(FirstLaunch().getBibleLocale().asStream(), DatabaseHelper().getLanguages().asStream(), (bibleLocale, languages) => LanguagesData(bibleLocale: bibleLocale, languages: languages)),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  String currentLanguage;
                  if (snapshot.hasData) {
                    LanguagesData languagesData = snapshot.data;
                    List<Language> languages = languagesData.languages;
                    languages = languages.where((element) => element.locale == languagesData.bibleLocale).toList();
                    currentLanguage = languages[0].name;
                  } else {
                    currentLanguage = 'English';
                  }
                 return Text(
                currentLanguage,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                textWidthBasis: TextWidthBasis.parent,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textTheme.headline6.color,
                )
              );
                })
            ),
    )
  ),
  SizedBox(height: 20),
  Column(
    children:[
        Text(
              "Bible Translation",
              style: TextStyle(
                fontSize: 18,
              //  fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headline6.color,
              ),
          ),
          StreamBuilder(
                stream: Rx.combineLatest2<String, List<Language>, LanguagesData>(FirstLaunch().getBibleLocale().asStream(), DatabaseHelper().getLanguages().asStream(), (bibleLocale, languages) => LanguagesData(bibleLocale: bibleLocale, languages: languages)),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  String currentBible;
                  if (snapshot.hasData) {
                    LanguagesData languagesData = snapshot.data;
                    List<Language> languages = languagesData.languages;
                    languages = languages.where((element) => element.locale == languagesData.bibleLocale).toList();
                    currentBible = languages[0].bibleTranslation;
                  } else {
                    currentBible = 'New World Translation of the Holy Scriptures (2013 Revision)';
                  }
                 return Container(
                   width: MediaQuery.of(context).size.width / 1.2,
                   child: Text(
                currentBible,
                maxLines: 3,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                textWidthBasis: TextWidthBasis.parent,
                style: TextStyle(
                
                fontSize: 15,
                color: Color(0xffaeaeae),
              ),
              ),
                 );
          })
    ]
  ),
  SizedBox(height: 20),
          ListTile(
              title: new Center(
            child: FlatButton(
                onPressed: () => print('review us'),
                child: new Text(
                  "Start Reading Over",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.redAccent
                  ),
                )),
          )
        ),
          
        ],
      ),
    );
  }
}
