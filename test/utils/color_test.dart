import 'package:adair_flutter_lib/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("parseHexColor returns null for empty hex string", () {
    expect(parseHexColor(""), isNull);
  });

  test("parseHexColor parses 6-char hex without #", () {
    expect(parseHexColor("FF0000"), equals(const Color(0xFFFF0000)));
  });

  test("parseHexColor strips leading # before parsing", () {
    expect(parseHexColor("#FF0000"), equals(const Color(0xFFFF0000)));
  });

  test("parseHexColor parses black", () {
    expect(parseHexColor("000000"), equals(const Color(0xFF000000)));
  });

  test("parseHexColor parses white", () {
    expect(parseHexColor("FFFFFF"), equals(const Color(0xFFFFFFFF)));
  });

  test("parseHexColor always produces a fully opaque color", () {
    expect(parseHexColor("1565C0")!.clampedAlpha, equals(0xFF));
  });

  test("isColorReadable returns false if primary is null", () {
    expect(isColorReadable(null, Colors.white), isFalse);
  });

  test("isColorReadable returns false if secondary is null", () {
    expect(isColorReadable(null, Colors.white), isFalse);
  });

  test("isColorReadable returns true for black on white (~21:1 contrast)", () {
    expect(isColorReadable(Colors.black, Colors.white), isTrue);
  });

  test("isColorReadable returns true for white on black (symmetric)", () {
    expect(isColorReadable(Colors.white, Colors.black), isTrue);
  });

  test("isColorReadable returns false for white on white (1:1 contrast)", () {
    expect(isColorReadable(Colors.white, Colors.white), isFalse);
  });

  test("isColorReadable returns false for black on black (1:1 contrast)", () {
    expect(isColorReadable(Colors.black, Colors.black), isFalse);
  });

  test(
    "isColorReadable returns false for near-white on white (~1.15:1 contrast)",
    () {
      expect(isColorReadable(const Color(0xFFEEEEEE), Colors.white), isFalse);
    },
  );

  test(
    "isColorReadable returns true for near-black on white (~17:1 contrast)",
    () {
      expect(isColorReadable(const Color(0xFF111111), Colors.white), isTrue);
    },
  );

  test(
    "isColorReadable returns true for red on white (~4.0:1) with default threshold of 3.0",
    () {
      expect(isColorReadable(const Color(0xFFFF0000), Colors.white), isTrue);
    },
  );

  test(
    "isColorReadable returns false for red on white (~4.0:1) with threshold of 4.5",
    () {
      expect(
        isColorReadable(
          const Color(0xFFFF0000),
          Colors.white,
          minContrastRatio: 4.5,
        ),
        isFalse,
      );
    },
  );
}
