import 'package:adair_flutter_lib/managers/subscription_manager.dart';
import 'package:adair_flutter_lib/pages/pro_page.dart';
import 'package:adair_flutter_lib/pages/scroll_page.dart';
import 'package:adair_flutter_lib/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/finder.dart';
import '../test_utils/stubbed_managers.dart';
import '../test_utils/widget.dart';

void main() {
  late StubbedManagers managers;
  late MockPackage monthlyPackage;
  late MockPackage yearlyPackage;

  setUp(() {
    managers = StubbedManagers();

    when(managers.appConfig.appName).thenReturn((_) => "Unit Test App");
    when(managers.appConfig.appIcon).thenReturn(Icons.add);
    when(managers.appConfig.colorAppTheme).thenReturn(Colors.green);

    when(managers.ioWrapper.isAndroid).thenReturn(true);

    when(
      managers.subscriptionManager.stream,
    ).thenAnswer((_) => const Stream.empty());
    when(managers.subscriptionManager.isPro).thenReturn(false);

    var monthlyProduct = MockStoreProduct();
    when(monthlyProduct.priceString).thenReturn("\$2.99");
    monthlyPackage = MockPackage();
    when(monthlyPackage.storeProduct).thenReturn(monthlyProduct);

    var yearlyProduct = MockStoreProduct();
    when(yearlyProduct.priceString).thenReturn("\$19.99");
    yearlyPackage = MockPackage();
    when(yearlyPackage.storeProduct).thenReturn(yearlyProduct);

    when(managers.subscriptionManager.subscriptions()).thenAnswer(
      (_) => Future.value(
        Subscriptions(
          Subscription(monthlyPackage, 7),
          Subscription(yearlyPackage, 14),
        ),
      ),
    );
  });

  testWidgets(
    "Loading widget shows while fetching subscriptions, then options",
    (tester) async {
      when(managers.subscriptionManager.subscriptions()).thenAnswer(
        (_) => Future.delayed(
          const Duration(milliseconds: 50),
          () => Subscriptions(
            Subscription(monthlyPackage, 7),
            Subscription(yearlyPackage, 14),
          ),
        ),
      );

      await tester.pumpWidget(Testable((_) => const ProPage()));

      expect(find.byType(Loading), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);

      // Wait for subscriptions to be fetched.
      await tester.pumpAndSettle(const Duration(milliseconds: 50));

      expect(find.byType(Loading), findsNothing);
      expect(find.byType(ElevatedButton), findsNWidgets(2));
    },
  );

  testWidgets(
    "Loading widget shows while a purchase is pending, then success",
    (tester) async {
      when(managers.subscriptionManager.subscriptions()).thenAnswer(
        (_) => Future.value(
          Subscriptions(
            Subscription(monthlyPackage, 7),
            Subscription(yearlyPackage, 14),
          ),
        ),
      );
      when(managers.subscriptionManager.purchaseSubscription(any)).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 50), () {}),
      );

      await tester.pumpWidget(Testable((_) => const ProPage()));

      await tester.pumpAndSettle(const Duration(milliseconds: 50));
      await tester.ensureVisible(find.text("Billed monthly"));
      await tester.tap(find.text("Billed monthly"));
      await tester.pump();

      // Purchase is pending.
      expect(findFirst<AnimatedSwitcher>(tester).child is Loading, isTrue);

      // Wait for purchase to finish.
      when(managers.subscriptionManager.isPro).thenReturn(true);
      await tester.pumpAndSettle(const Duration(milliseconds: 50));

      expect(
        find.text("Congratulations, you are now a Pro user!"),
        findsOneWidget,
      );
    },
  );

  testWidgets("Subscription options are not shown if user is already pro", (
    tester,
  ) async {
    when(managers.subscriptionManager.isPro).thenReturn(true);

    await tester.pumpWidget(Testable((_) => const ProPage()));

    expect(
      find.text("Congratulations, you are now a Pro user!"),
      findsOneWidget,
    );
  });

  testWidgets("Error shown if error fetching subscriptions", (tester) async {
    when(
      managers.subscriptionManager.subscriptions(),
    ).thenAnswer((_) => Future.value(null));

    await tester.pumpWidget(Testable((_) => const ProPage()));

    await tester.pumpAndSettle(const Duration(milliseconds: 50));

    expect(
      find.text(
        "Unable to fetch subscription options. Please ensure your"
        " device is connected to the internet and try again.",
      ),
      findsOneWidget,
    );
  });

  testWidgets("Loading widget shows while a restore is pending, then success", (
    tester,
  ) async {
    when(managers.subscriptionManager.subscriptions()).thenAnswer(
      (_) => Future.value(
        Subscriptions(
          Subscription(monthlyPackage, 7),
          Subscription(yearlyPackage, 14),
        ),
      ),
    );
    when(managers.subscriptionManager.restoreSubscription()).thenAnswer(
      (_) => Future.delayed(
        const Duration(milliseconds: 50),
        () => RestoreSubscriptionResult.success,
      ),
    );

    await tester.pumpWidget(Testable((_) => const ProPage()));

    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    expect(
      tapRichTextContaining(
        tester,
        "Purchased Pro on another device? Restore.",
        "Restore.",
      ),
      isTrue,
    );
    await tester.pump();

    // Purchase is pending.
    expect(findFirst<AnimatedSwitcher>(tester).child is Loading, isTrue);

    // Wait for purchase to finish.
    when(managers.subscriptionManager.isPro).thenReturn(true);
    await tester.pumpAndSettle(const Duration(milliseconds: 50));

    expect(
      find.text("Congratulations, you are now a Pro user!"),
      findsOneWidget,
    );
  });

  testWidgets("No purchases found when restoring on iOS", (tester) async {
    when(managers.ioWrapper.isAndroid).thenReturn(false);
    when(managers.subscriptionManager.subscriptions()).thenAnswer(
      (_) => Future.value(
        Subscriptions(
          Subscription(monthlyPackage, 7),
          Subscription(yearlyPackage, 14),
        ),
      ),
    );
    when(managers.subscriptionManager.restoreSubscription()).thenAnswer(
      (_) => Future.delayed(
        const Duration(milliseconds: 50),
        () => RestoreSubscriptionResult.noSubscriptionsFound,
      ),
    );

    await tester.pumpWidget(Testable((_) => const ProPage()));

    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    expect(
      tapRichTextContaining(
        tester,
        "Purchased Pro on another device? Restore.",
        "Restore.",
      ),
      isTrue,
    );
    await tester.pump();

    // Purchase is pending.
    expect(findFirst<AnimatedSwitcher>(tester).child is Loading, isTrue);

    // Wait for purchase to finish.
    when(managers.subscriptionManager.isPro).thenReturn(false);
    await tester.pumpAndSettle(const Duration(milliseconds: 50));

    expect(
      find.text(
        "There were no previous purchases found. Please ensure "
        "you are signed in to the same Apple ID with which you made the "
        "original purchase.",
      ),
      findsOneWidget,
    );
  });

  testWidgets("No purchases found when restoring on Android", (tester) async {
    when(managers.ioWrapper.isAndroid).thenReturn(true);
    when(managers.subscriptionManager.subscriptions()).thenAnswer(
      (_) => Future.value(
        Subscriptions(
          Subscription(monthlyPackage, 7),
          Subscription(yearlyPackage, 14),
        ),
      ),
    );
    when(managers.subscriptionManager.restoreSubscription()).thenAnswer(
      (_) => Future.delayed(
        const Duration(milliseconds: 50),
        () => RestoreSubscriptionResult.noSubscriptionsFound,
      ),
    );

    await tester.pumpWidget(Testable((_) => const ProPage()));

    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    expect(
      tapRichTextContaining(
        tester,
        "Purchased Pro on another device? Restore.",
        "Restore.",
      ),
      isTrue,
    );
    await tester.pump();

    // Purchase is pending.
    expect(findFirst<AnimatedSwitcher>(tester).child is Loading, isTrue);

    // Wait for purchase to finish.
    when(managers.subscriptionManager.isPro).thenReturn(false);
    await tester.pumpAndSettle(const Duration(milliseconds: 50));

    expect(
      find.text(
        "There were no previous purchases found. Please ensure you"
        " are signed in to the same Google account with which you made the"
        " original purchase.",
      ),
      findsOneWidget,
    );
  });

  testWidgets("Generic error when restoring", (tester) async {
    when(managers.ioWrapper.isAndroid).thenReturn(true);
    when(managers.subscriptionManager.subscriptions()).thenAnswer(
      (_) => Future.value(
        Subscriptions(
          Subscription(monthlyPackage, 7),
          Subscription(yearlyPackage, 14),
        ),
      ),
    );
    when(managers.subscriptionManager.restoreSubscription()).thenAnswer(
      (_) => Future.delayed(
        const Duration(milliseconds: 50),
        () => RestoreSubscriptionResult.error,
      ),
    );

    await tester.pumpWidget(Testable((_) => const ProPage()));

    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    expect(
      tapRichTextContaining(
        tester,
        "Purchased Pro on another device? Restore.",
        "Restore.",
      ),
      isTrue,
    );
    await tester.pump();

    // Purchase is pending.
    expect(findFirst<AnimatedSwitcher>(tester).child is Loading, isTrue);

    // Wait for purchase to finish.
    when(managers.subscriptionManager.isPro).thenReturn(false);
    await tester.pumpAndSettle(const Duration(milliseconds: 50));

    expect(
      find.text(
        "Unexpected error occurred. Please ensure your device is "
        "connected to the internet and try again.",
      ),
      findsOneWidget,
    );
  });

  testWidgets("Embedded in scroll view", (tester) async {
    await tester.pumpWidget(
      Testable((_) => const ProPage(isEmbeddedInScrollPage: true)),
    );

    expect(find.byType(ScrollPage), findsOneWidget);
  });

  testWidgets("Not embedded in scroll view", (tester) async {
    await tester.pumpWidget(
      Testable(
        (_) =>
            ListView(children: const [ProPage(isEmbeddedInScrollPage: false)]),
      ),
    );

    expect(find.byType(ScrollPage), findsNothing);
  });

  testWidgets("Android disclosure is shown", (tester) async {
    when(managers.ioWrapper.isAndroid).thenReturn(true);

    await tester.pumpWidget(Testable((_) => const ProPage()));
    // Wait for subscriptions future to finish.
    await tester.pumpAndSettle(const Duration(milliseconds: 50));

    expect(find.substring("Google Play Store"), findsOneWidget);
    expect(find.substring("App Store"), findsNothing);
  });

  testWidgets("Apple disclosure is shown", (tester) async {
    when(managers.ioWrapper.isAndroid).thenReturn(false);

    await tester.pumpWidget(Testable((_) => const ProPage()));
    // Wait for subscriptions future to finish.
    await tester.pumpAndSettle(const Duration(milliseconds: 50));

    expect(find.substring("Google Play Store"), findsNothing);
    expect(find.substring("App Store"), findsOneWidget);
  });
}
