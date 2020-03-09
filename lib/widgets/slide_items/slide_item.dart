import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../models/slider.dart' as SliderModel;


class SlideItem extends StatelessWidget {
  final List<SliderModel.Slider> slides;

  final int index;

  const SlideItem(this.slides, this.index);


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width * 0.8,
          width: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(slides[index].sliderImageUrl))),
        ),
        SizedBox(
          height: 60.0,
        ),
        Text(
          slides[index].sliderHeading,
          textAlign: TextAlign.center,
          style: TextStyle(
            
             color: Theme.of(context).textTheme.title.color,
            fontFamily: 'Avenir Next',
            fontWeight: FontWeight.w700,
            fontSize: 34,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              slides[index].sliderSubHeading,
              style: TextStyle(
                color: Theme.of(context).textTheme.caption.color,
                fontFamily: 'Avenir Next',
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
