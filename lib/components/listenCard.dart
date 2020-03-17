import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'audioWave.dart';
import 'audioWaveNotPlaying.dart';
import '../helpers/animations.dart';
import 'package:audio_manager/audio_manager.dart';

class ListenCard extends StatelessWidget  {

  ListenCard({
    this.isAudioPlaying,
    this.startTime,
    this.durationText,
    this.duration,
    this.slider,
    this.bookName,
    this.chapter,
    this.next,
    this.playPause,
    this.previous,
    this.isReady,
    this.sliderChange
    });

    bool isAudioPlaying;
    final bool isReady;
    final String startTime;
    final String durationText;
    final Duration duration;
    final double slider;
    final String bookName;
    final String chapter;
    final Function playPause;
    final Function next;
    final Function previous;
    final Function sliderChange;

    List<String> getchapters(String chapters) {
  List<String> _chapters = [];
  List<String> tempChapters = chapters.split(' ');
  for (var i = int.parse(tempChapters.first); i <= int.parse(tempChapters.last) ; i++) {
    _chapters.add(i.toString());
  }
  return _chapters;
}

  Widget songProgress(BuildContext context) {
      return Padding(
            padding: EdgeInsets.all(15),
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbColor: isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
                  overlayColor: isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
                  thumbShape: RoundSliderThumbShape(
                    disabledThumbRadius: 5,
                    enabledThumbRadius: 7,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 10,
                  ),
                  activeTrackColor: isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
                  inactiveTrackColor: Theme.of(context).backgroundColor,
                ),
                child: Slider(
                  value: slider ?? 0,
                  onChanged: sliderChange,
                  onChangeEnd: (value) {
                    if (duration != null) {
                      Duration msec = Duration(
                          milliseconds:
                              (duration.inMilliseconds * value).round());
                      AudioManager.instance.seekTo(msec);
                    }
                  },
                )),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text('Listen',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: Theme.of(context).textTheme.title.fontWeight,
                  fontSize: 22.0,
                  color: Theme.of(context).textTheme.title.color)),
        ),
        Card(
          elevation: 0.0,
          clipBehavior: Clip.hardEdge,
          borderOnForeground: false,
          color: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  
                  children: <Widget>[
                    Icon(
                      LineAwesomeIcons.headphones,
                      color: Theme.of(context).textTheme.title.color,
                      ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      bookName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                          color: Theme.of(context).textTheme.title.color),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      chapter,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                          color: Theme.of(context).textTheme.title.color),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20, bottom:30, left:0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            SimpleLineIcons.arrow_left,
                            color: isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
                            size: 35,
                          ),
                          onPressed: () => isReady ? AudioManager.instance.previous() : null),
                      IconButton(
                          icon: Icon(
                            isAudioPlaying ? SimpleLineIcons.control_pause : SimpleLineIcons.control_play,
                            color: isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
                            size: 35,
                          ),
                          onPressed: () {
                            return isReady ? AudioManager.instance.playOrPause() : null;
                          }),
                      IconButton(
                          icon: Icon(
                            SimpleLineIcons.arrow_right,
                            color: isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
                            size: 35,
                          ),
                          onPressed: () => AudioManager.instance.next())
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  )
                  ),

              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                fit: StackFit.loose,
                children: <Widget>[

                  songProgress(context),

                Container(
                  padding: EdgeInsets.only(bottom: 40, left: 20, right: 20),
                  child: Row(children: <Widget>[

                    Text(startTime, style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      color: Theme.of(context).textTheme.title.color
                      ),
                    ),

                    Spacer(),

                    Text(durationText, style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                       color: Theme.of(context).textTheme.title.color
                      ),
                    ),

                  ],
                ),
              )

            ],
          )

            ],
          ),
        ),
      ],
    );
  }
}
