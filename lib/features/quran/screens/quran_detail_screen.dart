import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jadda/features/quran/cubit/bookmark/bookmark_cubit.dart';
import 'package:jadda/features/quran/model/bookmark_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../core/constants/color_constant.dart';
import '../../../core/constants/font_constant.dart';
import '../cubit/detail/quran_detail_cubit.dart';
import '../widgets/ayah_card.dart';

class QuranDetailScreen extends StatefulWidget {
  final int surahNumber;
  final int? bookmarkedAyah;

  const QuranDetailScreen({
    super.key,
    required this.surahNumber,
    this.bookmarkedAyah,
  });

  @override
  State<QuranDetailScreen> createState() => _QuranDetailScreenState();
}

class _QuranDetailScreenState extends State<QuranDetailScreen> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  bool _hasScrolledToBookmark = false;

  @override
  void initState() {
    super.initState();

    if (widget.bookmarkedAyah != null) {
      context.read<QuranDetailCubit>().loadUpToAyah(
        widget.surahNumber,
        widget.bookmarkedAyah!,
      );
    } else {
      context.read<QuranDetailCubit>().getSurahDetail(widget.surahNumber);
    }

    _itemPositionsListener.itemPositions.addListener(() {
      final positions = _itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final maxVisibleIndex = positions
            .map((e) => e.index)
            .reduce((max, current) => max > current ? max : current);

        final currentState = context.read<QuranDetailCubit>().state;

        if (currentState is QuranDetailLoaded) {
          if (maxVisibleIndex >= currentState.ayahs.length - 2) {
            context.read<QuranDetailCubit>().getSurahDetail(
              widget.surahNumber,
              isLoadMore: true,
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorConstant.white),
        title: BlocBuilder<QuranDetailCubit, QuranDetailState>(
          builder: (context, state) {
            if (state is QuranDetailLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.surahName,
                    style: FontConstant.h2.copyWith(
                      color: ColorConstant.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    state.translation,
                    style: FontConstant.caption.copyWith(
                      color: ColorConstant.surface,
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      body: BlocBuilder<QuranDetailCubit, QuranDetailState>(
        builder: (context, state) {
          if (state is QuranDetailLoading || state is QuranDetailInitial) {
            return const Center(
              child: CircularProgressIndicator(color: ColorConstant.primary),
            );
          } else if (state is QuranDetailError) {
            return Center(child: Text(state.message, style: FontConstant.body));
          } else if (state is QuranDetailLoaded) {
            if (widget.bookmarkedAyah != null &&
                !_hasScrolledToBookmark &&
                state.ayahs.isNotEmpty) {
              // Cari tahu ada di indeks ke berapa target ayat kita
              final targetIndex = state.ayahs.indexWhere(
                (a) => a.ayahNumber == widget.bookmarkedAyah,
              );

              if (targetIndex != -1) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _itemScrollController.scrollTo(
                    index: targetIndex,
                    duration: const Duration(
                      milliseconds: 800,
                    ), // Animasi 0.8 detik
                    curve: Curves.easeInOutCubic,
                  );
                });
                _hasScrolledToBookmark =
                    true; // Kunci agar tidak terpanggil ulang
              }
            }

            return ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
              itemCount: state.ayahs.length + 1,
              itemBuilder: (context, index) {
                if (index == state.ayahs.length) {
                  if (state.isFetchingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorConstant.primary,
                        ),
                      ),
                    );
                  } else if (state.isLastPage && widget.surahNumber < 114) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: ColorConstant.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Lanjut ke Surat Berikutnya",
                          style: FontConstant.button.copyWith(
                            color: ColorConstant.primary,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox(height: 32);
                  }
                }

                return BlocBuilder<BookmarkCubit, BookmarkState>(
                  builder: (context, bookmarkState) {
                    bool isBookmarked = false;
                    if (bookmarkState is BookmarkLoaded &&
                        bookmarkState.bookmark != null) {
                      final b = bookmarkState.bookmark!;

                      if (b.surahNumber == widget.surahNumber &&
                          b.ayahNumber == state.ayahs[index].ayahNumber) {
                        isBookmarked = true;
                      }
                    }

                    return AyahCard(
                      ayah: state.ayahs[index],
                      isBookmarked: isBookmarked,
                      onBookmarkTap: () {
                        if (isBookmarked) {
                          context.read<BookmarkCubit>().removeBookmark();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('🔖 Penanda dihapus'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          final bookmark = BookmarkModel(
                            surahNumber: widget.surahNumber,
                            surahName: state.surahName,
                            ayahNumber: state.ayahs[index].ayahNumber,
                          );
                          context.read<BookmarkCubit>().saveBookmark(bookmark);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '🔖 Ditandai pada ${state.surahName} Ayat ${state.ayahs[index].ayahNumber}',
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: ColorConstant.primary,
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
