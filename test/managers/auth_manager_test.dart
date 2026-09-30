import 'dart:async';

import 'package:adair_flutter_lib/managers/auth_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
    AuthManager.reset();
    when(managers.firebaseAuthWrapper.signOut()).thenAnswer((_) async {});
  });

  tearDown(AuthManager.reset);

  test("signOut signs out when there are no managers", () async {
    await AuthManager.get.signOut();
    verify(managers.firebaseAuthWrapper.signOut()).called(1);
  });

  test(
    "signOut calls onSignOut on each manager in order, then signs out",
    () async {
      final first = MockManager();
      when(first.onSignOut()).thenAnswer((_) async {});
      final second = MockManager();
      when(second.onSignOut()).thenAnswer((_) async {});
      AuthManager.get.managers = [first, second];

      await AuthManager.get.signOut();

      verifyInOrder([
        first.onSignOut(),
        second.onSignOut(),
        managers.firebaseAuthWrapper.signOut(),
      ]);
    },
  );

  test("signOut still signs out when a manager's onSignOut throws", () async {
    final failing = MockManager();
    when(
      failing.onSignOut(),
    ).thenAnswer((_) => Future.error(Exception("cleanup failed")));
    final next = MockManager();
    when(next.onSignOut()).thenAnswer((_) async {});
    AuthManager.get.managers = [failing, next];

    await AuthManager.get.signOut();

    verify(next.onSignOut()).called(1);
    verify(managers.firebaseAuthWrapper.signOut()).called(1);
  });

  testWidgets("signOut still signs out when a manager's onSignOut times out", (
    tester,
  ) async {
    final hanging = MockManager();
    when(hanging.onSignOut()).thenAnswer((_) => Completer<void>().future);
    final next = MockManager();
    when(next.onSignOut()).thenAnswer((_) async {});
    AuthManager.get.managers = [hanging, next];

    var isSignedOut = false;
    unawaited(AuthManager.get.signOut().then((_) => isSignedOut = true));

    await tester.pump(const Duration(seconds: 4));
    expect(isSignedOut, isFalse);
    verifyNever(next.onSignOut());

    await tester.pump(const Duration(seconds: 1));
    expect(isSignedOut, isTrue);
    verify(next.onSignOut()).called(1);
    verify(managers.firebaseAuthWrapper.signOut()).called(1);
  });
}
