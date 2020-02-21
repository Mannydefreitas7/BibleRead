import 'package:flutter/material.dart';

class AudioWaveNotPlaying extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        Container(
          height: 10.0,
          width: double.infinity,
          color: Theme.of(context).accentColor.withOpacity(0.2)
        ),

        Container(
          height: 10.0,
          width: double.infinity,
          color: Theme.of(context).accentColor.withOpacity(0.5)
        ),

      ],
    );
  }
}