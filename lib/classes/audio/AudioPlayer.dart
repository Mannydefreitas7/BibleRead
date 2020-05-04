import 'package:BibleRead/classes/audio/AudioPlayerController.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BRAudioPlayer extends StatelessWidget {
  BRAudioPlayer({
    Key key,
      this.isReady, 
   // this.chapter, 
   // this.isSingle
    }) : super(key: key);
  final bool isReady;
  
  bool checkReadyandSingle() {
    var isSingle = AudioManager.instance.audioList.length <= 1;
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

 Widget songProgress(BuildContext context) {
   AudioPlayerController audioPlayerController = Provider.of<AudioPlayerController>(context);
    return Row(
      children: [
         Text(_formatDuration(audioPlayerController.position), 
         style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
            color: Theme.of(context).textTheme.headline6.color
            ),
         ),
        Expanded(
                  child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbColor: isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
                    overlayColor: isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
                    thumbShape: RoundSliderThumbShape(
                      disabledThumbRadius: 5,
                      enabledThumbRadius: 5,
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      overlayRadius: 10,
                    ),
                    activeTrackColor: isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
                    inactiveTrackColor: Theme.of(context).backgroundColor,
                  ),
                  child: Slider(
                    min: 0.0,
                    max: audioPlayerController.duration != null ? audioPlayerController.duration.inMilliseconds.toDouble() : 1.0,
                    value: audioPlayerController.position != null ? audioPlayerController.position.inMilliseconds.toDouble() : audioPlayerController.slider,
                    onChanged: (value) => audioPlayerController.onChanged(value),
                    onChangeEnd: (value) {
                      if (audioPlayerController.duration != null) {
                        Duration msec = Duration(
                            milliseconds: (audioPlayerController.duration.inMilliseconds * value).round());
                        AudioManager.instance.seekTo(msec);
                      }
                    },
                  )),
            ),
        ),
        Text(_formatDuration(audioPlayerController.duration), 
         style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
            color: Theme.of(context).textTheme.headline6.color
            ),
         ),
      ]);
  }

    String _formatDuration(Duration d) {
    if (d == null) return "00:00";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }

  Widget playerButtons(BuildContext context) {
    var currentIndex;
    var chapter = '';
    if (AudioManager.instance.isPlaying || AudioManager.instance.audioList.length != 0) {
      currentIndex = AudioManager.instance.curIndex != null ? AudioManager.instance.curIndex : 0;
      chapter = AudioManager.instance.audioList[currentIndex].title;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        CircleAvatar(
                radius: 15,
                backgroundColor: Theme.of(context).backgroundColor,
                child: IconButton(
          //  alignment: Alignment.center,
          padding: EdgeInsets.all(0),
            icon: Icon(Icons.chevron_left,
              color: checkReadyandSingle() ? Theme.of(context).disabledColor : Theme.of(context).textTheme.headline6.color,
              size: 20
            ),
            onPressed: () => {
              checkReadyandSingle() ? null : AudioManager.instance.previous()
            })),
            Text(
            chapter,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
                color: Theme.of(context).textTheme.headline6.color),
            ),
        
        CircleAvatar(
                radius: 15,
                backgroundColor: Theme.of(context).backgroundColor,
                child:IconButton(
           padding: EdgeInsets.all(0),
          alignment: Alignment.center,
            icon: Icon(Icons.chevron_right,
              color: checkReadyandSingle() ? Theme.of(context).disabledColor : Theme.of(context).textTheme.headline6.color,
              size: 20,
            ),
            onPressed:  () => checkReadyandSingle() ? null : AudioManager.instance.next()))
    ]);
  }

  @override
  Widget build(BuildContext context) {
     AudioPlayerController audioPlayerController = Provider.of<AudioPlayerController>(context);
   audioPlayerController.audioPlayerState();
    return Container(
      padding: EdgeInsets.symmetric(horizontal:20, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25)
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

                   CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).backgroundColor,
                    child: IconButton(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  alignment: Alignment.center,
                  icon: Icon(
                      audioPlayerController.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: isReady ? Theme.of(context).textTheme.headline6.color : Theme.of(context).disabledColor,
                    size: 40,
                  ),
                  onPressed: () async {
                      bool playing = await AudioManager.instance.playOrPause();
                      print("await -- $playing");
                  }),
                  ),

            Expanded(child: playerButtons(context)),
          ],
          ),
          SizedBox(height: 10),
          songProgress(context)
        ],
      ),
    );
  }
  }
