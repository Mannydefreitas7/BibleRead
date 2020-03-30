import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


final ThemeData brThemeData = new ThemeData(
        fontFamily: 'Avenir Next',
        backgroundColor: Colors.grey[100],
        cardColor: Colors.white,
        brightness: Brightness.light,
        accentColor: Colors.orange[300],
        textSelectionColor: Colors.orange[300].withOpacity(0.5),
        textSelectionHandleColor: Colors.orangeAccent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
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
          bottomAppBarColor: Colors.white,
          focusColor: Colors.orangeAccent,
          canvasColor: Colors.grey[300].withOpacity(0.5),
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
            subhead: TextStyle(
              color: Colors.black
            ),
            // Card titles
            title: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700)
          ),   
    );

final ThemeData brThemeDataDark = new ThemeData(
        fontFamily: 'Avenir Next',
        backgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        brightness: Brightness.dark,
        textSelectionColor: Colors.orange[300].withOpacity(0.5),
        textSelectionHandleColor: Colors.orange[300],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white

        ),
        accentColor: Colors.orange[300],
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.grey[100],
        bottomAppBarColor: Colors.grey[900],
        bottomAppBarTheme: 
          BottomAppBarTheme(
            color: Colors.grey[900],
            elevation: 0.0,
          ),

          appBarTheme: AppBarTheme(
            elevation: 0.0,

            color: Colors.transparent,
            textTheme: TextTheme(
              title: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700),
            ),
          ),

          focusColor: Colors.orangeAccent,
          canvasColor: Colors.black.withOpacity(0.2),
          primaryColor: Colors.orangeAccent,
          textTheme: TextTheme(
            
            // Card subtitle
            caption: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),
            subhead: TextStyle(
              color: Colors.grey
            ),
            // Book & chapter to Read text
            subtitle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400),

            // Card titles
            title: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700)
          ),   
    );

