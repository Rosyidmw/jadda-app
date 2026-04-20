import 'package:flutter/material.dart';
import 'package:jadda/core/constants/color_constant.dart';
import 'package:jadda/core/constants/font_constant.dart';
import 'package:jadda/features/home/model/daily_schedule_model.dart';

class DatePickerSheet extends StatelessWidget {
  final Map<String, DailyScheduleModel> monthlySchedule;
  final String selectedDate;
  final Function(String) onDateSelected;

  const DatePickerSheet({
    super.key,
    required this.monthlySchedule,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final entries = monthlySchedule.entries.toList();

    return Container(
      padding: .only(top: 16),
      decoration: BoxDecoration(
        color: ColorConstant.white,
        borderRadius: .vertical(top: .circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: .circular(4),
            ),
          ),

          SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final dateKey = entries[index].key;
                final schedule = entries[index].value;
                final isSelected = dateKey == selectedDate;

                return ListTile(
                  contentPadding: .symmetric(horizontal: 24),
                  tileColor: isSelected
                      ? ColorConstant.surface
                      : Colors.transparent,
                  title: Text(
                    schedule.tanggal,
                    style: FontConstant.body.copyWith(
                      color: isSelected
                          ? ColorConstant.primary
                          : ColorConstant.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: ColorConstant.primary)
                      : null,
                  onTap: () {
                    onDateSelected(dateKey);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
