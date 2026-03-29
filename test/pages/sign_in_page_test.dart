import 'dart:async';

import 'package:adair_flutter_lib/pages/landing_page.dart';
import 'package:adair_flutter_lib/pages/sign_in_page.dart';
import 'package:adair_flutter_lib/utils/dialog.dart';
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
  late StreamController<User?> authController;

  setUp(() async {
    managers = await StubbedManagers.create();

    authController = StreamController<User?>(sync: true);
    when(
      managers.firebaseAuthWrapper.authStateChanges(),
    ).thenAnswer((_) => authController.stream);
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

  openResetPasswordDialog(WidgetTester tester) async {
    await tapAndSettle(
      tester,
      find.widgetWithText(TextButton, "Reset Password"),
    );
  }

  stubSendReset(Future<void> Function(Invocation) answer) {
    when(
      managers.firebaseAuthWrapper.sendPasswordResetEmail(
        email: anyNamed("email"),
      ),
    ).thenAnswer(answer);
  }

  Future<void> pumpNotSignedIn(
    WidgetTester tester, [
    SignInPageInfo? info,
    String? homeText,
  ]) async {
    await pumpContext(
      tester,
      useMaterial3: true,
      (_) => SignInPage(
        info: info ?? SignInPageInfo(),
        homeBuilder: (_) => Text(homeText ?? ""),
      ),
    );
    authController.add(null);
    await tester.pump();
  }

  testWidgets("No text input", (tester) async {
    await pumpNotSignedIn(tester);
    expect(findFirst<Button>(tester).onPressed, isNull);
    expect(find.byType(Loading), findsNothing);
  });

  testWidgets("Sign in button is enabled when input is valid", (tester) async {
    await pumpNotSignedIn(tester);

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
    await pumpNotSignedIn(tester);
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

  testWidgets("Custom logo", (tester) async {
    await pumpNotSignedIn(tester, SignInPageInfo(logo: Text("TEST LOGO")));
    expect(find.text("TEST LOGO"), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets("Default logo", (tester) async {
    when(managers.appConfig.appIcon).thenReturn(Icons.onetwothree);
    await pumpNotSignedIn(tester, SignInPageInfo(logo: null));
    expect(findFirst<Icon>(tester).icon, Icons.onetwothree);
  });

  testWidgets("Firebase throws invalid-email", (tester) async {
    await pumpNotSignedIn(tester);
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "invalid-email"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(find.text("Invalid email address format."), findsOneWidget);
  });

  testWidgets("Firebase throws user-disabled", (tester) async {
    await pumpNotSignedIn(tester);
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "user-disabled"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(find.text("User has been disabled."), findsOneWidget);
  });

  testWidgets("Firebase throws user-not-found", (tester) async {
    await pumpNotSignedIn(tester);
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
    await pumpNotSignedIn(tester);
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
    await pumpNotSignedIn(tester);
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
    await pumpNotSignedIn(tester);
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
    await pumpNotSignedIn(tester);
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
    await pumpNotSignedIn(tester);
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
    await pumpNotSignedIn(tester);
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
    await pumpNotSignedIn(tester);
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
    verify(managers.firebaseAuthWrapper.signOut()).called(1);
  });

  testWidgets("Firebase throws unknown error", (tester) async {
    await pumpNotSignedIn(tester);
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "unknown-error"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(find.text("Unknown error (unknown-error)."), findsOneWidget);
  });

  testWidgets("Firebase auth state error", (tester) async {
    await pumpNotSignedIn(tester);
    await tester.pump();

    authController.addError("test-error");
    await tester.pump();
    expect(findFirst<LandingPage>(tester).hasError, isTrue);
  });

  testWidgets("Firebase auth state waiting", (tester) async {
    await pumpContext(
      tester,
      (_) => SignInPage(info: SignInPageInfo(), homeBuilder: (_) => Text("")),
    );

    expect(find.byType(LandingPage), findsOneWidget);
    expect(findFirst<LandingPage>(tester).hasError, isFalse);
  });

  testWidgets("Firebase auth state not authorized", (tester) async {
    await pumpContext(
      tester,
      (_) => SignInPage(info: SignInPageInfo(), homeBuilder: (_) => Text("H")),
    );

    authController.add(null);
    await tester.pump();

    expect(find.byType(SignInPage), findsOneWidget);
    expect(find.text("H"), findsNothing);
  });

  testWidgets("Firebase auth state authorized", (tester) async {
    await pumpContext(
      tester,
      (_) => SignInPage(info: SignInPageInfo(), homeBuilder: (_) => Text("")),
    );
    await tester.pump();

    authController.add(MockUser());
    await tester.pump();

    expect(find.byType(TextField), findsNothing);
    expect(find.text(""), findsOneWidget);
  });

  testWidgets("Post sign in verification fails", (tester) async {
    await pumpNotSignedIn(
      tester,
      SignInPageInfo(
        postSignInVerification: () => Future.value("post-sign-in-error"),
      ),
      "H",
    );
    await enterEmailAndPassword(tester);

    // Sign in.
    stubSignIn(
      (_) => Future.delayed(
        const Duration(seconds: 1),
        () => MockUserCredential(),
      ),
    );
    await tester.tap(find.byType(Button));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text("post-sign-in-error"), findsOneWidget);
    expect(find.text("H"), findsNothing);
    verify(managers.firebaseAuthWrapper.signOut()).called(1);
  });

  testWidgets("Post sign in verification throws exception", (tester) async {
    await pumpNotSignedIn(
      tester,
      SignInPageInfo(
        postSignInVerification: () => throw Exception("post-sign-in-exception"),
      ),
      "H",
    );
    await enterEmailAndPassword(tester);

    // Sign in.
    stubSignIn(
      (_) => Future.delayed(
        const Duration(seconds: 1),
        () => MockUserCredential(),
      ),
    );
    await tester.tap(find.byType(Button));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text("Exception: post-sign-in-exception"), findsOneWidget);
    expect(find.text("H"), findsNothing);
    verify(managers.firebaseAuthWrapper.signOut()).called(1);
  });

  testWidgets("Post sign in verification succeeds", (tester) async {
    await pumpNotSignedIn(
      tester,
      SignInPageInfo(postSignInVerification: () => Future.value(null)),
      "HOME",
    );
    await enterEmailAndPassword(tester);

    // Sign in.
    stubSignIn(
      (_) => Future.delayed(
        const Duration(seconds: 1),
        () => MockUserCredential(),
      ),
    );
    await tester.tap(find.byType(Button));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text("HOME"), findsNothing);
    verifyNever(managers.firebaseAuthWrapper.signOut());
  });

  testWidgets("Reset password button is visible", (tester) async {
    await pumpNotSignedIn(tester);
    expect(find.widgetWithText(TextButton, "Reset Password"), findsOneWidget);
  });

  testWidgets("Tapping reset password button opens dialog", (tester) async {
    await pumpNotSignedIn(tester);
    await openResetPasswordDialog(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets("Reset password dialog send button disabled with empty email", (
    tester,
  ) async {
    await pumpNotSignedIn(tester);
    await openResetPasswordDialog(tester);
    expect(findFirstWithText<DialogButton>(tester, "Reset").isEnabled, isFalse);
  });

  testWidgets("Reset password dialog send button enabled with valid email", (
    tester,
  ) async {
    await pumpNotSignedIn(tester);
    await openResetPasswordDialog(tester);
    await enterTextAndSettle(
      tester,
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(TextField, "Email"),
      ),
      "test@test.com",
    );
    expect(findFirstWithText<DialogButton>(tester, "Reset").isEnabled, isTrue);
  });

  testWidgets("Reset password dialog shows loading while sending", (
    tester,
  ) async {
    await pumpNotSignedIn(tester);
    await openResetPasswordDialog(tester);
    await enterTextAndSettle(
      tester,
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(TextField, "Email"),
      ),
      "test@test.com",
    );

    stubSendReset((_) => Future.delayed(const Duration(seconds: 1), () {}));

    await tester.tap(find.widgetWithText(TextButton, "Reset"));
    await tester.pump();

    expect(find.byType(Loading), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });

  testWidgets("Reset password dialog shows confirmation after success", (
    tester,
  ) async {
    await pumpNotSignedIn(tester);
    await openResetPasswordDialog(tester);
    await enterTextAndSettle(
      tester,
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(TextField, "Email"),
      ),
      "test@test.com",
    );

    stubSendReset((_) async {});

    await tapAndSettle(tester, find.widgetWithText(TextButton, "Reset"));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      findsNothing,
    );
    expect(find.widgetWithText(TextButton, "Ok"), findsOneWidget);
  });

  testWidgets("Reset password dialog shows error after failure", (
    tester,
  ) async {
    await pumpNotSignedIn(tester);
    await openResetPasswordDialog(tester);
    await enterTextAndSettle(
      tester,
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(TextField, "Email"),
      ),
      "test@test.com",
    );

    stubSendReset((_) => throw FirebaseAuthException(code: "unknown-error"));

    await tapAndSettle(tester, find.widgetWithText(TextButton, "Reset"));
    expect(find.byType(Loading), findsNothing);
    expect(find.text("Unknown error (unknown-error)."), findsOneWidget);
  });

  testWidgets("Reset password dialog cancel closes dialog", (tester) async {
    await pumpNotSignedIn(tester);
    await openResetPasswordDialog(tester);
    await tapAndSettle(tester, find.widgetWithText(TextButton, "Cancel"));
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets("Post sign in verification is not called when sign in fails", (
    tester,
  ) async {
    var verificationCalled = false;
    await pumpNotSignedIn(
      tester,
      SignInPageInfo(
        postSignInVerification: () {
          verificationCalled = true;
          return Future.value(null);
        },
      ),
    );
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "invalid-email"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(verificationCalled, isFalse);
  });
}
