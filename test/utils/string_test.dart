import 'package:adair_flutter_lib/utils/string.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Parse boolean", () {
    expect(parseBoolFromInt("123123"), false);
    expect(parseBoolFromInt("0"), false);
    expect(parseBoolFromInt("1"), true);
  });

  test("ignoreCaseAlphabeticalComparator", () {
    var strings = ["C", "A", "Z", "O", "R", "E"];
    strings.sort(ignoreCaseAlphabeticalComparator);
    expect(strings, ["A", "C", "E", "O", "R", "Z"]);
  });

  test("newLineOrEmpty", () {
    expect(newLineOrEmpty(""), "");
    expect(newLineOrEmpty("Test"), "\n");
  });
}
