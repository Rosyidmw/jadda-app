import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:jadda/core/constants/font_constant.dart';

class QiblaCompassDial extends StatelessWidget {
  final double heading;
  final double? qiblaDirection;
  final Color surfaceColor;

  const QiblaCompassDial({
    super.key,
    required this.heading,
    required this.qiblaDirection,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    final compassAngle = (heading * (math.pi / 180) * -1);

    return Center(
      child: Stack(
        alignment: .center,
        children: [
          Container(
            width: 310,
            height: 310,
            decoration: BoxDecoration(
              shape: .circle,
              color: Colors.black.withOpacity(0.05),
            ),
          ),

          Transform.rotate(
            angle: compassAngle,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: .circle,
                gradient: RadialGradient(
                  colors: [
                    surfaceColor.withOpacity(0.2),
                    surfaceColor.withOpacity(0.8),
                  ],
                ),
                border: Border.all(color: surfaceColor, width: 4),
              ),
              child: Stack(
                alignment: .center,
                children: [
                  for (int i = 0; i < 360; i += 15)
                    Transform.rotate(
                      angle: i * math.pi / 180,
                      child: Align(
                        alignment: .topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: i % 90 == 0 ? 4 : 2,
                          height: i % 90 == 0 ? 12 : 8,
                          color: i % 90 == 0 ? Colors.white : Colors.white54,
                        ),
                      ),
                    ),

                  Positioned(
                    top: 20,
                    child: Text(
                      "N",
                      style: FontConstant.h2.copyWith(color: Colors.redAccent),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: Text(
                      "S",
                      style: FontConstant.h2.copyWith(color: Colors.white),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    child: Text(
                      "E",
                      style: FontConstant.h2.copyWith(color: Colors.white),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    child: Text(
                      "W",
                      style: FontConstant.h2.copyWith(color: Colors.white),
                    ),
                  ),

                  if (qiblaDirection != null)
                    Transform.rotate(
                      angle: (qiblaDirection! * (math.pi / 180)),
                      child: Align(
                        alignment: .topCenter,
                        child: Container(
                          margin: .only(top: 25),
                          child: Container(
                            padding: .all(8),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: .circular(8),
                              border: .all(color: Colors.amber, width: 2),
                            ),
                            child: Icon(
                              Icons.mosque,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: .circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
