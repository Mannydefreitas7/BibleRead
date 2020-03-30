import 'package:BibleRead/classes/BibleReadScaffold.dart';
import 'package:BibleRead/helpers/FirstLaunch.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/Language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rxdart/rxdart.dart';

class LanguagesView extends StatefulWidget {
  @override
  _LanguagesViewState createState() => _LanguagesViewState();
}

class _LanguagesViewState extends State<LanguagesView> {
  TextEditingController searchController = new TextEditingController();
  String filter;
  List<Language> languages = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    initLanguages();
  }

 void initLanguages() async {
   List<Language> _languages = await DatabaseHelper().getLanguages();
   _languages.forEach((language) {
     languages.add(language);
   });  
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  setBibleLocale(String locale) {
    FirstLaunch().setBibleLocale(locale);
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
     initLanguages();
    return BibleReadScaffold(
      hasFloatingButton: false,
      hasBottombar: false,
      hasLeadingIcon: true,
      selectedIndex: 3,
      title: 'Languages',
      bodyWidget: Container(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50), 
              child: StreamBuilder(
                stream: Rx.combineLatest2<String, List<Language>, LanguagesData>(FirstLaunch().getBibleLocale().asStream(), DatabaseHelper().getLanguages().asStream(), (bibleLocale, languages) => LanguagesData(bibleLocale: bibleLocale, languages: languages)),
                builder: (BuildContext context, AsyncSnapshot snapshot) {

                  if (snapshot.hasData) {
                    LanguagesData languagesData = snapshot.data;
                    return  ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
                itemCount: languagesData.languages.length,
                itemBuilder: (BuildContext context, int index) {
                  return filter == null || filter == '' ? 
                  LanguageTitle(
                    setLocale: () => setBibleLocale(languagesData.languages[index].locale),
                    subtitle: languagesData.languages[index].vernacularName,
                    title: languagesData.languages[index].name,
                    isSelected: languagesData.languages[index].locale == languagesData.bibleLocale ? true : false,
                    ) : languagesData.languages[index].name.toLowerCase().contains(filter.toLowerCase()) ? 
                  LanguageTitle(
                    subtitle: languagesData.languages[index].vernacularName,
                    title: languagesData.languages[index].name,
                    isSelected: languagesData.languages[index].locale == languagesData.bibleLocale ? true : false
                  ) : Container();  
                });
                  } else {
                    return Center(
                      child: SpinKitDoubleBounce(
                          color: Theme.of(context).accentColor,
                       ),
                    );
                  }
                })
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Material(
                  elevation: 10.0,
                  shadowColor: Colors.black.withOpacity(0.30),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                   child: TextField(
                  controller: searchController,
                  
                  style: TextStyle(
                    color: Theme.of(context).textTheme.title.color,
                      fontFamily: 'Avenir Next',
                      fontSize: 18.0,
                      decoration: TextDecoration.none,
                      
                      fontWeight: FontWeight.w500
                  ),
                  cursorColor: Theme.of(context).accentColor,
                  decoration: InputDecoration(
                    suffixIcon: Icon(LineAwesomeIcons.search, color: Theme.of(context).textTheme.title.color,),
                    filled: true,
                    
                    focusColor: Theme.of(context).textTheme.title.color,
                    hoverColor: Theme.of(context).textTheme.title.color,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    alignLabelWithHint: false,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none
                    ),
                    fillColor: Theme.of(context).cardColor,
                    labelText: 'Search',
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.caption.color,
                      fontFamily: 'Avenir Next',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400
                    )
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LanguageTitle extends StatelessWidget {
  const LanguageTitle({Key key, this.isSelected, this.subtitle, this.title, this.setLocale}) : super(key: key);

  final String title;
  final String subtitle;
  final bool isSelected;
  final Function setLocale;


  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20)
          ),
           child: ListTile(
             onTap: setLocale,
        leading: CircleAvatar(
          child: Icon(LineAwesomeIcons.language, color: Theme.of(context).textTheme.title.color),
          backgroundColor: Theme.of(context).cardColor,
        ),
        title: Text(title,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
          fontFamily: 'Avenir Next',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.title.color
        ),
        ),
        subtitle: Text(subtitle,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
         // fontFamily: 'Avenir Next',
          fontSize: 16,
        //  fontWeight: FontWeight.w300,
          color: Theme.of(context).textTheme.caption.color
        ),
        ),
        trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).accentColor) : null,
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    
    ));
  }
}

class LanguagesData {
  final List<Language> languages;
  final String bibleLocale;
LanguagesData({this.languages, this.bibleLocale});
}