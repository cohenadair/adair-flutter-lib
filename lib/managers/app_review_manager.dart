import 'package:flutter/foundation.dart';

import '../utils/log.dart';
import '../wrappers/in_app_review_wrapper.dart';
import '../wrappers/shared_preferences_wrapper.dart';
import 'manager.dart';
import 'time_manager.dart';

final _log = const Log("AppReviewManager");

/// Tracks qualifying events (e.g. a completed session) reported by an app and
/// requests the OS-native App Store rate/review prompt once every
/// [_eventThreshold] events, subject to a cooldown between requests.
class AppReviewManager implements Manager {
  static var _instance = AppReviewManager._();

  static AppReviewManager get get => _instance;

  @visibleForTesting
  static void set(AppReviewManager manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = AppReviewManager._();

  AppReviewManager._();

  static const _keyEventCount = "AppReviewManager.eventCount";
  static const _keyLastRequestedAt = "AppReviewManager.lastRequestedAt";
  static const _defaultEventThreshold = 15;
  static const _cooldown = Duration(days: 365);

  var _eventThreshold = _defaultEventThreshold;
  var _eventCount = 0;
  int? _lastRequestedAt;

  @override
  Future<void> init() async {
    final prefs = SharedPreferencesWrapper.get.sharedPreferencesAsync();
    _eventCount = await prefs.getInt(_keyEventCount) ?? 0;
    _lastRequestedAt = await prefs.getInt(_keyLastRequestedAt);
  }

  /// Configures app-specific behavior. Should be called once, synchronously,
  /// during app startup (e.g. alongside `AppConfig.get.init(...)`), before
  /// [init] runs as part of the `AdairFlutterLibApp` managers list. If never
  /// called, a default threshold of [_defaultEventThreshold] is used.
  void configure({required int eventThreshold}) {
    _eventThreshold = eventThreshold;
  }

  /// Reports that a qualifying event occurred. The internal counter is
  /// always incremented and persisted, regardless of [skip]. If [skip] is
  /// true, no review prompt is evaluated for this event (used so a
  /// competing prompt and the review prompt don't both fire for the same
  /// event) — but the counter still advances normally so future threshold
  /// checks are unaffected.
  Future<void> onQualifyingEventOccurred({bool skip = false}) async {
    final prefs = SharedPreferencesWrapper.get.sharedPreferencesAsync();

    _eventCount++;
    await prefs.setInt(_keyEventCount, _eventCount);

    if (skip || _eventCount % _eventThreshold != 0) {
      return;
    }

    final now = TimeManager.get.currentTimestamp;
    if (_lastRequestedAt != null &&
        now - _lastRequestedAt! < _cooldown.inMilliseconds) {
      return;
    }

    if (!await InAppReviewWrapper.get.isAvailable()) {
      return;
    }

    _log.d("Requesting App Store review");
    await InAppReviewWrapper.get.requestReview();

    _lastRequestedAt = now;
    await prefs.setInt(_keyLastRequestedAt, now);
  }
}
