import 'dart:async';

import 'package:BibleRead/classes/ChapterAudio.dart';
import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:audio_service/audio_service.dart';

import 'package:just_audio/just_audio.dart';

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

void backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerController());
}


class AudioPlayerController extends BackgroundAudioTask {

  AudioPlayerController();
  double slider = 0.0;
  Duration position;
  Duration duration;
  int currentAudio = 0;
  List<AudioPlayerItem> list = [];
  AudioPlayer player = new AudioPlayer();
  bool isPlaying = false;
  bool isReady = false;
  bool isSingle = true;
  StreamSubscription eventSubscription;

  // get player => new AudioPlayer();


  initialize() async {
  
    list = await setupAudioList();
   // print(list);
    await player.setUrl(list[currentAudio].url);

    eventSubscription = player.playbackEventStream.listen((event) {
      final state = _stateToBasicState(event.state);
      print(state);
      if (state != BasicPlaybackState.stopped) {
        _setState(
          state: state,
          position: event.position.inMilliseconds,
        );
      }
    });
    
  }
  void _setState({BasicPlaybackState state, int position}) {
    if (position == null) {
      position = 0;
    }
    AudioServiceBackground.setState(
      controls: getControls(state),
      systemActions: [MediaAction.seekTo],
      basicState: state,
      position: position,
    );
  }

    BasicPlaybackState _stateToBasicState(AudioPlaybackState state) {
    switch (state) {
      case AudioPlaybackState.none:
        return BasicPlaybackState.none;
      case AudioPlaybackState.stopped:
        return BasicPlaybackState.stopped;
      case AudioPlaybackState.paused:
        return BasicPlaybackState.paused;
      case AudioPlaybackState.playing:
          isPlaying = true;
        return BasicPlaybackState.playing;
      case AudioPlaybackState.connecting:
        return BasicPlaybackState.connecting;
      case AudioPlaybackState.completed:
        return BasicPlaybackState.stopped;
      default:
        throw Exception("Illegal state");
    }
  }

  List<MediaControl> getControls(BasicPlaybackState state) {
    if (isPlaying) {
      return [
        skipToPreviousControl,
        pauseControl,
        stopControl,
        skipToNextControl
      ];
    } else {
      return [
        skipToPreviousControl,
        playControl,
        stopControl,
        skipToNextControl
      ];
    }
  }



  void releaseAudio() {
 /// await player.pause();

if (isPlaying) {
   AudioService.stop();
}
  eventSubscription.cancel();
}

void next() async {
  if (isPlaying) {
   // onStop();
   AudioService.stop();
  }
     currentAudio = currentAudio + 1;
     String url;
     if (currentAudio < list.length) {
          url = list[currentAudio].url;
            await player.setUrl(url);

          } else {
            currentAudio = 0;
            url = list[currentAudio].url;
            await player.setUrl(url);
     }
}

  bool get hasNext => currentAudio < list.length;

  bool get hasPrevious => currentAudio > 0;

   @override
  Future<void> onStart() async {
    await initialize();
  }
  @override
  void onStop() {
    stopAudio();
    _setState(state: BasicPlaybackState.stopped);
  }
  @override
  void onPlay() {
    playAudio();
  }
  @override
  void onPause() {
    pauseAudio();
  }
  @override
  void onClick(MediaButton button) {
  playPause();
  }
  @override
  onSkipToPrevious() {
    previous();
  }

   @override
  onSkipToNext() {
    next();
  }



  void previous() async {
    if(isPlaying) {
         AudioService.stop();
    }
     String url;
     if (currentAudio > 0) {
          currentAudio = currentAudio - 1;
          url = list[currentAudio].url;
            await player.setUrl(url);
          } else {
            currentAudio = 0;
            url = list[currentAudio].url;
            await player.setUrl(url);
     }

}


    void playPause() {
    if (AudioServiceBackground.state.basicState == BasicPlaybackState.playing)
      AudioService.pause();
    else
      AudioService.play();
  }

    @override
  void onSeekTo(int position) {
    onChangeEnd(Duration(milliseconds: position));
  }


  get playerDispose => player.dispose();

    Future<List<AudioPlayerItem>> setupAudioList() async {
    List<Plan> _unReadChapters = await DatabaseHelper().unReadChapters();
    int bookNumber = _unReadChapters[0].bookNumber;
    String bookName = _unReadChapters[0].longName;
    List<ChapterAudio> audios = await JwOrgApiHelper().getAudioFile(bookNumber);
    List chapters = getchapters(_unReadChapters[0].chapters);
    List<AudioPlayerItem> _audioInfos = [];

    
    audios.removeAt(0);
    audios.forEach((item) => {
      chapters.forEach((chapter) {
        if (item.title.split(' ')[1] == chapter) {
      _audioInfos.add(AudioPlayerItem(
        url: item.audioUrl,
        title: '$bookName - ${item.title}', 
        description: 'Playing from Bible Read',
        cover: 'https://assetsnffrgf-a.akamaihd.net/assets/m/1001061103/univ/art/1001061103_univ_sqs_lg.jpg')
        );
        }
      })
    });
    return _audioInfos;
  }

  List<String> getchapters(String chapters) {
  List<String> _chapters = [];
  List<String> tempChapters = chapters.split(' ');
  for (var i = int.parse(tempChapters.first); i <= int.parse(tempChapters.last) ; i++) {
    _chapters.add(i.toString());
  }
  return _chapters;
}

void playAudio() async  {

 AudioService.start( 
  backgroundTaskEntrypoint: backgroundTaskEntrypoint,
  androidNotificationChannelName: 'Music Player',
  androidNotificationIcon: "mipmap/ic_launcher",
);
 await player.play();
// AudioService.play();
}

void pauseAudio() async {
 await player.pause();
 isPlaying = true;
 // AudioService.pause();
}


void stopAudio() async {
  await player.stop();
  isPlaying = false;
 // AudioService.stop();
}

void onChangeEnd(Duration newPosition) async {
   await player.seek(newPosition);
   AudioService.seekTo(newPosition.inMilliseconds.toInt());
}



   String formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }
}


class AudioPlayerItem {

  final bool isPlaying;
  final String url;
  final String title;
  final String cover;
  final String description;

  AudioPlayerItem({
    this.isPlaying,
    this.url,
    this.title,
    this.description,
    this.cover,
  });
  
}
