import 'dart:async';

import 'package:adair_flutter_lib/pages/landing_page.dart';
import 'package:adair_flutter_lib/pages/sign_in_page.dart';
import 'package:adair_flutter_lib/utils/root.dart';
import 'package:adair_flutter_lib/widgets/adair_flutter_lib_app.dart';
import 'package:adair_flutter_lib/widgets/plain_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../test_utils/finder.dart';
import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
    when(managers.ioWrapper.isWeb).thenReturn(false);

    when(managers.packageInfoWrapper.fromPlatform()).thenAnswer(
      (_) => Future.value(
        PackageInfo(
          appName: "Test",
          packageName: "com.test",
          version: "1.0.0",
          buildNumber: "1",
        ),
      ),
    );
  });

  testWidgets("Root.get.buildContext is set", (tester) async {
    await tester.pumpWidget(
      AdairFlutterLibApp(homeBuilder: (_) => Text("Home")),
    );
    expect(Root.get.buildContext, isNotNull);
    verify(managers.appConfig.appName()).called(1);
  });

  testWidgets("Landing page is shown while managers initialize", (
    tester,
  ) async {
    when(managers.subscriptionManager.init()).thenAnswer((_) => Future.value());
    when(managers.timeManager.init()).thenAnswer((_) => Future.value());

    await tester.pumpWidget(
      AdairFlutterLibApp(
        managers: [managers.subscriptionManager, managers.timeManager],
        homeBuilder: (_) => Text("Home"),
      ),
    );
    expect(find.byType(PlainSplashScreen), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text("Home"), findsOneWidget);
    verify(managers.subscriptionManager.init()).called(1);
    verify(managers.timeManager.init()).called(1);
  });

  testWidgets("Landing page shows error when managers fail to initialize", (
    tester,
  ) async {
    when(
      managers.subscriptionManager.init(),
    ).thenAnswer((_) async => throw Exception("test-error"));

    await tester.pumpWidget(
      AdairFlutterLibApp(
        managers: [managers.subscriptionManager],
        homeBuilder: (_) => Text("Home"),
      ),
    );
    expect(find.byType(PlainSplashScreen), findsOneWidget);
    expect(find.byType(LandingPage), findsNothing);

    await tester.pumpAndSettle();
    expect(findFirst<LandingPage>(tester).hasError, isTrue);
    expect(find.text("Home"), findsNothing);
    verify(managers.subscriptionManager.init()).called(1);
  });

  testWidgets("Home page is shown when signInPageInfo is null", (tester) async {
    await tester.pumpWidget(
      AdairFlutterLibApp(
        signInPageInfo: null,
        homeBuilder: (_) => Text("Home"),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text("Home"), findsOneWidget);
  });

  testWidgets("Sign in page is shown when signInPageInfo is set", (
    tester,
  ) async {
    final authController = StreamController<User?>(sync: true);
    when(
      managers.firebaseAuthWrapper.authStateChanges(),
    ).thenAnswer((_) => authController.stream);

    await tester.pumpWidget(
      AdairFlutterLibApp(
        signInPageInfo: SignInPageInfo(),
        homeBuilder: (_) => Text("Home"),
      ),
    );

    // Ensure user is not signed in.
    authController.add(null);
    await tester.pumpAndSettle();

    expect(find.text("Email"), findsOneWidget);
    expect(find.text("Password"), findsOneWidget);
    expect(find.text("Home"), findsNothing);
  });

  testWidgets("Other lifecycle states do not show LandingPage", (tester) async {
    await tester.pumpWidget(
      AdairFlutterLibApp(homeBuilder: (_) => Text("Home")),
    );
    await tester.pumpAndSettle();

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.scheduleWarmUpFrame();
    expect(find.byType(LandingPage), findsNothing);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.detached);
    tester.binding.scheduleWarmUpFrame();
    expect(find.byType(LandingPage), findsNothing);
  });
}
