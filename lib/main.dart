import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jadda/core/constants/color_constant.dart';
import 'package:jadda/features/quran/cubit/bookmark/bookmark_cubit.dart';
import 'package:jadda/routes/route_builder.dart';
import 'package:jadda/routes/route_path.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookmarkCubit()..loadBookmark(),
      lazy: false,
      child: MaterialApp(
        title: 'Jadda',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: ColorConstant.primary,
            primary: ColorConstant.primary,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        initialRoute: RoutePath.splashScreen,
        onGenerateRoute: RouteBuilder.generate,
      ),
    );
  }
}
