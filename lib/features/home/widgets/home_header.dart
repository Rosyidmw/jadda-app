import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jadda/features/home/cubit/home_cubit.dart';
import 'package:jadda/features/search_city/cubit/search_city_cubit.dart';
import 'package:jadda/features/search_city/screen/search_city_screen.dart';
import '../../../core/constants/color_constant.dart';
import '../../../core/constants/font_constant.dart';

class HomeHeader extends StatelessWidget {
  final String cityName;
  final String activePrayer;
  final String activePrayerTime;
  final String countdown;
  final bool isToday;

  const HomeHeader({
    super.key,
    required this.cityName,
    required this.activePrayer,
    required this.activePrayerTime,
    required this.countdown,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(horizontal: 24.0, vertical: 32.0),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              InkWell(
                onTap: () async {
                  final bool? isCityChanged = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => SearchCityCubit()..loadAllCities(),
                        child: const SearchCityScreen(),
                      ),
                    ),
                  );

                  if (isCityChanged == true && context.mounted) {
                    context.read<HomeCubit>().loadHomeData();
                  }
                },
                borderRadius: .circular(4),
                child: Padding(
                  padding: .symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        cityName,
                        style: FontConstant.bodyMedium.copyWith(
                          color: ColorConstant.white,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: ColorConstant.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                isToday ? activePrayer : "Jadwal Salat",
                style: FontConstant.h2.copyWith(color: ColorConstant.white),
              ),

              Text(
                isToday ? activePrayerTime : "Sesuai tanggal pilihan",
                style: FontConstant.caption.copyWith(
                  color: ColorConstant.surface,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(
                    Icons.explore,
                    color: ColorConstant.white,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Kompas",
                    style: FontConstant.bodySmall.copyWith(
                      color: ColorConstant.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: Colors.black.withOpacity(0.1),
              border: Border.all(color: ColorConstant.textPrimary, width: 6),
            ),
            child: Center(
              child: isToday
                  ? Text(
                      countdown,
                      style: FontConstant.h3.copyWith(
                        color: ColorConstant.white,
                      ),
                    )
                  : Text(
                      "Jadwal\nLain",
                      textAlign: .center,
                      style: FontConstant.bodySmall.copyWith(
                        color: ColorConstant.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
