import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocalJsonHelper {
  LocalJsonHelper();

  Future<String> getPlanData(int id, BuildContext context) {

    Future<String> assetPlan = DefaultAssetBundle.of(context)
                    .loadString('assets/json/plan_$id.json');

    return assetPlan;

  } 


}
