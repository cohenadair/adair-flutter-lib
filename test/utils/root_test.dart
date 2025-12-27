import 'package:adair_flutter_lib/utils/root.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Assertion thrown if buildContext is accessed, but not set", () {
    expect(() => Root.get.buildContext, throwsAssertionError);
  });
}
