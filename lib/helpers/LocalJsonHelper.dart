import 'dart:convert';
import 'dart:io';
import 'package:BibleRead/models/Plan.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class LocalJsonHelper {
  LocalJsonHelper();

  Future<String> getPlanData(int id, BuildContext context) {

    Future<String> assetPlan = DefaultAssetBundle.of(context)
                    .loadString('assets/json/plan_$id.json');

    return assetPlan;

  } 


}