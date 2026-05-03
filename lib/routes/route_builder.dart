import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jadda/features/library/screen/library_screen.dart';
import 'package:jadda/features/main/main_screen.dart';
import 'package:jadda/features/qibla/screen/qibla_screen.dart';
import 'package:jadda/features/quran/cubit/audio/audio_cubit.dart';
import 'package:jadda/features/quran/cubit/download/download_cubit.dart';
import 'package:jadda/features/quran/cubit/quran_list_cubit.dart';
import 'package:jadda/features/quran/screens/quran_list_screen.dart';
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

      case RoutePath.quranListScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => QuranListCubit()..getSurahList(),
              ),

              BlocProvider(create: (context) => AudioCubit()),
              BlocProvider(
                create: (context) => DownloadCubit()..checkDownloadedFiles(114),
              ),
            ],
            child: const QuranListScreen(),
          ),
        );
    }
    return null;
  }
}
