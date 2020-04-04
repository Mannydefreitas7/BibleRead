import 'package:BibleRead/classes/SliderAudio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


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
    this.position,
    this.playPause,
    this.previous,
    this.isSingle,
    this.isReady,
    this.sliderChange
    });

    final bool isAudioPlaying;
    final bool isReady;
    final bool isSingle;
    final String startTime;
    final String durationText;
    final Duration duration;
    final Duration position;
    final double slider;
    final String bookName;
    final String chapter;
    final Function playPause;
    final Function next;
    final Function previous;
    final Function sliderChange;


bool checkReadyandSingle() {
  
  if (isReady == true) {
    if (isSingle == true) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
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
                  fontWeight: Theme.of(context).textTheme.headline6.fontWeight,
                  fontSize: 22.0,
                  color: Theme.of(context).textTheme.headline6.color)),
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
                      color: Theme.of(context).textTheme.headline6.color,
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
                          color: Theme.of(context).textTheme.headline6.color),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      chapter,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                          color: Theme.of(context).textTheme.headline6.color),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10, bottom:20, left:0),
                  child: Row(

                    mainAxisSize: MainAxisSize.max,
                    
                    children: <Widget>[
                      IconButton(
                        alignment: Alignment.center,
                          icon: Icon(
                            SFSymbols.chevron_left,
                            color: checkReadyandSingle() ? Theme.of(context).disabledColor : Theme.of(context).accentColor,
                            size: 40,
                          ),
                          onPressed: previous),
                      IconButton(
                        alignment: Alignment.center,
                          icon: Icon(
                            isAudioPlaying ? SFSymbols.pause : SFSymbols.play,
                            color: isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
                            size: 40,
                          ),
                          onPressed: playPause),
                      IconButton(
                        alignment: Alignment.center,

                          icon: Icon(
                            SFSymbols.chevron_right,
                            color: checkReadyandSingle() ? Theme.of(context).disabledColor : Theme.of(context).accentColor,
                            size: 40,
                          ),
                          onPressed: next)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  )
                ),

              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                fit: StackFit.loose,
                children: <Widget>[

                  SliderAudio(
                    
                    isReady: isReady,
                    duration: duration, 
                    onChanged: sliderChange,
                    position: position
                    ),

                Container(
                  padding: EdgeInsets.only(bottom: 40, left: 20, right: 20),
                  child: Row(children: <Widget>[

                    Text(isReady ? startTime : '00:00', style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      color: Theme.of(context).textTheme.headline6.color
                      ),
                    ),

                    Spacer(),

                    Text(isReady ? durationText : '00:00', style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                       color: Theme.of(context).textTheme.headline6.color
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
