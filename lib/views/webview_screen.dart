import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../app/constants.dart';
import '../controllers/webview_controller.dart';
import '../controllers/connectivity_controller.dart';
import '../widgets/error_view.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<WebViewController2>();
    final net = Get.find<ConnectivityController>();

    return Obx(() {
      if (!net.isConnected.value) {
        return _OfflineScaffold(onRetry: ctrl.reload);
      }

      return PopScope(
        canPop: false,
        onPopInvoked: (_) async {
          final shouldExit = await ctrl.handleBackPress();
          if (shouldExit) _showExitDialog();
        },
        child: Scaffold(
          appBar: _buildAppBar(ctrl),
          body: Stack(
            children: [
              Obx(() => ctrl.hasError.value
                  ? ErrorView(onRetry: ctrl.reload)
                  : WebViewWidget(controller: ctrl.webViewController)),

              Obx(() {
                if (!ctrl.isLoading.value) return const SizedBox.shrink();
                return LinearProgressIndicator(
                  value: ctrl.loadingProgress.value > 0
                      ? ctrl.loadingProgress.value / 100
                      : null,
                  minHeight: 3,
                  backgroundColor: Colors.transparent,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.accent),
                );
              }),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(ctrl),
        ),
      );
    });
  }

  PreferredSizeWidget _buildAppBar(WebViewController2 ctrl) {
    return AppBar(
      backgroundColor: AppColors.primary,
      title: Column(
        children: [
          const Text(
            'Imagine BD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          Obx(() => Text(
                _trimUrl(ctrl.currentUrl.value),
                style:
                    TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 11),
              )),
        ],
      ),
      centerTitle: true,
      actions: [
        Obx(() => ctrl.isLoading.value
            ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: ctrl.reload,
              )),
      ],
    );
  }

  Widget _buildBottomBar(WebViewController2 ctrl) {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: AppColors.navBar,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, -2))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavBtn(icon: Icons.home_rounded, enabled: true, onTap: ctrl.loadHome),
          Obx(() => _NavBtn(
            icon: Icons.arrow_back_ios_rounded,
            enabled: ctrl.canGoBack.value,
            onTap: ctrl.goBack,
          )),
          Obx(() => _NavBtn(
            icon: Icons.arrow_forward_ios_rounded,
            enabled: ctrl.canGoForward.value,
            onTap: ctrl.goForward,
          )),
        ],
      ),
    );
  }

  void _showExitDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Close the app?'),
        content: const Text('Want to exit the Imagine BD app?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('No')),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  String _trimUrl(String url) => url
      .replaceAll('https://', '')
      .replaceAll('http://', '')
      .replaceAll('www.', '');
}

class _OfflineScaffold extends StatelessWidget {
  final VoidCallback onRetry;
  const _OfflineScaffold({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagine BD'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 20),
              const Text('No internet connection',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Turn on WiFi or Mobile Data.',
                  style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavBtn(
      {required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon,
          color: enabled ? Colors.white : Colors.white30, size: 22),
      onPressed: enabled ? onTap : null,
    );
  }
}
