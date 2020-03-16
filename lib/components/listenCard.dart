import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'audioWave.dart';
import 'audioWaveNotPlaying.dart';
import '../helpers/animations.dart';

class ListenCard extends StatelessWidget  {

  ListenCard({
    this.isAudioPlaying,
    this.startTime,
    this.durationText,
    this.duration,
    this.position,
    this.bookName,
    this.chapter,
    this.next,
    this.playPause,
    this.previous
    });

    final bool isAudioPlaying;
    final String startTime;
    final String durationText;
    final double duration;
    final double position;
    final String bookName;
    final String chapter;
    final Function playPause;
    final Function next;
    final Function previous;


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
                            color: Theme.of(context).accentColor,
                            size: 35,
                          ),
                          onPressed: () => print('')),
                      IconButton(
                          icon: Icon(
                            isAudioPlaying ? SimpleLineIcons.control_pause : SimpleLineIcons.control_play,
                            color: Theme.of(context).accentColor,
                            size: 35,
                          ),
                          onPressed: playPause),
                      IconButton(
                          icon: Icon(
                            SimpleLineIcons.arrow_right,
                            color: Theme.of(context).accentColor,
                            size: 35,
                          ),
                          onPressed: () => print(''))
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  )
                  ),

              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                fit: StackFit.loose,
                children: <Widget>[

                LinearPercentIndicator(
                   progressColor: Theme.of(context).accentColor,
                   percent: duration,
                   backgroundColor: Colors.transparent,
                ),

                Container(
                  padding: EdgeInsets.all(15.0),
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
