import 'package:flutter/material.dart';
import 'package:jadda/core/constants/color_constant.dart';
import 'package:jadda/core/constants/font_constant.dart';

class ScheduleItem extends StatelessWidget {
  final String name;
  final String time;
  final bool isActive;
  final bool isNotificationOn;

  const ScheduleItem({
    super.key,
    required this.name,
    required this.time,
    this.isActive = false,
    this.isNotificationOn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(bottom: 8),
      padding: .symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isActive ? ColorConstant.surface : Colors.transparent,
        borderRadius: .circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: FontConstant.h3.copyWith(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? ColorConstant.primary
                    : ColorConstant.textPrimary,
              ),
            ),
          ),
          Text(
            time,
            style: FontConstant.h3.copyWith(
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive
                  ? ColorConstant.primary
                  : ColorConstant.textPrimary,
            ),
          ),

          SizedBox(width: 24),

          Icon(
            isNotificationOn ? Icons.volume_up : Icons.volume_off,
            color: isActive
                ? ColorConstant.primary
                : ColorConstant.textSecondary.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}
