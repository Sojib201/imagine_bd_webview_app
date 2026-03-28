import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/app.dart';
import '../app/constants.dart';
import '../controllers/connectivity_controller.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final net = Get.find<ConnectivityController>();

    ever(net.isConnected, (connected) {
      if (connected) Get.offNamed(Routes.webview);
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A2540), Color(0xFF0D3461)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.wifi_off_rounded,
                    size: 55, color: Colors.white70),
              ),
              const SizedBox(height: 28),
              const Text(
                'No internet connection!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  'Internet connection is required to watch Imagine BD.\nTurn on WiFi or Mobile Data.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 14,
                      height: 1.6),
                ),
              ),
              const SizedBox(height: 44),
              ElevatedButton.icon(
                onPressed: () {
                  if (net.isConnected.value) {
                    Get.offNamed(Routes.webview);
                  } else {
                    Get.snackbar('No connection', 'Internet still not available',
                        backgroundColor: Colors.red.shade700,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16));
                  }
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => Text(
                    net.isConnected.value
                        ? '✅ Connection found...'
                        : '⏳ Waiting for connection...',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.55), fontSize: 13),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
