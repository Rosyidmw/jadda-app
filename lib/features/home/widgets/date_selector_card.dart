import 'package:flutter/material.dart';
import 'package:jadda/core/constants/color_constant.dart';
import 'package:jadda/core/constants/font_constant.dart';

class DateSelectorCard extends StatelessWidget {
  final String gregorianDate;
  final String hijriDate;
  final VoidCallback onTap;

  const DateSelectorCard({
    super.key,
    required this.gregorianDate,
    required this.hijriDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              InkWell(
                onTap: onTap,
                borderRadius: .circular(8),
                child: Padding(
                  padding: .symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        gregorianDate,
                        style: FontConstant.h3.copyWith(
                          color: ColorConstant.textPrimary,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: ColorConstant.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2),
              Text(
                hijriDate,
                style: FontConstant.bodySmall.copyWith(
                  color: ColorConstant.textSecondary,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: onTap,
            icon: Icon(
              Icons.calendar_today,
              color: ColorConstant.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
