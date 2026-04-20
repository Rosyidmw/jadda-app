import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../constants/color_constant.dart';
import '../constants/font_constant.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstant.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: ColorConstant.primary,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: ColorConstant.surface,
            color: ColorConstant.textSecondary,
            textStyle: FontConstant.button.copyWith(
              color: ColorConstant.primary,
            ),
            tabs: const [
              GButton(icon: Icons.access_time_filled, text: 'Salat'),
              GButton(icon: Icons.explore, text: 'Kiblat'),
              GButton(icon: Icons.menu_book, text: 'Qur\'an'),
              GButton(icon: Icons.person, text: 'Profil'),
            ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}
