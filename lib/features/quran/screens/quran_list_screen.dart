import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jadda/features/quran/cubit/audio/audio_cubit.dart';
import 'package:jadda/features/quran/cubit/download/download_cubit.dart';
import 'package:jadda/features/quran/widgets/last_read_card.dart';
import 'package:jadda/routes/route_path.dart';
import '../../../core/constants/color_constant.dart';
import '../../../core/constants/font_constant.dart';
import '../cubit/quran_list_cubit.dart';
import '../widgets/surah_list_tile.dart';

class QuranListScreen extends StatelessWidget {
  const QuranListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primary,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        elevation: 0,
        title: Text(
          "Al-Qur'an",
          style: FontConstant.h2.copyWith(
            color: ColorConstant.white,
            fontSize: 20,
          ),
        ),

        iconTheme: IconThemeData(color: ColorConstant.white),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Expanded(
            child: Container(
              width: .infinity,
              decoration: BoxDecoration(
                color: ColorConstant.background,
                borderRadius: .vertical(top: .circular(32)),
              ),
              child: ClipRRect(
                borderRadius: .vertical(top: .circular(32)),
                child: BlocBuilder<QuranListCubit, QuranListState>(
                  builder: (context, state) {
                    if (state is QuranListLoading ||
                        state is QuranListInitial) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstant.primary,
                        ),
                      );
                    } else if (state is QuranListError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: .center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.redAccent,
                            ),
                            SizedBox(height: 16),
                            Text(state.message, style: FontConstant.body),
                            TextButton(
                              onPressed: () =>
                                  context.read<QuranListCubit>().getSurahList(),
                              child: Text("Coba Lagi"),
                            ),
                          ],
                        ),
                      );
                    } else if (state is QuranListLoaded) {
                      final surahs = state.surahs;
                      return Column(
                        children: [
                          LastReadCard(),
                          Expanded(
                            child: BlocBuilder<AudioCubit, AudioState>(
                              builder: (context, audioState) {
                                return ListView.separated(
                                  padding: .only(top: 16, bottom: 32),
                                  itemCount: surahs.length,
                                  separatorBuilder: (context, index) => Divider(
                                    color: Colors.grey.shade200,
                                    height: 1,
                                    indent: 24,
                                    endIndent: 24,
                                  ),
                                  itemBuilder: (context, index) {
                                    final surah = surahs[index];

                                    return BlocBuilder<
                                      DownloadCubit,
                                      DownloadState
                                    >(
                                      builder: (context, downloadState) {
                                        final isDownloaded = downloadState
                                            .downloadedSurahs
                                            .contains(surah.number);
                                        final downloadProgress = downloadState
                                            .downloadingProgress[surah.number];

                                        bool isPlaying = false;
                                        bool isLoading = false;

                                        if (audioState is AudioPlaying &&
                                            audioState.surahNumber ==
                                                surah.number) {
                                          isPlaying = true;
                                        } else if (audioState is AudioLoading &&
                                            audioState.surahNumber ==
                                                surah.number) {
                                          isLoading = true;
                                        }

                                        return SurahListTile(
                                          surah: surah,
                                          isPlaying: isPlaying,
                                          isLoading: isLoading,
                                          isDownloaded: isDownloaded,
                                          downloadProgress: downloadProgress,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              RoutePath.quranDetailScreen,
                                              arguments: {
                                                'surahNumber': surah.number,
                                              },
                                            );
                                            print(
                                              "Buka Surat: ${surah.nameLatin} surah ke-${surah.number}",
                                            );
                                          },
                                          onPlayTap: () {
                                            context
                                                .read<AudioCubit>()
                                                .playAudio(
                                                  surah.number,
                                                  surah.audioUrl,
                                                  isDownloaded: isDownloaded,
                                                );
                                          },
                                          onDownloadTap: () {
                                            if (!isDownloaded &&
                                                downloadProgress == null) {
                                              context
                                                  .read<DownloadCubit>()
                                                  .downloadSurah(
                                                    surah.number,
                                                    surah.audioUrl,
                                                  );
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
