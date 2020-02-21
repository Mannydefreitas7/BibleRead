import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter/material.dart';
class AudioWave extends StatefulWidget {
  @override
  _AudioWaveState createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  @override
  Widget build(BuildContext context) {
    return  WaveWidget(
                    
    config: CustomConfig(
        colors: [
            Theme.of(context).accentColor.withOpacity(0.1),
            Theme.of(context).accentColor.withOpacity(0.2),
            Theme.of(context).accentColor.withOpacity(0.3),
            Theme.of(context).accentColor.withOpacity(0.4),
        ],
        durations: [3000, 5000, 8000, 10000],
        heightPercentages: [0.2, 0.6, .4, .8],
 
    ),
    waveAmplitude: 10.0, 

    duration: 6000,
    waveFrequency: 3.4,
    backgroundColor: Colors.transparent,
    size: Size(double.infinity, double.infinity),
);
  }
}