import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/on_boarding_ui.dart';
import '../models/slider.dart' as SliderModel;

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingUi(

        slides:[
        SliderModel.Slider(
          sliderHeading: "Welcome",
          sliderSubHeading: "Bible Read is a bible reading progress tracking application to help you keep up with your daily reading",
          sliderImageUrl: 'assets/images/onboarding_welcome.png',
        ),
        SliderModel.Slider(
          sliderHeading: "Read in-app",
          sliderSubHeading: "You can read the respective bible chapters online right in the app!",
          sliderImageUrl: 'assets/images/onboarding_reading.png',
        ),
        SliderModel.Slider(
          
          sliderHeading: "Listen the audio",
          sliderSubHeading: "Not in the mood for reading? You can also listen audio for the day.",
          sliderImageUrl: 'assets/images/onboarding_audio.png',
        ),
         SliderModel.Slider(
          
          sliderHeading: "Track your progress",
          sliderSubHeading: "Adjust the app progress to yours. Check how far you’ve gone or set a reading start date.",
          sliderImageUrl: 'assets/images/onboarding_progress.png',
        ),
        SliderModel.Slider(
          
          sliderHeading: "Choose a plan",
          sliderSubHeading: "Adjust the app progress to yours. Check how far you’ve gone or set a reading start date.",
          sliderImageUrl: 'assets/images/onboarding_plan.png',
        )
      ], onFinish: (){
         // Your OnFinish code here
         Navigator.popAndPushNamed(context, '/today');
      }),
    );
  }
}
