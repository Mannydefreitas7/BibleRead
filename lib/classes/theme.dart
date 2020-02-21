import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final ThemeData brThemeData = new ThemeData(
        fontFamily: 'Avenir Next',
        backgroundColor: Colors.grey[100],
        cardColor: Colors.white,
        accentColor: Colors.orangeAccent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.orangeAccent.withOpacity(0.5),
        scaffoldBackgroundColor: Colors.grey[100],
        bottomAppBarTheme: 


          BottomAppBarTheme(
            color: Colors.grey[200],
            elevation: 0.0,
          ),

          appBarTheme: AppBarTheme(
            elevation: 0.0,

            color: Colors.transparent,
            textTheme: TextTheme(
              title: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700),
            ),
          ),


          focusColor: Colors.orangeAccent,
          primaryColor: Colors.orangeAccent,
          textTheme: TextTheme(

            // Card subtitle
            caption: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),

            // Book & chapter to Read text
            subtitle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400),

            // Card titles
            title: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700)
          ),
          
    );
  
