import 'package:flutter/material.dart';
import '../../../core/constants/color_constant.dart';
import '../../../core/constants/font_constant.dart';
import '../model/ayah_model.dart';

class AyahCard extends StatelessWidget {
  final AyahModel ayah;
  final VoidCallback onBookmarkTap;
  final bool isBookmarked;

  const AyahCard({
    super.key,
    required this.ayah,
    required this.onBookmarkTap,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: ColorConstant.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: ColorConstant.surface,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  ayah.ayahNumber.toString(),
                  style: FontConstant.caption.copyWith(
                    color: ColorConstant.primary,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onBookmarkTap,
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                      color: isBookmarked
                          ? ColorConstant.primary
                          : ColorConstant.textSecondary,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share_outlined,
                      color: ColorConstant.textSecondary,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.play_arrow_outlined,
                      color: ColorConstant.textSecondary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            ayah.arab,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: FontConstant.h1.copyWith(
              color: ColorConstant.textPrimary,
              fontSize: 26,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 24),

          Text(
            ayah.translation,
            style: FontConstant.bodyMedium.copyWith(
              color: ColorConstant.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
