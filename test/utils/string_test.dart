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

  test("capitalize returns empty string when input is empty", () {
    expect("".capitalize, "");
  });

  test("capitalize uppercases a single character", () {
    expect("a".capitalize, "A");
  });

  test(
    "capitalize uppercases only the first character and leaves the rest unchanged",
    () {
      expect("hello world".capitalize, "Hello world");
    },
  );

  test("capitalize leaves already-uppercase first character unchanged", () {
    expect("Hello".capitalize, "Hello");
  });

  test("format replaces %s placeholders with args in order", () {
    expect(
      format("Hello %s, you are %s", ["World", "great"]),
      "Hello World, you are great",
    );
  });

  test("format with no placeholders returns the original string", () {
    expect(format("No placeholders", []), "No placeholders");
  });

  test("equalsTrimmedIgnoreCase returns true for matching strings", () {
    expect(equalsTrimmedIgnoreCase("Hello", "hello"), isTrue);
  });

  test("equalsTrimmedIgnoreCase trims whitespace before comparing", () {
    expect(equalsTrimmedIgnoreCase("  Hello  ", "hello"), isTrue);
  });

  test("equalsTrimmedIgnoreCase returns false for non-matching strings", () {
    expect(equalsTrimmedIgnoreCase("Hello", "World"), isFalse);
  });

  test("containsTrimmedLowerCase returns true when substring is found", () {
    expect(containsTrimmedLowerCase("Hello World", "world"), isTrue);
  });

  test(
    "containsTrimmedLowerCase returns false when substring is not found",
    () {
      expect(containsTrimmedLowerCase("Hello World", "xyz"), isFalse);
    },
  );

  test("formatList returns empty string for empty list", () {
    expect(formatList([]), "");
  });

  test("formatList returns the single item for a one-element list", () {
    expect(formatList(["Alpha"]), "Alpha");
  });

  test("formatList joins non-empty items with a comma and space", () {
    expect(formatList(["Alpha", "Beta", "Gamma"]), "Alpha, Beta, Gamma");
  });

  test("formatList skips empty string items", () {
    expect(formatList(["Alpha", "", "Gamma"]), "Alpha, Gamma");
  });

  test("formatBytes formats bytes below 1000 as B", () {
    expect(formatBytes(512), "512 B");
  });

  test("formatBytes formats values in the KB range", () {
    expect(formatBytes(1500), "1.5 KB");
  });

  test("formatBytes formats values in the MB range", () {
    expect(formatBytes(115_868_672), "115.9 MB");
  });

  test("formatBytes formats values in the GB range", () {
    expect(formatBytes(2_000_000_000), "2.0 GB");
  });

  test("toIntId returns a consistent positive int for the same input", () {
    expect("hello".toIntId, "hello".toIntId);
    expect("hello".toIntId >= 0, isTrue);
  });

  test("toIntId returns different values for different inputs", () {
    expect("hello".toIntId, isNot("world".toIntId));
  });
}
