import 'dart:async';

import 'package:adair_flutter_lib/pages/sign_in_page.dart';
import 'package:adair_flutter_lib/utils/root.dart';
import 'package:adair_flutter_lib/widgets/adair_flutter_lib_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;
  late StreamController<User?> authController;

  setUp(() async {
    managers = await StubbedManagers.create();

    authController = StreamController<User?>(sync: true);
    when(
      managers.firebaseAuthWrapper.authStateChanges(),
    ).thenAnswer((_) => authController.stream);

    when(managers.appConfig.appName).thenReturn(() => "Test");

    when(managers.ioWrapper.isWeb).thenReturn(false);
  });

  testWidgets("Root.get.buildContext is set", (tester) async {
    await tester.pumpWidget(
      AdairFlutterLibApp(homeBuilder: (_) => Text("Home")),
    );
    expect(Root.get.buildContext, isNotNull);
    verify(managers.appConfig.appName()).called(1);
  });

  testWidgets("Loading page is shown while managers initialize", (
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
    expect(find.byType(Scaffold), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text("Home"), findsOneWidget);
    verify(managers.subscriptionManager.init()).called(1);
    verify(managers.timeManager.init()).called(1);
  });

  testWidgets("Home page is shown when requiresAuth is false", (tester) async {
    await tester.pumpWidget(
      AdairFlutterLibApp(requiresAuth: false, homeBuilder: (_) => Text("Home")),
    );
    await tester.pumpAndSettle();
    expect(find.text("Home"), findsOneWidget);
  });

  testWidgets("Firebase auth state error", (tester) async {
    await tester.pumpWidget(
      AdairFlutterLibApp(requiresAuth: true, homeBuilder: (_) => Text("Home")),
    );
    await tester.pump();

    authController.addError("test-error");
    await tester.pump();
    expect(find.text("Loading..."), findsNothing);
    expect(
      find.text("Something went wrong on sign in: test-error"),
      findsOneWidget,
    );
  });

  testWidgets("Firebase auth state waiting", (tester) async {
    await tester.pumpWidget(
      AdairFlutterLibApp(requiresAuth: true, homeBuilder: (_) => Text("Home")),
    );

    await tester.pump();
    expect(find.text("Loading..."), findsOneWidget);
  });

  testWidgets("Firebase auth state not authorized", (tester) async {
    await tester.pumpWidget(
      AdairFlutterLibApp(requiresAuth: true, homeBuilder: (_) => Text("Home")),
    );
    await tester.pump();

    authController.add(null);
    await tester.pump();

    expect(find.byType(SignInPage), findsOneWidget);
    expect(find.text("Home"), findsNothing);
  });

  testWidgets("Firebase auth state authorized", (tester) async {
    await tester.pumpWidget(
      AdairFlutterLibApp(requiresAuth: true, homeBuilder: (_) => Text("Home")),
    );
    await tester.pump();

    authController.add(MockUser());
    await tester.pump();

    expect(find.byType(SignInPage), findsNothing);
    expect(find.text("Home"), findsOneWidget);
  });
}
