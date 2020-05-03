
import 'package:BibleRead/classes/onboarding/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:BibleRead/models/slider.dart' as SliderModel;

class Configs {
  static Configs _instance;
  final List<SliderModel.Slider> slides;
  final Function onFinish;

  Configs(this.slides, this.onFinish);

  static Configs getInstance({List<SliderModel.Slider> slides,Function onFinish}) {
    if(_instance == null){
      _instance = Configs(slides,onFinish);
    }

    return _instance;
  }
}


class OnBoardingUi extends StatelessWidget{
  final List<SliderModel.Slider> slides;
  final Function onFinish;

  OnBoardingUi({@required this.slides, @required this.onFinish});

  @override
  Widget build(BuildContext context) {
    Configs.getInstance(slides: slides, onFinish: onFinish);

    return LandingPage();
  }

}
