import 'package:adair_flutter_lib/managers/time_manager.dart';
import 'package:timezone/timezone.dart';

/// This class is not strictly required, but using a stubbed class will result
/// in a lot of duplicated code between the stubs and real implementation. All
/// we really need is to stub the current time, and everything else will work
/// from there.
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
