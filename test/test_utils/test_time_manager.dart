import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:timezone/timezone.dart';

class TestTimeManager extends TimeManager {
  final String timeZone;

  TZDateTime? _now;

  TestTimeManager() : timeZone = "America/New_York";

  void overrideNow(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
  ]) {
    _now = TZDateTime(
      getLocation(timeZone),
      year,
      month,
      day,
      hour,
      minute,
      second,
    );
  }

  @override
  TZDateTime get currentDateTime => _now ?? super.currentDateTime;
}
