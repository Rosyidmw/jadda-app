import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jadda/features/home/widgets/date_selector_card.dart';
import 'package:jadda/features/home/widgets/schedule_item.dart';
import '../../../core/constants/color_constant.dart';
import '../cubit/home_cubit.dart';
import '../widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

            return SafeArea(
              bottom: false, // Biar bottom nav mengambil sisa area bawah
              child: Column(
                children: [
                  // 1. HEADER WIDGET
                  HomeHeader(cityName: state.cityName),

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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Fitur ganti tanggal akan segera hadir!',
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
                                      ),
                                      ScheduleItem(
                                        name: "Subuh",
                                        time: currentSchedule.subuh,
                                      ),
                                      ScheduleItem(
                                        name: "Dhuha",
                                        time: currentSchedule.dhuha,
                                      ),
                                      ScheduleItem(
                                        name: "Dzuhur",
                                        time: currentSchedule.dzuhur,
                                        isActive: true,
                                      ),
                                      ScheduleItem(
                                        name: "Ashar",
                                        time: currentSchedule.ashar,
                                      ),
                                      ScheduleItem(
                                        name: "Maghrib",
                                        time: currentSchedule.maghrib,
                                      ),
                                      ScheduleItem(
                                        name: "Isya",
                                        time: currentSchedule.isya,
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
