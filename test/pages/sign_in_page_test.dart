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

  testWidgets("Firebase throws auth exception", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw FirebaseAuthException(code: "invalid-credential"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(find.text("invalid-credential"), findsOneWidget);
  });

  testWidgets("Firebase throws non-auth exception", (tester) async {
    await pumpContext(tester, (_) => SignInPage());
    await enterEmailAndPassword(tester);

    stubSignIn((_) => throw Exception("Bad gateway"));
    await tester.tap(find.byType(Button));
    await tester.pump();

    expect(findFirst<Button>(tester).onPressed, isNotNull);
    expect(find.byType(Loading), findsNothing);
    expect(find.text("Unknown error (Exception: Bad gateway)"), findsOneWidget);
  });
}
