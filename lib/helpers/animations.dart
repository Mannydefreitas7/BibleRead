import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import '../classes/progressCircle.dart';

class FadeInRight extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeInRight(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateX").add(
          Duration(milliseconds: 500), Tween(begin: 130.0, end: 0.0),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => 
      Opacity(
            opacity: animation["opacity"],
            child: Transform.translate(
                offset: Offset(animation["translateX"], 0), child: child),
          ),
    );
  }
}

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;
 
  FadeIn({this.delay, this.child});

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
            opacity: animation["opacity"],
            child: child,
          ),
    );
  }
}

class AnimatedProgressCircle extends StatelessWidget {

  final double endValue;
  final double radiusWidth;
  final double lineWidth;
  final double fontSize;

  AnimatedProgressCircle({this.endValue, this.radiusWidth, this.fontSize, this.lineWidth});

  @override
  Widget build(BuildContext context) {
    return ProgressCircle(
          progressNumber: endValue, 
          progressText: '${(endValue * 100).round()}%', radiusWidth: radiusWidth,
          lineWidth: lineWidth,
          fontSize: fontSize,
    );
  }
}


class AnimatedReadingPlan extends StatelessWidget {

  final String planImage;
  AnimatedReadingPlan({this.planImage});


  @override
  Widget build(BuildContext context) {
    final tween = Tween<double>(
      begin: 0.0, end: 60.0
    );


    return ControlledAnimation(
      duration: Duration(milliseconds: 800),
      tween: tween,
      curve: Curves.fastOutSlowIn,
      builder: (context, animatedSize) {
        return 
        
        Container(
             width: animatedSize,
             height: animatedSize,
             decoration: new BoxDecoration(
              
             //  color: const Color(0xff7c94b6),
               image: new DecorationImage(

                 image: AssetImage(planImage),
                 fit: BoxFit.cover,
               ),
               borderRadius: BorderRadius.all(Radius.circular(50)),
            //  shape: BoxShape.circle,
               border: new Border.all(
                 color: Theme.of(context).accentColor,
                 width: 5.0,
               ),
             ),
            
           );
      },
    );
  }
}
