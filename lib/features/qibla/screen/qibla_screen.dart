import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:jadda/features/qibla/widgets/qibla_compass_dial.dart';
import 'package:jadda/features/qibla/widgets/qibla_info_footer.dart';
import '../../../core/constants/font_constant.dart';
import '../cubit/qibla_cubit.dart';

class QiblaScreenWrapper extends StatelessWidget {
  const QiblaScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QiblaCubit()..getLocationAndQibla(),
      child: const QiblaScreen(),
    );
  }
}

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  final Color qiblaBgColor = const Color(0xFF2A593A);
  final Color qiblaSurfaceColor = const Color(0xFF4C8C5C);

  String _getDirectionName(double heading) {
    if (heading >= 337.5 || heading < 22.5) return "Utara";
    if (heading >= 22.5 && heading < 67.5) return "Timur Laut";
    if (heading >= 67.5 && heading < 112.5) return "Timur";
    if (heading >= 112.5 && heading < 157.5) return "Tenggara";
    if (heading >= 157.5 && heading < 202.5) return "Selatan";
    if (heading >= 202.5 && heading < 247.5) return "Barat Daya";
    if (heading >= 247.5 && heading < 292.5) return "Barat";
    if (heading >= 292.5 && heading < 337.5) return "Barat Laut";
    return "Utara";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: qiblaBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Kiblat",
          style: FontConstant.h2.copyWith(color: Colors.white, fontSize: 18),
        ),
      ),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Gagal membaca sensor",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          double? rawHeading = snapshot.data?.heading;
          if (rawHeading == null) {
            return const Center(
              child: Text(
                "Tidak ada sensor kompas",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          double heading = (rawHeading % 360 + 360) % 360;
          String directionName = _getDirectionName(heading);

          return BlocBuilder<QiblaCubit, QiblaState>(
            builder: (context, state) {
              double? qiblaDirection;
              bool isLoading = state is QiblaLoading || state is QiblaInitial;
              String? errorMessage = state is QiblaError ? state.message : null;

              if (state is QiblaLoaded) {
                qiblaDirection = state.qiblaData.direction;
              }

              return Column(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Spacer(flex: 1),

                  QiblaCompassDial(
                    heading: heading,
                    qiblaDirection: qiblaDirection,
                    surfaceColor: qiblaSurfaceColor,
                  ),

                  SizedBox(height: 32),

                  Text(
                    directionName,
                    style: FontConstant.h2.copyWith(
                      color: Colors.white70,
                      fontSize: 24,
                    ),
                  ),

                  Text(
                    "${heading.toStringAsFixed(0)}°",
                    style: FontConstant.h1.copyWith(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  Spacer(flex: 2),

                  Container(
                    margin: .symmetric(horizontal: 24),
                    height: 1,
                    color: Colors.white24,
                  ),

                  QiblaInfoFooter(
                    heading: heading,
                    directionName: directionName,
                    qiblaDirection: qiblaDirection,
                    isLoading: isLoading,
                    errorMessage: errorMessage,
                    onRetry: () =>
                        context.read<QiblaCubit>().getLocationAndQibla(),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
