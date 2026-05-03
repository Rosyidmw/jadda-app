import 'package:flutter/material.dart';
import 'package:jadda/features/library/screen/library_screen.dart';
import 'package:jadda/features/main/main_screen.dart';
import 'package:jadda/features/qibla/screen/qibla_screen.dart';
import 'package:jadda/features/splash/splash_screen.dart';
import 'package:jadda/routes/route_path.dart';

class RouteBuilder {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.splashScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SplashScreen(),
        );

      case RoutePath.mainScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainScreen(),
        );

      case RoutePath.qiblaScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => QiblaScreenWrapper(),
        );

      case RoutePath.libraryScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LibraryScreen(),
        );
    }
    return null;
  }
}
