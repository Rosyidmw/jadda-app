import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jadda/features/home/widgets/date_picker_sheet.dart';
import 'package:jadda/features/home/widgets/date_selector_card.dart';
import 'package:jadda/features/home/widgets/schedule_item.dart';
import '../../../core/constants/color_constant.dart';
import '../cubit/home_cubit.dart';
import '../widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onKiblatTap;
  const HomeScreen({super.key, this.onKiblatTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primary, // Latar belakang dasar hijau
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(
              child: CircularProgressIndicator(color: ColorConstant.white),
            );
          } else if (state is HomeError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: ColorConstant.white),
              ),
            );
          } else if (state is HomeLoaded) {
            final currentSchedule = state.currentSchedule;
            final gregorianDate = currentSchedule?.tanggal ?? "Pilih Tanggal";
            final now = DateTime.now();
            final todayStr =
                "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
            final isToday = state.selectedDate == todayStr;
            final homeCubit = context.read<HomeCubit>();

            return SafeArea(
              bottom: false, // Biar bottom nav mengambil sisa area bawah
              child: Column(
                children: [
                  // 1. HEADER WIDGET
                  HomeHeader(
                    cityName: state.cityName,
                    activePrayer: state.activePrayer,
                    activePrayerTime: state.activePrayerTime,
                    countdown: state.countdown,
                    isToday: isToday,
                    onKiblatTap: onKiblatTap ?? () {},
                  ),

                  // 2. BODY WIDGET (Melengkung putih)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: ColorConstant.background,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          DateSelectorCard(
                            gregorianDate: gregorianDate,
                            hijriDate: state.hijriDate,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) => FractionallySizedBox(
                                  heightFactor: 0.6,
                                  child: DatePickerSheet(
                                    monthlySchedule: state.monthlySchedule,
                                    selectedDate: state.selectedDate,
                                    onDateSelected: (newDate) {
                                      homeCubit.changeSelectedDate(newDate);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          // Placeholder untuk Date Selector
                          Padding(
                            padding: .symmetric(horizontal: 24),
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                            ),
                          ),

                          // Placeholder untuk List Jadwal
                          Expanded(
                            child: currentSchedule != null
                                ? ListView(
                                    padding: .fromLTRB(24, 16, 24, 24),
                                    children: [
                                      ScheduleItem(
                                        name: "Imsak",
                                        time: currentSchedule.imsak,
                                        isActive:
                                            isToday &&
                                            state.activePrayer == "Imsak",
                                      ),
                                      ScheduleItem(
                                        name: "Subuh",
                                        time: currentSchedule.subuh,
                                        isActive:
                                            isToday &&
                                            state.activePrayer == "Subuh",
                                      ),
                                      ScheduleItem(
                                        name: "Dhuha",
                                        time: currentSchedule.dhuha,
                                        isActive:
                                            isToday &&
                                            state.activePrayer == "Dhuha",
                                      ),
                                      ScheduleItem(
                                        name: "Dzuhur",
                                        time: currentSchedule.dzuhur,
                                        isActive:
                                            isToday &&
                                            state.activePrayer == "Dzuhur",
                                      ),
                                      ScheduleItem(
                                        name: "Ashar",
                                        time: currentSchedule.ashar,
                                        isActive:
                                            isToday &&
                                            state.activePrayer == "Ashar",
                                      ),
                                      ScheduleItem(
                                        name: "Maghrib",
                                        time: currentSchedule.maghrib,
                                        isActive:
                                            isToday &&
                                            state.activePrayer == "Maghrib",
                                      ),
                                      ScheduleItem(
                                        name: "Isya",
                                        time: currentSchedule.isya,
                                        isActive:
                                            isToday &&
                                            state.activePrayer == "Isya",
                                      ),
                                    ],
                                  )
                                : Center(child: Text('Jadwal tidak tersedia!')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
