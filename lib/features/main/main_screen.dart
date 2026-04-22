import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jadda/features/home/cubit/home_cubit.dart';
import 'package:jadda/features/home/screen/home_screen.dart';
import 'package:jadda/features/qibla/screen/qibla_screen.dart';
import '../../../core/widgets/custom_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      BlocProvider(
        create: (context) => HomeCubit()..loadHomeData(),
        child: HomeScreen(
          onKiblatTap: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        ),
      ),

      QiblaScreenWrapper(),

      Center(child: Text("Halaman Qur'an")),

      Center(child: Text("Halaman Profil")),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
