import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class InAppReviewWrapper {
  static var _instance = InAppReviewWrapper._();

  static InAppReviewWrapper get get => _instance;

  @visibleForTesting
  static void set(InAppReviewWrapper manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = InAppReviewWrapper._();

  InAppReviewWrapper._();

  Future<bool> isAvailable() => InAppReview.instance.isAvailable();

  Future<void> requestReview() => InAppReview.instance.requestReview();
}
