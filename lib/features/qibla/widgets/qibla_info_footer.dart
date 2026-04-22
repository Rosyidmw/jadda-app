import 'package:flutter/material.dart';
import 'package:jadda/core/constants/font_constant.dart';

class QiblaInfoFooter extends StatelessWidget {
  final double heading;
  final String directionName;
  final double? qiblaDirection;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  const QiblaInfoFooter({
    super.key,
    required this.heading,
    required this.directionName,
    required this.qiblaDirection,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                directionName,
                style: FontConstant.bodySmall.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                '${heading.toStringAsFixed(0)}°',
                style: FontConstant.h2.copyWith(color: Colors.white),
              ),
            ],
          ),

          Column(
            children: [
              Text(
                "Ka'ba",
                style: FontConstant.bodySmall.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 4),

              if (isLoading)
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              else if (errorMessage != null)
                InkWell(
                  onTap: onRetry,
                  child: Icon(Icons.refresh, color: Colors.redAccent, size: 28),
                )
              else if (qiblaDirection != null)
                Text(
                  "${qiblaDirection!.toStringAsFixed(3)}°",
                  style: FontConstant.h2.copyWith(color: Colors.white),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
