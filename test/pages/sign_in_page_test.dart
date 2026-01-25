import 'package:adair_flutter_lib/pages/sign_in_page.dart';
import 'package:adair_flutter_lib/widgets/button.dart';
import 'package:adair_flutter_lib/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/finder.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/testable.dart';
import '../test_utils/widget.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
    when(managers.ioWrapper.isWeb).thenReturn(false);
  });

  enterEmailAndPassword(WidgetTester tester) async {
    await enterTextAndSettle(
      tester,
      find.widgetWithText(TextField, "Email"),
      "test@test.com",
    );
    await enterTextAndSettle(
      tester,
      find.widgetWithText(TextField, "Password"),
      "P4ssw0rd!",
    );
    expect(findFirst<Button>(tester).onPressed, isNotNull);
  }

  stubSignIn(Future<UserCredential> Function(Invocation) answer) {
    when(
      managers.firebaseAuthWrapper.signInWithEmailAndPassword(
        email: anyNamed("email"),
        password: anyNamed("password"),
      ),
    ).thenAnswer(answer);
  }

  testWidgets("No text input", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    expect(findFirst<Button>(tester).onPressed, isNull);
    expect(find.byType(Loading), findsNothing);
  });

  testWidgets("Sign in button is enabled when input is valid", (tester) async {
    await pumpContext(tester, (_) => SignInPage());

    await enterTextAndSettle(
      tester,
      find.widgetWithText(TextField, "Email"),
      "test@test.com",
    );
    expect(findFirst<Button>(tester).onPressed, isNull);

    await enterTextAndSettle(
      tester,
      find.widgetWithText(TextField, "Password"),
      "P4ssw0rd!",
    );
    expect(findFirst<Button>(tester).onPressed, isNotNull);
  });

  testWidgets("Signing in", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn(
      (_) => Future.delayed(
        const Duration(seconds: 1),
        () => MockUserCredential(),
      ),
    );
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNull);
    expect(find.byType(Loading), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 1));
  });

  testWidgets("Firebase throws invalid-email", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "invalid-email"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(find.text("Invalid email address format."), findsOneWidget);
  });

  testWidgets("Firebase throws user-disabled", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "user-disabled"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(find.text("User has been disabled."), findsOneWidget);
  });

  testWidgets("Firebase throws user-not-found", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "user-not-found"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(
      find.text("No user exists with the given email address."),
      findsOneWidget,
    );
  });

  testWidgets("Firebase throws too-many-requests", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "too-many-requests"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(
      find.text("Sign in has been throttled. Please try again later."),
      findsOneWidget,
    );
  });

  testWidgets("Firebase throws user-token-expired", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "user-token-expired"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(
      find.text("Authentication has expired. Please try again."),
      findsOneWidget,
    );
  });

  testWidgets("Firebase throws network-request-failed", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn(
      (_) => throw FirebaseAuthException(code: "network-request-failed"),
    );
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(
      find.text("Please check your network connection and try again."),
      findsOneWidget,
    );
  });

  testWidgets("Firebase throws INVALID_LOGIN_CREDENTIALS", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn(
      (_) => throw FirebaseAuthException(code: "INVALID_LOGIN_CREDENTIALS"),
    );
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(
      find.text("Incorrect email and password combination."),
      findsOneWidget,
    );
  });

  testWidgets("Firebase throws invalid-credential", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "invalid-credential"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(
      find.text("Incorrect email and password combination."),
      findsOneWidget,
    );
  });

  testWidgets("Firebase throws wrong-password", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "wrong-password"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(
      find.text("Incorrect email and password combination."),
      findsOneWidget,
    );
  });

  testWidgets("Firebase throws operation-not-allowed", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn(
      (_) => throw FirebaseAuthException(code: "operation-not-allowed"),
    );
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(
      find.text("Email and password sign in is disabled for this app."),
      findsOneWidget,
    );
  });

  testWidgets("Firebase throws unknown error", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "unknown-error"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(find.text("Unknown sign in error (unknown-error)."), findsOneWidget);
  });

  testWidgets("Firebase throws non-auth exception", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw Exception("Bad gateway"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(
      find.text("Unknown sign in error (Exception: Bad gateway)."),
      findsOneWidget,
    );
  });
}
