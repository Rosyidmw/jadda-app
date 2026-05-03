import 'package:flutter/material.dart';
import 'package:jadda/core/constants/color_constant.dart';
import 'package:jadda/core/constants/font_constant.dart';

class LibraryMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const LibraryMenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(16),
        child: Container(
          padding: .all(16),
          decoration: BoxDecoration(
            color: ColorConstant.white,
            borderRadius: .circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Container(
                padding: .all(12),
                decoration: BoxDecoration(
                  color: ColorConstant.surface,
                  shape: .circle,
                ),
                child: Icon(icon, color: ColorConstant.primary, size: 28),
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: FontConstant.h3.copyWith(
                  color: ColorConstant.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: FontConstant.bodySmall.copyWith(
                  color: ColorConstant.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
