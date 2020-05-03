import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final primaryOrangeColor = Color(0xFFFAA535);

final ThemeData brThemeData = new ThemeData(
        fontFamily: 'Avenir Next',
        backgroundColor: Colors.grey[100],
        cardColor: Colors.white,
        brightness: Brightness.light,
        accentColor: primaryOrangeColor,
        textSelectionColor: primaryOrangeColor.withOpacity(0.5),
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
              headline6: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          bottomAppBarColor: Colors.white,
          focusColor: primaryOrangeColor,
          canvasColor: Colors.grey[300].withOpacity(0.5),
          primaryColor: primaryOrangeColor,
          textTheme: TextTheme(
            // Card subtitle
            caption: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),

            // Book & chapter to Read text
            subtitle2: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400),
            subtitle1: TextStyle(
              color: Colors.black
            ),
            // Card titles
            headline6: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700)
          ),   
    );

final ThemeData brThemeDataDark = new ThemeData(
        fontFamily: 'Avenir Next',
        backgroundColor: Colors.black,
        cardColor: Color(0xFF191818),
        brightness: Brightness.dark,
        textSelectionColor: primaryOrangeColor.withOpacity(0.5),
        textSelectionHandleColor:primaryOrangeColor,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white

        ),
        accentColor: primaryOrangeColor,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.grey[100],
        bottomAppBarColor: Color(0xFF191818),
        bottomAppBarTheme: 
          BottomAppBarTheme(
            color: Color(0xFF191818),
            elevation: 0.0,
          ),

          appBarTheme: AppBarTheme(
            elevation: 0.0,

            color: Colors.transparent,
            textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700),
            ),
          ),

          focusColor: primaryOrangeColor,
          canvasColor: Colors.black.withOpacity(0.2),
          primaryColor: primaryOrangeColor,
          textTheme: TextTheme(
            
            // Card subtitle
            caption: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),
            subtitle1: TextStyle(
              color: Colors.grey
            ),
            // Book & chapter to Read text
            subtitle2: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400),

            // Card titles
            headline6: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700)
          ),   
    );

