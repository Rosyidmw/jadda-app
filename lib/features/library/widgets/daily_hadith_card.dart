import 'package:flutter/material.dart';
import 'package:jadda/features/hadith/model/hadith_model.dart';
import '../../../core/constants/color_constant.dart';
import '../../../core/constants/font_constant.dart';

class DailyHadithCard extends StatelessWidget {
  final HadithModel hadith;
  final VoidCallback onReadMore;

  const DailyHadithCard({
    super.key,
    required this.hadith,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(20),
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
          Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_stories,
                    color: ColorConstant.primary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Hadis Hari Ini",
                    style: FontConstant.h3.copyWith(
                      color: ColorConstant.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12),
              Flexible(
                child: Container(
                  padding: .symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    hadith.takhrij,
                    textAlign: .center,
                    style: FontConstant.caption.copyWith(
                      color: Colors.orange[800],
                      fontWeight: .bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          Align(
            alignment: .centerRight,
            child: Text(
              hadith.arab,
              textDirection: TextDirection.rtl,
              maxLines: 2,
              style: FontConstant.h2.copyWith(
                color: ColorConstant.textPrimary,
                fontSize: 22,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 12),

          Text(
            hadith.indo,
            maxLines: 3,
            overflow: .ellipsis,
            style: FontConstant.bodyMedium.copyWith(
              color: ColorConstant.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),

          SizedBox(
            width: .infinity,
            child: OutlinedButton(
              onPressed: onReadMore,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: ColorConstant.primary),
                shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                padding: .symmetric(vertical: 12),
              ),
              child: Text(
                "Baca Selengkapnya",
                style: FontConstant.button.copyWith(
                  color: ColorConstant.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
