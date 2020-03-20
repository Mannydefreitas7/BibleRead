// import 'package:flutter/material.dart';

// class SliderAudio extends StatefulWidget {
//   final Duration duration;
//   final Duration position;
//   final bool isReady;
//   final ValueChanged<Duration> onChanged;
//   final ValueChanged<Duration> onChangeEnd;

//   SliderAudio({
//     @required this.duration,
//     @required this.position,
//     this.onChanged,
//     this.isReady,
//     this.onChangeEnd,
//   });

//   @override
//   _SliderAudioState createState() => _SliderAudioState();
// }

// class _SliderAudioState extends State<SliderAudio> {
//   double _dragValue;

//   @override
//   Widget build(BuildContext context) {

//      double seekPos;
//          return  StreamBuilder(
//           stream: Rx.combineLatest2<double, double, double>(
//               _dragPositionSubject.stream,
//               Stream.periodic(Duration(milliseconds: 200)),
//               (dragPosition, _) => dragPosition),
//           builder: (context, snapshot) {
//             double position = snapshot.data ?? state.currentPosition.toDouble();
//             double duration = mediaItem?.duration?.toDouble();
          
//           double slider = position.inMilliseconds / duration.inMilliseconds;
//             if (duration != null)


//     return Padding(
//             padding: EdgeInsets.all(15),
//             child: SliderTheme(
//                 data: SliderTheme.of(context).copyWith(
//                   trackHeight: 3,
//                   thumbColor: widget.isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
//                   overlayColor: widget.isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
//                   thumbShape: RoundSliderThumbShape(
//                     disabledThumbRadius: 5,
//                     enabledThumbRadius: 7,
//                   ),
//                   overlayShape: RoundSliderOverlayShape(
//                     overlayRadius: 10,
//                   ),
//                   activeTrackColor: widget.isReady ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
//                   inactiveTrackColor: Theme.of(context).backgroundColor,
//                 ),
//                 child: Slider(
//       min: 0.0,
//       max: widget.duration.inMilliseconds.toDouble(),
//       value: _dragValue ?? widget.position.inMilliseconds.toDouble(),
//       onChanged: (value) {
//         setState(() {
//           _dragValue = value;
//         });
//         if (widget.onChanged != null) {
//           widget.onChanged(Duration(milliseconds: value.round()));
//         }
//       },
//       onChangeEnd: (value) {
//         _dragValue = null;
//         if (widget.onChangeEnd != null) {
//           widget.onChangeEnd(Duration(milliseconds: value.round()));
//         }
//       },
//     )));
//   }
// }
