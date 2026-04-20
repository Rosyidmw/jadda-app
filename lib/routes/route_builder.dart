import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jadda/features/home/cubit/home_cubit.dart';
import 'package:jadda/features/home/screen/home_screen.dart';
import 'package:jadda/features/main/main_screen.dart';
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
    }
    return null;
  }
}
