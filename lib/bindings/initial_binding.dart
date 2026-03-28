import 'package:get/get.dart';
import '../controllers/connectivity_controller.dart';
import '../controllers/webview_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectivityController>(
      ConnectivityController(),
      permanent: true,
    );
    Get.lazyPut<WebViewController2>(() => WebViewController2());
  }
}
