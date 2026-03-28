import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bindings/initial_binding.dart';
import '../views/splash_screen.dart';
import '../views/webview_screen.dart';
import '../views/no_internet_screen.dart';
import 'constants.dart';

class ImagineBdApp extends StatelessWidget {
  const ImagineBdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialBinding: InitialBinding(),
      initialRoute: Routes.splash,
      getPages: [
        GetPage(name: Routes.splash, page: () => const SplashScreen()),
        GetPage(name: Routes.webview, page: () => const WebViewScreen()),
        GetPage(name: Routes.noInternet, page: () => const NoInternetScreen()),
      ],
    );
  }
}

abstract class Routes {
  static const splash = '/';
  static const webview = '/webview';
  static const noInternet = '/no-internet';
}
