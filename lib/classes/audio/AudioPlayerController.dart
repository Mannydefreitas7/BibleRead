
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';

class AudioPlayerController extends ChangeNotifier {

  bool isPlaying = false;
  Duration duration;
  Duration position;
  double slider = 0.0;
  double sliderVolume;
  num curIndex = 0;


  final list = [
  
    {
      "title": "network",
      "desc": "network resouce playback",
      "url": "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.m4a",
      "coverUrl": "https://homepages.cae.wisc.edu/~ece533/images/airplane.png"
    },
    {
      "title": "Genesis",
      "desc": "",
      "url": "https://download-a.akamaihd.net/files/media_publication/f8/nwt_01_Ge_E_01.mp3",
      "coverUrl": "https://homepages.cae.wisc.edu/~ece533/images/airplane.png"
    }
  ];


  PlayMode playMode = AudioManager.instance.playMode;
  

   Widget getPlayModeIcon(PlayMode playMode) {
    switch (playMode) {
      case PlayMode.sequence:

        return Icon(
          Icons.repeat,
          color: Colors.black,
        );
        
      case PlayMode.shuffle:
   
        return Icon(
          Icons.shuffle,
          color: Colors.black,
        );
      case PlayMode.single:

        return Icon(
          Icons.repeat_one,
          color: Colors.black,
        );
    } 
    notifyListeners();
    return Container();
  }

  void audioPlayerState() {
     AudioManager.instance.onEvents((events, args) {

      switch (events) {
        case AudioManagerEvents.start:
  
          position = AudioManager.instance.position;
          duration = AudioManager.instance.duration;
          slider = 0;
          print('Duration is: $duration');
          notifyListeners();
          break;
        case AudioManagerEvents.ready:

          sliderVolume = AudioManager.instance.volume;
          position = AudioManager.instance.position;
          duration = AudioManager.instance.duration;
          
          notifyListeners();
          // if you need to seek times, must after AudioManagerEvents.ready event invoked
          // AudioManager.instance.seekTo(Duration(seconds: 10));
          break;
        case AudioManagerEvents.seekComplete:
          position = AudioManager.instance.position;
          slider = position.inMilliseconds / duration.inMilliseconds;
          notifyListeners();
          break;
        case AudioManagerEvents.buffering:
          notifyListeners();
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = AudioManager.instance.isPlaying;
          notifyListeners();
          break;
        case AudioManagerEvents.timeupdate:
          position = AudioManager.instance.position;
          slider = position.inMilliseconds / duration.inMilliseconds;
            notifyListeners();
          break;
        case AudioManagerEvents.error:
          notifyListeners();
          break;
        case AudioManagerEvents.ended:
          AudioManager.instance.next();
          notifyListeners();
          break;
        case AudioManagerEvents.volumeChange:
          sliderVolume = AudioManager.instance.volume;
          notifyListeners();
          break;
        default:
          break;
      }
    });
  }

  onChanged(value) {
    this.slider = value;
    notifyListeners();
  }

}

