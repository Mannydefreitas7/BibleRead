import 'package:flutter/material.dart';

// Main page bar title
class PageTitleText extends StatelessWidget {

  final String title;
  final Color textColor;

  const PageTitleText({Key key, this.title, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: textColor,
        
        fontFamily: 'Avenir Next',
        fontWeight: FontWeight.w700,
        fontSize: 32.00
      ),
    );
  }
}


// Text class used for secondary white title
class SecondaryTitleText extends StatelessWidget {

  final String secondaryTitle;
  const SecondaryTitleText({Key key, this.secondaryTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      secondaryTitle,
      style: TextStyle(
        color: Theme.of(context).textTheme.title.color,
        fontFamily: 'Avenir Next',
        fontWeight: FontWeight.w500,
        fontSize: 22.00
      ),
    );
  }
}

// Text class used for secondary white title
class SubTitleText extends StatelessWidget {

  final String subTitle;
  const SubTitleText({Key key, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      subTitle,
      style: TextStyle(
        color: Theme.of(context).textTheme.subtitle.color,
        fontFamily: 'Avenir Next',
        fontWeight: FontWeight.w700,
        fontSize: 20.00
      ),
    );
  }
}

// Regular App Text - 18px
class RegularText extends StatelessWidget {

  final String text;
  final Color textColor;
  const RegularText({Key key, this.text, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontFamily: 'Avenir Next',
        fontWeight: FontWeight.w500,
        fontSize: 18.00
      ),
    );
  }
}

// Large App Text - 16px
class LargeText extends StatelessWidget {

  final String text;
  final Color textColor;
  const LargeText({Key key, this.text, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontFamily: 'Avenir Next',
        fontWeight: FontWeight.w500,
        fontSize: 26.00
      ),
    );
  }
}

// Small App Text - 16px
class SmallText extends StatelessWidget {

  final String text;
  final Color textColor;
  const SmallText({Key key, this.text, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontFamily: 'Avenir Next',
        fontWeight: FontWeight.w500,
        fontSize: 16.00
      ),
    );
  }
}

// Xtra Small App Text - 12px
class XSmallText extends StatelessWidget {

  final String text;
  final Color textColor;
  const XSmallText({Key key, this.text, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontFamily: 'Avenir Next',
        fontWeight: FontWeight.w500,
        fontSize: 12.00
      ),
    );
  }
}

// Xtra Small App Text - 12px
class LinkText extends StatelessWidget {

  final String text;
  const LinkText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).accentColor,
        fontFamily: 'Avenir Next',
        fontWeight: FontWeight.w500,
        fontSize: 20.00
      ),
    );
  }
}

