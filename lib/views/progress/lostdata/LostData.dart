import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/database/LocalDataBase.dart';
import 'package:BibleRead/models/CoreData.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class LostData extends StatelessWidget {
  const LostData({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              radius: 30,
                backgroundColor: Theme.of(context).backgroundColor,
                child: CloseButton(
                color: Theme.of(context).textTheme.headline6.color,
                onPressed: () => {
                  Navigator.pop(context)
                },
              ),
            ),
          )
        ]
      ),
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        
        Container(
          height: MediaQuery.of(context).size.width * 0.5,
          width: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/lostdata.png'))),
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
          child: Text(
            AppLocalizations.of(context).translate('retrieving_progress_title'),
            textAlign: TextAlign.center,
            
            style: TextStyle(
              
               color: Theme.of(context).textTheme.headline6.color,
              fontFamily: 'Avenir Next',
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              AppLocalizations.of(context).translate('retrieving_progress_message'),
              style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontFamily: 'Avenir Next',
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        FutureBuilder(
          future: DatabaseHelper().getCoreDataProgress(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              
              List<CoreDataObject> coreDataObjects = snapshot.data;
              CoreDataObject progress = coreDataObjects[0];
              return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                '${progress.ztitle} ${progress.zname}',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline6.color,
                  fontFamily: 'Avenir Next',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
            } else {
              return  SizedBox(
                  height: 5.0,
              );
            }
        }),
        SizedBox(
            height: 30.0,
        ),
        FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
               color: Theme.of(context).accentColor,
                onPressed: () async {
                 await DatabaseHelper().updateProgress().then((_) => {
                   Toast.show('Progress updated successfully', 
                   context, 
                   duration: Toast.LENGTH_LONG,
                   backgroundColor: Colors.green[900],
                   textColor: Colors.white,
                   gravity: Toast.CENTER
                   )
                 });
                 Navigator.pop(context);
                },
                child: Text(
                    AppLocalizations.of(context).translate('update_now'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Avenir Next',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                  ),
                ),
             SizedBox(
            height: 20.0,
        ),
          FlatButton (
                padding: EdgeInsets.all(10),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                    AppLocalizations.of(context).translate('later'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Avenir Next',
                        color: Theme.of(context).textTheme.caption.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                  ),
                ),

      ],
    )
    );
  } 

 
}
