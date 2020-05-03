import 'package:BibleRead/classes/custom/app_localizations.dart';
import 'package:BibleRead/classes/onboarding/on_boarding_ui.dart';
import 'package:BibleRead/classes/onboarding/slide_item.dart';
import 'package:BibleRead/classes/onboarding/slide_dots.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SliderLayoutView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliderLayoutViewState();
}

class _SliderLayoutViewState extends State<SliderLayoutView> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: topSliderLayout()
      )
    );
  } 

  Widget topSliderLayout() {
    var slides = Configs.getInstance().slides;
    return Container(
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: slides.length,
                itemBuilder: (ctx, i) => SlideItem(slides, i),
              ),
              Stack(
                alignment: AlignmentDirectional.topStart,
                children: <Widget>[
                  Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
            
                          if (_currentPage != slides.lastIndexOf(slides.last)) {
                            _pageController.jumpToPage(_currentPage + 1);
                          } else {
                            Configs.getInstance().onFinish();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 15.0, bottom: 30.0),
                          child: Text(
                            _currentPage + 1 == slides.length
                                ? AppLocalizations.of(context).translate("done")
                                : AppLocalizations.of(context).translate("next"),
                                overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontFamily: 'Avenir Next',
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      )),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: GestureDetector(
                        onTap: () {
                          Configs.getInstance().onFinish();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0, bottom: 30.0),
                          child: _currentPage != 0 ? Text(
                            AppLocalizations.of(context).translate("skip"),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.caption.color,
                              fontFamily: 'Avenir Next',
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0,
                            ),
                          ) : null,
                        ),
                      )),
                  Container(
                    alignment: AlignmentDirectional.bottomCenter,
                    margin: EdgeInsets.only(bottom: 35.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       
                        for (int i = 0; i < slides.length; i++) 
                        
                          if (i == _currentPage)
                            SlideDots(true)
                          else
                            SlideDots(false)
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
