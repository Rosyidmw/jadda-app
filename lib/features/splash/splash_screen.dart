import 'package:flutter/material.dart';
import 'package:jadda/core/constants/color_constant.dart';
import 'package:jadda/core/constants/font_constant.dart';
import 'package:jadda/core/constants/image_constant.dart';
import 'package:jadda/routes/route_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutePath.mainScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Image.asset(ImageConstant.logo, width: 150),
                SizedBox(height: 12),
                Text(
                  "Jadda",
                  style: FontConstant.h1.copyWith(color: ColorConstant.primary),
                ),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: SafeArea(
              child: Text(
                "Dibuat oleh Rotibowif Dev",
                textAlign: .center,
                style: FontConstant.caption.copyWith(
                  color: ColorConstant.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
