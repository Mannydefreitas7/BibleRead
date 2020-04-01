import 'package:BibleRead/classes/ChapterAudio.dart';
import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/models/Plan.dart';

import 'package:just_audio/just_audio.dart';


class AudioPlayerController {

  AudioPlayerController();
  AudioPlayer player;
  double slider = 0.0;
  Duration position;
  Duration duration;
  List<AudioPlayerItem> list;
  int currentAudio = 0;



  initialize() async {
    list = await setupAudioList();
    player = AudioPlayer();
    print(list[0].url);
    await player.setUrl(list[currentAudio].url);
  }


  get playerDispose => player.dispose();

    Future<List<AudioPlayerItem>> setupAudioList() async {
    List<Plan> _unReadChapters = await DatabaseHelper().unReadChapters();
    int bookNumber = _unReadChapters[0].bookNumber;
    String bookName = _unReadChapters[0].longName;
    List<ChapterAudio> audios = await JwOrgApiHelper().getAudioFile(bookNumber);
    List<String> chapters = getchapters(_unReadChapters[0].chapters);
    List<AudioPlayerItem> audioInfos = [];

    audios.forEach((item) => {
      chapters.forEach((chapter) {

        if ('${item.bibleChapterNumber}' == chapter) {

      audioInfos.add(AudioPlayerItem(
        url: item.audioUrl,
        title: '$bookName - ${item.title}', 
        description: 'Playing from Bible Read',
        cover: 'https://assetsnffrgf-a.akamaihd.net/assets/m/1001061103/univ/art/1001061103_univ_sqs_lg.jpg')
        );

        }

      })
    });
    return audioInfos;
  }

  List<String> getchapters(String chapters) {
  List<String> _chapters = [];
  List<String> tempChapters = chapters.split(' ');
  for (var i = int.parse(tempChapters.first); i <= int.parse(tempChapters.last) ; i++) {
    _chapters.add(i.toString());
  }
  return _chapters;
}

void playAudio() async {
 await player.play();
}

void pauseAudio() async {
 await player.pause();
}

void stopAudio() async {
  await player.stop();
}

void releaseAudio() async {
  await player.pause();
  await player.dispose();
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

class AudioPositionStreamModel {

  Duration position;

}

class AudioStateStreamModel {

  AudioPlayer player = AudioPlayerController().player;

}

class AudioDurationStreamModel {

  AudioPlayer player = AudioPlayerController().player;

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
