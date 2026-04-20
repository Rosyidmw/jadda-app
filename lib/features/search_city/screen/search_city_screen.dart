import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jadda/core/constants/color_constant.dart';
import 'package:jadda/core/constants/font_constant.dart';
import 'package:jadda/features/search_city/cubit/search_city_cubit.dart';
import 'package:jadda/features/search_city/services/local_storage_service.dart';

class SearchCityScreen extends StatelessWidget {
  const SearchCityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        iconTheme: IconThemeData(color: ColorConstant.white),
        title: Text(
          'Cari Kota / Kabupaten',
          style: FontConstant.h2.copyWith(
            color: ColorConstant.white,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: ColorConstant.white,
            padding: .all(16),
            child: TextField(
              onChanged: (value) {
                context.read<SearchCityCubit>().searchCity(value);
              },
              decoration: InputDecoration(
                hintText: "Contoh: Cimahi",
                hintStyle: FontConstant.bodyMedium.copyWith(
                  color: ColorConstant.textSecondary,
                ),
                prefixIcon: Icon(Icons.search, color: ColorConstant.primary),
                filled: true,
                fillColor: ColorConstant.background,
                border: OutlineInputBorder(
                  borderRadius: .circular(12),
                  borderSide: .none,
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<SearchCityCubit, SearchCityState>(
              builder: (context, state) {
                if (state is SearchCityLoading || state is SearchCityInitial) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.primary,
                    ),
                  );
                } else if (state is SearchCityError) {
                  return Center(child: Text(state.message));
                } else if (state is SearchCityLoaded) {
                  if (state.filteredCities.isEmpty) {
                    return Center(
                      child: Text(
                        "Kota tidak ditemukan",
                        style: FontConstant.body.copyWith(
                          color: ColorConstant.textSecondary,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: state.filteredCities.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      final city = state.filteredCities[index];

                      return ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                        ),
                        title: Text(city.location, style: FontConstant.body),
                        onTap: () async {
                          await LocalStorageService.saveCity(
                            city.id,
                            city.location,
                          );

                          if (context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                      );
                    },
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
