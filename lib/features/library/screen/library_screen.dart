import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jadda/features/hadith/cubit/daily_hadith_cubit.dart';
import 'package:jadda/routes/route_path.dart';
import '../../../core/constants/color_constant.dart';
import '../../../core/constants/font_constant.dart';
import '../widgets/daily_hadith_card.dart';
import '../widgets/library_menu_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  void _showFullHadith(BuildContext context, hadith) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: .fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(
          color: ColorConstant.background,
          borderRadius: .vertical(top: .circular(24)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: .circular(10),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          hadith.takhrij,
                          style: FontConstant.caption.copyWith(
                            color: ColorConstant.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          hadith.grade,
                          style: FontConstant.caption.copyWith(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: .centerRight,
                      child: Text(
                        hadith.arab,
                        textDirection: TextDirection.rtl,
                        style: FontConstant.h1.copyWith(
                          color: ColorConstant.textPrimary,
                          fontSize: 26,
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Terjemahan:",
                      style: FontConstant.h3.copyWith(
                        color: ColorConstant.primary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      hadith.indo,
                      style: FontConstant.body.copyWith(
                        color: ColorConstant.textPrimary,
                        height: 1.5,
                      ),
                    ),

                    if (hadith.hikmah != null) ...[
                      SizedBox(height: 24),
                      Text(
                        "Hikmah:",
                        style: FontConstant.h3.copyWith(
                          color: ColorConstant.primary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        hadith.hikmah!,
                        style: FontConstant.bodyMedium.copyWith(
                          color: ColorConstant.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primary,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        elevation: 0,
        title: Text(
          "Khazanah Islam",
          style: FontConstant.h2.copyWith(
            color: ColorConstant.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Expanded(
            child: Container(
              width: .infinity,
              decoration: BoxDecoration(
                color: ColorConstant.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                padding: .all(24.0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    BlocBuilder<DailyHadithCubit, DailyHadithState>(
                      builder: (context, state) {
                        if (state is DailyHadithLoading ||
                            state is DailyHadithInitial) {
                          return Container(
                            height: 200,
                            alignment: .center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: .circular(16),
                            ),
                            child: CircularProgressIndicator(
                              color: ColorConstant.primary,
                            ),
                          );
                        } else if (state is DailyHadithError) {
                          return Container(
                            padding: .all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.wifi_off, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  state.message,
                                  style: FontConstant.bodySmall,
                                ),
                                TextButton(
                                  onPressed: () => context
                                      .read<DailyHadithCubit>()
                                      .getDailyHadith(),
                                  child: Text("Coba Lagi"),
                                ),
                              ],
                            ),
                          );
                        } else if (state is DailyHadithLoaded) {
                          return DailyHadithCard(
                            hadith: state.hadith,
                            onReadMore: () =>
                                _showFullHadith(context, state.hadith),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),

                    SizedBox(height: 32),
                    Text(
                      "Iqra",
                      style: FontConstant.h2.copyWith(
                        color: ColorConstant.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        LibraryMenuCard(
                          title: "Al-Qur'an",
                          subtitle: "114 Surah",
                          icon: Icons.menu_book,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutePath.quranListScreen,
                            );
                          },
                        ),
                        SizedBox(width: 16),
                        LibraryMenuCard(
                          title: "Hadis",
                          subtitle: "Kumpulan Kitab",
                          icon: Icons.library_books,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
