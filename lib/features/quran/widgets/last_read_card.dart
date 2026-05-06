import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/color_constant.dart';
import '../../../core/constants/font_constant.dart';
import '../../../routes/route_path.dart';
import '../cubit/bookmark/bookmark_cubit.dart';

class LastReadCard extends StatelessWidget {
  const LastReadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (context, state) {
        if (state is BookmarkLoaded && state.bookmark != null) {
          final bookmark = state.bookmark!;

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RoutePath.quranDetailScreen,
                arguments: {
                  'surahNumber': bookmark.surahNumber,
                  'bookmarkedAyah': bookmark.ayahNumber,
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorConstant.primary,
                    ColorConstant.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: ColorConstant.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu_book, color: Colors.white, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🔖 Terakhir Dibaca",
                          style: FontConstant.bodySmall.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bookmark.surahName,
                          style: FontConstant.h2.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Ayat ${bookmark.ayahNumber}",
                          style: FontConstant.bodySmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
