import 'package:jadda/features/home/model/daily_schedule_model.dart';

class TimeService {
  static DateTime _parseTime(String timeStr) {
    final now = DateTime.now();
    final parts = timeStr.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  static Map<String, String> getCurrentAndNextPrayer(
    DailyScheduleModel schedule,
  ) {
    final now = DateTime.now();

    final Map<String, String> rawTimes = {
      "Imasak": schedule.imsak,
      "Subuh": schedule.subuh,
      "Dhuha": schedule.dhuha,
      "Dzuhur": schedule.dzuhur,
      "Ashar": schedule.ashar,
      "Maghrib": schedule.maghrib,
      "Isya": schedule.isya,
    };

    String activePrayer = "Isya";
    String activePrayerTime = schedule.isya;
    DateTime? nextPrayerTime;

    final entries = rawTimes.entries.toList();

    for (int i = 0; i < entries.length; i++) {
      final prayerDateTime = _parseTime(entries[i].value);
      if (now.isBefore(prayerDateTime)) {
        nextPrayerTime = prayerDateTime;

        if (i == 0) {
          activePrayer = "Isya";
          activePrayerTime = schedule.isya;
        } else {
          activePrayer = entries[i - 1].key;
          activePrayerTime = entries[i - 1].value;
        }
        break;
      }
    }

    if (nextPrayerTime == null) {
      activePrayer = "Isya";
      activePrayerTime = schedule.isya;
      nextPrayerTime = _parseTime(schedule.imsak).add(const Duration(days: 1));
    }

    final diff = nextPrayerTime.difference(now);
    final countdown = _formatDuration(diff);

    return {
      "activePrayer": activePrayer,
      "activePrayerTime": activePrayerTime,
      "countdown": countdown,
    };
  }

  static String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}
