import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityCheck extends ChangeNotifier {
  ConnectivityCheck._internal();

  static final ConnectivityCheck _instance = ConnectivityCheck._internal();

  static ConnectivityCheck get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }



    bool isConnected(Map _source) {
      bool isConnected;
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.none:
          isConnected = false;
          break;
        case ConnectivityResult.mobile:
          isConnected = true;
          break;
        case ConnectivityResult.wifi:
        isConnected = true;
      }
      return isConnected;
    }
    

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
