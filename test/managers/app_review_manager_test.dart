import 'package:adair_flutter_lib/managers/app_review_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';

const _keyEventCount = "AppReviewManager.eventCount";
const _keyLastRequestedAt = "AppReviewManager.lastRequestedAt";

void main() {
  late StubbedManagers managers;
  late MockSharedPreferencesAsync sharedPrefsAsync;

  setUp(() async {
    managers = await StubbedManagers.create();
    AppReviewManager.reset();

    sharedPrefsAsync = MockSharedPreferencesAsync();
    when(sharedPrefsAsync.getInt(any)).thenAnswer((_) async => null);
    when(sharedPrefsAsync.setInt(any, any)).thenAnswer((_) async {});
    when(
      managers.sharedPreferencesWrapper.sharedPreferencesAsync(
        options: anyNamed("options"),
      ),
    ).thenReturn(sharedPrefsAsync);

    await AppReviewManager.get.init();
  });

  test("init defaults event count to zero when nothing is persisted", () async {
    AppReviewManager.get.configure(eventThreshold: 1);
    when(
      managers.inAppReviewWrapper.isAvailable(),
    ).thenAnswer((_) async => false);

    await AppReviewManager.get.onQualifyingEventOccurred();

    verify(sharedPrefsAsync.setInt(_keyEventCount, 1)).called(1);
  });

  test("init uses persisted event count when present", () async {
    when(sharedPrefsAsync.getInt(_keyEventCount)).thenAnswer((_) async => 7);
    await AppReviewManager.get.init();
    AppReviewManager.get.configure(eventThreshold: 100);

    await AppReviewManager.get.onQualifyingEventOccurred();

    verify(sharedPrefsAsync.setInt(_keyEventCount, 8)).called(1);
  });

  test("onQualifyingEventOccurred skip still persists the counter", () async {
    AppReviewManager.get.configure(eventThreshold: 1);

    await AppReviewManager.get.onQualifyingEventOccurred(skip: true);

    verify(sharedPrefsAsync.setInt(_keyEventCount, 1)).called(1);
    verifyNever(managers.inAppReviewWrapper.isAvailable());
  });

  test(
    "onQualifyingEventOccurred does nothing when count doesn't reach threshold",
    () async {
      AppReviewManager.get.configure(eventThreshold: 2);

      await AppReviewManager.get.onQualifyingEventOccurred();

      verifyNever(managers.inAppReviewWrapper.isAvailable());
    },
  );

  test(
    "onQualifyingEventOccurred proceeds when never requested before",
    () async {
      AppReviewManager.get.configure(eventThreshold: 1);
      when(
        managers.inAppReviewWrapper.isAvailable(),
      ).thenAnswer((_) async => false);

      await AppReviewManager.get.onQualifyingEventOccurred();

      verify(managers.inAppReviewWrapper.isAvailable()).called(1);
    },
  );

  test(
    "onQualifyingEventOccurred does nothing while within the cooldown",
    () async {
      final now = DateTime(2024, 1, 1);
      managers.stubCurrentTime(now);
      when(sharedPrefsAsync.getInt(_keyLastRequestedAt)).thenAnswer(
        (_) async =>
            now.subtract(const Duration(days: 10)).millisecondsSinceEpoch,
      );
      await AppReviewManager.get.init();
      AppReviewManager.get.configure(eventThreshold: 1);

      await AppReviewManager.get.onQualifyingEventOccurred();

      verifyNever(managers.inAppReviewWrapper.isAvailable());
    },
  );

  test(
    "onQualifyingEventOccurred proceeds once the cooldown has passed",
    () async {
      final now = DateTime(2024, 1, 1);
      managers.stubCurrentTime(now);
      when(sharedPrefsAsync.getInt(_keyLastRequestedAt)).thenAnswer(
        (_) async =>
            now.subtract(const Duration(days: 366)).millisecondsSinceEpoch,
      );
      await AppReviewManager.get.init();
      AppReviewManager.get.configure(eventThreshold: 1);
      when(
        managers.inAppReviewWrapper.isAvailable(),
      ).thenAnswer((_) async => false);

      await AppReviewManager.get.onQualifyingEventOccurred();

      verify(managers.inAppReviewWrapper.isAvailable()).called(1);
    },
  );

  test(
    "onQualifyingEventOccurred doesn't request a review when unavailable",
    () async {
      AppReviewManager.get.configure(eventThreshold: 1);
      when(
        managers.inAppReviewWrapper.isAvailable(),
      ).thenAnswer((_) async => false);

      await AppReviewManager.get.onQualifyingEventOccurred();

      verifyNever(managers.inAppReviewWrapper.requestReview());
      verifyNever(sharedPrefsAsync.setInt(_keyLastRequestedAt, any));
    },
  );

  test(
    "onQualifyingEventOccurred requests a review and persists the timestamp",
    () async {
      AppReviewManager.get.configure(eventThreshold: 1);
      when(
        managers.inAppReviewWrapper.isAvailable(),
      ).thenAnswer((_) async => true);
      when(
        managers.inAppReviewWrapper.requestReview(),
      ).thenAnswer((_) async {});

      await AppReviewManager.get.onQualifyingEventOccurred();

      verify(managers.inAppReviewWrapper.requestReview()).called(1);
      verify(sharedPrefsAsync.setInt(_keyLastRequestedAt, any)).called(1);
    },
  );
}
