import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';

class NetworkProvider {

  StreamSubscription<ConnectivityResult> _subscription;
  StreamController<Map<ConnectivityResult, bool>> _networkStatusController;

  StreamSubscription<ConnectivityResult> get subscription => _subscription;
  StreamController<Map<ConnectivityResult, bool>> get networkStatusController => _networkStatusController;

  NetworkProvider() {
    _networkStatusController = StreamController<Map<ConnectivityResult, bool>>();
    _invokeNetworkStatusListen();
  }

     bool isConnected(_source) {
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
    _networkStatusController.sink.add({result: isOnline});
  }

 void _invokeNetworkStatusListen() async {

   _checkStatus(await Connectivity().checkConnectivity());

   _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) { 
     _checkStatus(result);
   });
  }

  void disposeStream() {
    _subscription.cancel();
    _networkStatusController.close();
  }

}
