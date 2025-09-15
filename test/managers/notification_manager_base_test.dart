import 'package:adair_flutter_lib/managers/notification_manager_base.dart';
import 'package:adair_flutter_lib/pages/notification_permission_page.dart';
import 'package:adair_flutter_lib/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/disposable_tester.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';
import '../test_utils/widget.dart';

void main() {
  late StubbedManagers managers;
  late _NotificationManager notificationManager;

  setUp(() async {
    managers = await StubbedManagers.create();
    notificationManager = _NotificationManager();

    var mockNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
    when(
      mockNotificationsPlugin.initialize(
        any,
        onDidReceiveNotificationResponse: anyNamed(
          "onDidReceiveNotificationResponse",
        ),
      ),
    ).thenAnswer((_) => Future.value());
    when(
      managers.localNotificationsWrapper.newInstance(),
    ).thenReturn(mockNotificationsPlugin);
  });

  testWidgets("Permission request exists early if user denied", (tester) async {
    when(
      managers.permissionHandlerWrapper.isNotificationDenied,
    ).thenAnswer((_) => Future.value(false));

    late BuildContext context;
    late DisposableTester testWidget;
    await pumpContext(tester, (con) {
      context = con;
      testWidget = const DisposableTester(child: SizedBox());
      return testWidget;
    });

    await notificationManager.requestPermissionIfNeeded(
      context,
      "Test description.",
    );
    await tester.pumpAndSettle();
    expect(find.byType(NotificationPermissionPage), findsNothing);
    verify(managers.permissionHandlerWrapper.isNotificationDenied).called(1);
  });

  testWidgets("Permission request is issued", (tester) async {
    when(
      managers.permissionHandlerWrapper.isNotificationDenied,
    ).thenAnswer((_) => Future.value(true));

    await tester.pumpWidget(
      Testable((_) => _PermissionRequestTester(notificationManager)),
    );

    await tapAndSettle(tester, find.text("TEST"));
    expect(find.byType(NotificationPermissionPage), findsOneWidget);
  });
}

class _NotificationManager extends NotificationManagerBase {}

class _PermissionRequestTester extends StatefulWidget {
  final _NotificationManager notificationManager;

  const _PermissionRequestTester(this.notificationManager);

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
          context,
          "Some description.",
        );
      },
    );
  }
}
