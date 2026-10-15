import 'package:adair_flutter_lib/managers/notification_manager_base.dart';
import 'package:adair_flutter_lib/pages/notification_permission_page.dart';
import 'package:adair_flutter_lib/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';
import '../test_utils/widget.dart';

void main() {
  late StubbedManagers managers;
  late _NotificationManager notificationManager;
  late MockFlutterLocalNotificationsPlugin notificationsPlugin;

  setUp(() async {
    managers = await StubbedManagers.create();
    notificationManager = _NotificationManager();

    notificationsPlugin = MockFlutterLocalNotificationsPlugin();
    when(
      notificationsPlugin.initialize(
        any,
        onDidReceiveNotificationResponse: anyNamed(
          "onDidReceiveNotificationResponse",
        ),
      ),
    ).thenAnswer((_) => Future.value());
    when(
      managers.localNotificationsWrapper.newInstance(),
    ).thenReturn(notificationsPlugin);
  });

  void stubInitializeThrows() {
    when(
      notificationsPlugin.initialize(
        any,
        onDidReceiveNotificationResponse: anyNamed(
          "onDidReceiveNotificationResponse",
        ),
      ),
    ).thenThrow(PlatformException(code: "invalid_icon"));
  }

  test("init doesn't throw when the plugin fails to initialize", () async {
    stubInitializeThrows();
    await expectLater(notificationManager.init(), completes);
  });

  test("show does nothing when the plugin failed to initialize", () async {
    stubInitializeThrows();
    await notificationManager.init();

    await notificationManager.show(id: 1, title: "Title");

    verifyNever(
      notificationsPlugin.show(
        any,
        any,
        any,
        any,
        payload: anyNamed("payload"),
      ),
    );
  });

  test("show shows the notification when initialized", () async {
    when(
      notificationsPlugin.show(
        any,
        any,
        any,
        any,
        payload: anyNamed("payload"),
      ),
    ).thenAnswer((_) => Future.value());
    await notificationManager.init();

    await notificationManager.show(id: 1, title: "Title");

    verify(
      notificationsPlugin.show(
        1,
        "Title",
        any,
        any,
        payload: anyNamed("payload"),
      ),
    ).called(1);
  });

  test("cancel does nothing when the plugin failed to initialize", () async {
    stubInitializeThrows();
    await notificationManager.init();

    await notificationManager.cancel(id: 1);

    verifyNever(notificationsPlugin.cancel(any));
  });

  test("cancel cancels the notification when initialized", () async {
    when(notificationsPlugin.cancel(any)).thenAnswer((_) => Future.value());
    await notificationManager.init();

    await notificationManager.cancel(id: 1);

    verify(notificationsPlugin.cancel(1)).called(1);
  });

  testWidgets("Permission request returns true if already granted", (
    tester,
  ) async {
    when(
      managers.permissionHandlerWrapper.isNotificationDenied,
    ).thenAnswer((_) => Future.value(false));
    when(
      managers.permissionHandlerWrapper.isNotificationGranted,
    ).thenAnswer((_) => Future.value(true));

    expect(
      await notificationManager.requestPermissionIfNeeded(
        context: await buildContext(tester),
      ),
      isTrue,
    );
    verify(managers.permissionHandlerWrapper.isNotificationGranted).called(1);
  });

  testWidgets("Permission request exits early if context isn't mounted", (
    tester,
  ) async {
    when(managers.permissionHandlerWrapper.isNotificationDenied).thenAnswer(
      (_) => Future.delayed(const Duration(milliseconds: 50), () => true),
    );

    await pumpContext(
      tester,
      (_) => _PermissionRequestTester(notificationManager, "Test description."),
    );
    await tester.tap(find.text("TEST"));
    await tester.pump();

    // Dispose of test widget before permission future returns.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();

    expect(find.byType(NotificationPermissionPage), findsNothing);
  });

  testWidgets("Permission request shows permission page", (tester) async {
    when(
      managers.permissionHandlerWrapper.isNotificationDenied,
    ).thenAnswer((_) => Future.value(true));

    await pumpContext(
      tester,
      (_) => _PermissionRequestTester(notificationManager, "Test description."),
    );

    await tapAndSettle(tester, find.text("TEST"));
    expect(find.byType(NotificationPermissionPage), findsOneWidget);
    expect(find.text("Test description."), findsOneWidget);
  });

  test(
    "requestPermissionIfNeeded with showPermissionPage false calls requestNotification directly when denied",
    () async {
      when(
        managers.permissionHandlerWrapper.isNotificationDenied,
      ).thenAnswer((_) => Future.value(true));
      when(
        managers.permissionHandlerWrapper.requestNotification(),
      ).thenAnswer((_) => Future.value(true));

      final result = await notificationManager.requestPermissionIfNeeded(
        showPermissionPage: false,
      );

      expect(result, isTrue);
      verify(managers.permissionHandlerWrapper.requestNotification()).called(1);
    },
  );

  test(
    "requestPermissionIfNeeded returns false when context is null and showPermissionPage is true",
    () async {
      when(
        managers.permissionHandlerWrapper.isNotificationDenied,
      ).thenAnswer((_) => Future.value(true));

      expect(await notificationManager.requestPermissionIfNeeded(), isFalse);
    },
  );
}

class _NotificationManager extends NotificationManagerBase {
  @override
  Future<void> init() => super.init();

  @override
  Future<bool> requestPermissionIfNeeded({
    BuildContext? context,
    String userDescription = "",
    bool showPermissionPage = true,
  }) async {
    return super.requestPermissionIfNeeded(
      context: context,
      userDescription: userDescription,
      showPermissionPage: showPermissionPage,
    );
  }
}

class _PermissionRequestTester extends StatefulWidget {
  final _NotificationManager notificationManager;
  final String description;

  const _PermissionRequestTester(this.notificationManager, this.description);

  @override
  State<_PermissionRequestTester> createState() =>
      __PermissionRequestTesterState();
}

class __PermissionRequestTesterState extends State<_PermissionRequestTester> {
  @override
  Widget build(BuildContext context) {
    return Button(
      text: "TEST",
      onPressed: () {
        widget.notificationManager.requestPermissionIfNeeded(
          context: context,
          userDescription: widget.description,
        );
      },
    );
  }
}
