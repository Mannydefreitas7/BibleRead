import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/onboarding/on_boarding_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/slider.dart' as SliderModel;

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingUi(

        slides:[
        SliderModel.Slider(
          sliderHeading: AppLocalizations.of(context).translate('welcome'),
          sliderSubHeading: AppLocalizations.of(context).translate('intro_page_one'),
          sliderImageUrl: 'assets/images/onboarding_welcome.png',
        ),
        SliderModel.Slider(
          sliderHeading: AppLocalizations.of(context).translate('intro_page_two_title'),
          sliderSubHeading: AppLocalizations.of(context).translate('intro_page_two'),
          sliderImageUrl: 'assets/images/onboarding_reading.png',
        ),
        SliderModel.Slider(
          
          sliderHeading: AppLocalizations.of(context).translate('intro_page_three_title'),
          sliderSubHeading: AppLocalizations.of(context).translate('intro_page_three'),
          sliderImageUrl: 'assets/images/onboarding_audio.png',
        ),
         SliderModel.Slider(
          
          sliderHeading: AppLocalizations.of(context).translate('intro_page_five_title'),
          sliderSubHeading: AppLocalizations.of(context).translate('intro_page_five'),
          sliderImageUrl: 'assets/images/onboarding_progress.png',
        ),
        SliderModel.Slider(
          
          sliderHeading: AppLocalizations.of(context).translate('intro_page_four_title'),
          sliderSubHeading: AppLocalizations.of(context).translate('intro_page_four'),
          sliderImageUrl: 'assets/images/onboarding_plan.png',
        )
      ], onFinish: (){
         // Your OnFinish code here
         Navigator.popAndPushNamed(context, '/today');
      }),
    );
  }
}
