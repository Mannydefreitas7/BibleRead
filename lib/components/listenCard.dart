import 'dart:math';

import 'package:BibleRead/classes/AudioController.dart';
import 'package:BibleRead/classes/AudioServiceController.dart';
import 'package:BibleRead/classes/SliderAudio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:rxdart/rxdart.dart';



class ListenCard extends StatefulWidget {
  final bool isReady;
  ListenCard({this.isReady});

  @override
  _ListenCardState createState() => new _ListenCardState();
}

class _ListenCardState extends State<ListenCard> {
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);

  @override
  void initState() {
    super.initState();
   // initialize();
     initialize();
  }



  @override
  void dispose() {
    super.dispose();
  }


  initialize() async => {

  await AudioService.start(
            backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
            androidNotificationChannelName: 'Music Player',
            notificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
            enableQueue: true,
          )
  };


  @override
  Widget build(BuildContext context) {
   // initialize();
 
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
          StreamBuilder<ScreenState>(
              stream: Rx.combineLatest3<List<MediaItem>, MediaItem,
                      PlaybackState, ScreenState>(
                  AudioService.queueStream,
                  AudioService.currentMediaItemStream,
                  AudioService.playbackStateStream,
                  (queue, mediaItem, playbackState) =>
                      ScreenState(queue, mediaItem, playbackState)),
              builder: (context, snapshot) {

                if (snapshot.hasData) {

                final screenState = snapshot.data;
                final queue = screenState?.queue;
                final mediaItem = screenState?.mediaItem;
                final state = screenState?.playbackState;
                final basicState = state?.basicState ?? BasicPlaybackState.none;
                print(queue);
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (queue != null && queue.isNotEmpty)
                        Card(
                            elevation: 0.0,
                            clipBehavior: Clip.hardEdge,
                            borderOnForeground: false,
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Column(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 15, bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      LineAwesomeIcons.headphones,
                                      color: Theme.of(context)
                                          .textTheme
                                          .title
                                          .color,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      mediaItem.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.0,
                                          color: Theme.of(context)
                                              .textTheme
                                              .title
                                              .color),
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.0,
                                          color: Theme.of(context)
                                              .textTheme
                                              .title
                                              .color),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 30, left: 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(
                                            SimpleLineIcons.arrow_left,
                                            color: widget.isReady ||
                                                    mediaItem != queue.last
                                                ? Theme.of(context).accentColor
                                                : Theme.of(context)
                                                    .disabledColor,
                                            size: 35,
                                          ),
                                          onPressed: mediaItem == queue.first
                                              ? null
                                              : AudioService.skipToPrevious),
                                      if (basicState ==
                                          BasicPlaybackState.playing)
                                        pauseButton()
                                      else if (basicState ==
                                              BasicPlaybackState.paused ||
                                          basicState == BasicPlaybackState.none)
                                        playButton(),
                                      IconButton(
                                          icon: Icon(
                                            SimpleLineIcons.arrow_right,
                                            color: widget.isReady ||
                                                    mediaItem != queue.last
                                                ? Theme.of(context).accentColor
                                                : Theme.of(context)
                                                    .disabledColor,
                                            size: 35,
                                          ),
                                          onPressed: mediaItem == queue.last
                                              ? null
                                              : AudioService.skipToNext)
                                    ],
                                  )),
                            ]))
                    ]);
                } else {

                 return Container(
                    child: Center(child: CircularProgressIndicator())
                  );

                }
              }),
            
        ]);
  }

  IconButton playButton() => IconButton(
        icon: Icon(SimpleLineIcons.control_play),
        color: widget.isReady
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
        iconSize: 35.0,
        onPressed: () => {
         
          AudioService.play(),
          //  setState(() {})
        },
      );

  IconButton pauseButton() => IconButton(
        icon: Icon(SimpleLineIcons.control_pause),
        iconSize: 35.0,
        color: widget.isReady
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
        onPressed: AudioService.pause,
      );

  Widget positionIndicator(MediaItem mediaItem, PlaybackState state) {
    double seekPos;
    return StreamBuilder(
      stream: Rx.combineLatest2<double, double, double>(
          _dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 200)),
          (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        double position = snapshot.data ?? state.currentPosition.toDouble();
        double duration = mediaItem?.duration?.toDouble();
        return Column(
          children: [
            //  if (duration != null)
            Slider(
              min: 0.0,
              max: duration,
              value: seekPos ?? max(0.0, min(position, duration)),
              onChanged: (value) {
                _dragPositionSubject.add(value);
              },
              onChangeEnd: (value) {
                AudioService.seekTo(value.toInt());
                // Due to a delay in platform channel communication, there is
                // a brief moment after releasing the Slider thumb before the
                // new position is broadcast from the platform side. This
                // hack is to hold onto seekPos until the next state update
                // comes through.
                // TODO: Improve this code.
                seekPos = value;
                _dragPositionSubject.add(null);
              },
            ),
            Text("${(state.currentPosition / 1000).toStringAsFixed(3)}"),
          ],
        );
      },
    );
  }
}

class ScreenState {
  final List<MediaItem> queue;
  final MediaItem mediaItem;
  final PlaybackState playbackState;

  ScreenState(this.queue, this.mediaItem, this.playbackState);
}
void _audioPlayerTaskEntrypoint() async {
  await AudioServiceBackground.run(() => AudioPlayerTask());
}

