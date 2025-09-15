import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget.dart';

T findFirst<T>(WidgetTester tester) => tester.firstWidget(find.byType(T)) as T;

T findLast<T>(WidgetTester tester) =>
    tester.widgetList(find.byType(T)).last as T;

/// Different from [Finder.widgetWithText] in that it works for widgets with
/// generic arguments.
T findFirstWithText<T>(WidgetTester tester, String text) {
  return find.widgetWithText(T, text).evaluate().first.widget as T;
}

T findFirstWithIcon<T>(WidgetTester tester, IconData icon) {
  return tester.firstWidget(
        find.ancestor(
          of: find.byIcon(icon),
          matching: find.byWidgetPredicate((widget) => widget is T),
        ),
      )
      as T;
}

T findSiblingOfText<T>(WidgetTester tester, Type parentType, String text) {
  return tester.firstWidget(
        siblingOfText(tester, parentType, text, find.byType(T)),
      )
      as T;
}

Finder siblingOfText(
  WidgetTester tester,
  Type parentType,
  String text,
  Finder siblingFinder,
) {
  return find.descendant(
    of: find.widgetWithText(parentType, text),
    matching: siblingFinder,
  );
}

Type typeOf<T>() => T;

Finder findRichText(String text) {
  return find.byWidgetPredicate(
    (widget) => widget is RichText && widget.text.toPlainText() == text,
  );
}

bool tapRichTextContaining(
  WidgetTester tester,
  String fullText,
  String clickText,
) {
  return !tester
      .firstWidget<RichText>(findRichText(fullText))
      .text
      .visitChildren((span) {
        if (span is TextSpan && span.text == clickText) {
          (span.recognizer as TapGestureRecognizer).onTap!();
          return false;
        }
        return true;
      });
}

/// Different from [Finder.byType] in that it works for widgets with generic
/// arguments.
List<T> findType<T>(WidgetTester tester, {bool skipOffstage = true}) {
  return tester
      .widgetList(
        find.byWidgetPredicate(
          (widget) => widget is T,
          skipOffstage: skipOffstage,
        ),
      )
      .map((e) => e as T)
      .toList();
}

Future<void> pickTimeAndSettle(
  WidgetTester tester, {
  required String oldHour,
  required String oldMinute,
  required String newHour,
  required String newMinute,
  bool am = true,
}) async {
  await tapAndSettle(tester, find.byIcon(Icons.keyboard_outlined));
  await enterTextAndSettle(tester, find.text(oldHour), newHour);
  await enterTextAndSettle(tester, find.text(oldMinute), newMinute);
  await tapAndSettle(tester, find.text(am ? "AM" : "PM"));
  await tapAndSettle(tester, find.text("OK"));
  expect(find.text("OK"), findsNothing);
}

extension CommonFindersExt on CommonFinders {
  Finder substring(String substring, {bool skipOffstage = true}) {
    return byWidgetPredicate(
      (widget) =>
          widget is Text &&
          widget.data != null &&
          widget.data!.contains(substring),
      skipOffstage: skipOffstage,
    );
  }
}
