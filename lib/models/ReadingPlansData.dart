
import 'package:BibleRead/helpers/SharedPrefs.dart';
import 'package:BibleRead/models/ReadingPlan.dart';
import 'package:flutter/material.dart';

class ReadingPlansData extends ChangeNotifier {

  int selectedPlan;
  List<ReadingPlans> readingPlans;
  
  ReadingPlansData() {
    SharedPrefs().getSelectedPlan().then((value) => selectedPlan = value);
  }

  selectReadingPlan(int id) async {
    selectedPlan = id;
    await SharedPrefs().setSelectedPlan(id);
    notifyListeners();
  }

}