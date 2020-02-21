import 'package:BibleRead/components/progressCard.dart';
import 'package:BibleRead/helpers/JwOrgApiHelper.dart';
import 'package:BibleRead/helpers/LocalDataBase.dart';
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/helpers/animations.dart';
import 'package:BibleRead/models/Plan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProgressViewCard extends StatefulWidget {



  const ProgressViewCard({Key key}) : super(key: key);

  @override
  _ProgressViewCardState createState() => _ProgressViewCardState();
}

class _ProgressViewCardState extends State<ProgressViewCard> {

  double progressNumber;

  @override
  void initState() { 
    super.initState();
  }


void refresh() {
    setState(() {});
  }
  

    double _countProgressValue(progressData) {
       List _allDays;
  
          _allDays = progressData.data;  
          List _isReadDays = _allDays.where((i) => i['IsRead'] == 1).toList();
          final expo = 100 / _allDays.toList().length;
          final double endValue = (_isReadDays.length * expo) / 100;
        return endValue;
  }

  

  List _getUnReadDays(AsyncSnapshot progressData) {
      List _allDays = progressData.data;   
      List _isReadDays = _allDays.where((i) => i['IsRead'] == 0).toList();

      return _isReadDays;
  }

    String _getUnReadDaysBookName(AsyncSnapshot progressData, AsyncSnapshot bibleData) {
      List _allDays = progressData.data;   
      List _isReadDays = _allDays.where((i) => i['IsRead'] == 0).toList();

      return bibleData.data['${_isReadDays[0]['BookNumber']}']['standardName'];
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: JwOrgApiHelper().getBibleBooks().asStream(),
      builder: (context, bibleBook) {
  
          return StreamBuilder(

            stream: SharedPrefs().getSelectedPlan().asStream(),
            builder: (context, selectedPlan) {


                return StreamBuilder(
                stream: DatabaseHelper().queryPlan(selectedPlan.data).asStream(),
                builder: (context, progress) {
       
                   if (selectedPlan.hasData && bibleBook.hasData && progress.hasData) {
                      double progressNumber = _countProgressValue(progress);

                  

                  return Container(
                  child: ProgressCard(subtitle: 'Current', progressNumber: progressNumber, textOne: '', textTwo: _getUnReadDaysBookName(progress, bibleBook), textThree: _getUnReadDays(progress)[0]['Chapters']),
                  height: 110,
            );
            } else {

                return Shimmer.fromColors(
                  
            child: Container(
                  child: ProgressCard(subtitle: 'Current', progressNumber: 1, textOne: '', textTwo: '', textThree: ''),
                  height: 110,
            ),
            baseColor: Theme.of(context).backgroundColor, 
            highlightColor: Colors.white);
          }
      }
    );

              

            }
          );
        
      }
    );

    
    
    
    
  }
}

