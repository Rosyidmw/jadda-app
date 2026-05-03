import 'package:flutter/material.dart';
import '../../../core/constants/color_constant.dart';
import '../../../core/constants/font_constant.dart';
import '../model/surah_model.dart';

class SurahListTile extends StatelessWidget {
  final SurahModel surah;
  final VoidCallback onTap;
  final VoidCallback onPlayTap;
  final VoidCallback onDownloadTap;
  final bool isPlaying;
  final bool isLoading;
  final bool isDownloaded;
  final double? downloadProgress;

  const SurahListTile({
    super.key,
    required this.surah,
    required this.onTap,
    required this.onPlayTap,
    required this.onDownloadTap,
    this.isPlaying = false,
    this.isLoading = false,
    this.isDownloaded = false,
    this.downloadProgress,
  });

  Widget _buildDownloadIcon() {
    if (isDownloaded) {
      return Padding(
        padding: .all(8.0),
        child: Icon(Icons.check_circle, color: ColorConstant.primary, size: 24),
      );
    } else if (downloadProgress != null) {
      return Padding(
        padding: .all(8.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: downloadProgress,
            color: ColorConstant.primary,
            strokeWidth: 2.5,
          ),
        ),
      );
    } else {
      return IconButton(
        onPressed: onDownloadTap,
        icon: Icon(
          Icons.cloud_download_outlined,
          color: ColorConstant.textSecondary,
          size: 24,
        ),
        tooltip: "Unduh Audio",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: .symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: ColorConstant.surface,
                shape: .circle,
              ),
              child: Center(
                child: Text(
                  surah.number.toString(),
                  style: FontConstant.h3.copyWith(color: ColorConstant.primary),
                ),
              ),
            ),
            SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    surah.nameLatin,
                    style: FontConstant.h3.copyWith(
                      color: ColorConstant.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    surah.translation,
                    style: FontConstant.bodySmall.copyWith(
                      color: ColorConstant.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${surah.revelation} • ${surah.numberOfAyahs} Ayat",
                    style: FontConstant.bodySmall.copyWith(
                      color: ColorConstant.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                _buildDownloadIcon(),

                IconButton(
                  onPressed: isLoading ? null : onPlayTap,
                  icon: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: ColorConstant.primary,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: ColorConstant.primary,
                          size: 36,
                        ),
                  tooltip: isPlaying ? "Jeda Audio" : "Putar Audio",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
