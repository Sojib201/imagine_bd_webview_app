import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  final _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _sub;

  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkNow();
    _sub = _connectivity.onConnectivityChanged.listen(_update);
  }

  Future<void> _checkNow() async {
    final result = await _connectivity.checkConnectivity();
    _update(result);
  }

  void _update(List<ConnectivityResult> results) {
    isConnected.value = results.any((r) => r != ConnectivityResult.none);
  }

  @override
  void onClose() {
    _sub.cancel();
    super.onClose();
  }
}
