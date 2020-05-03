import 'package:BibleRead/classes/onboarding/slider_layout_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: onBordingBody(),
    );
  }

  Widget onBordingBody() => Container(
        child: SliderLayoutView(),
      ); 
}
