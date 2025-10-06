import 'package:adair_flutter_lib/utils/dotted_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Parse bad input", () {
    expect(() => DottedVersion.parse(""), throwsException);
  });

  test("Parse major can't be parsed", () {
    expect(() => DottedVersion.parse("not a version"), throwsException);
  });

  test("Parse minor and patch default to 0", () {
    var version = DottedVersion.parse("16");
    expect(version.major, 16);
    expect(version.minor, 0);
    expect(version.patch, 0);

    version = DottedVersion.parse("16.5");
    expect(version.major, 16);
    expect(version.minor, 5);
    expect(version.patch, 0);

    version = DottedVersion.parse("16.1.2");
    expect(version.major, 16);
    expect(version.minor, 1);
    expect(version.patch, 2);
  });

  test("compareTo", () {
    expect(DottedVersion(10, 1, 3).compareTo(DottedVersion(11, 1, 3)), -1);
    expect(DottedVersion(10, 1, 3).compareTo(DottedVersion(10, 1, 3)), 0);
    expect(DottedVersion(10, 1, 3).compareTo(DottedVersion(9, 1, 3)), 1);
  });

  test("isLessThan", () {
    expect(DottedVersion(10, 1, 3).isLessThan("11.1.3"), isTrue);
    expect(DottedVersion(10, 1, 3).isLessThan("10.1.3"), isFalse);
    expect(DottedVersion(10, 1, 3).isLessThan("9.1.3"), isFalse);
    expect(DottedVersion(10, 1, 3).isLessThan("10.2.3"), isTrue);
    expect(DottedVersion(10, 1, 3).isLessThan("10.1.5"), isTrue);
  });

  test("Operator >", () {
    expect(DottedVersion(10, 1, 3) > DottedVersion(9, 1, 3), isTrue);
    expect(DottedVersion(10, 1, 3) > DottedVersion(10, 0, 3), isTrue);
    expect(DottedVersion(10, 1, 3) > DottedVersion(9, 1, 2), isTrue);
  });

  test("Operator <=", () {
    expect(DottedVersion(10, 1, 3) <= DottedVersion(10, 1, 3), isTrue);
    expect(DottedVersion(10, 1, 3) <= DottedVersion(11, 1, 3), isTrue);
  });

  test("Operator >=", () {
    expect(DottedVersion(10, 1, 3) >= DottedVersion(10, 1, 3), isTrue);
    expect(DottedVersion(10, 1, 3) >= DottedVersion(9, 1, 3), isTrue);
  });

  test("Operator ==", () {
    expect(DottedVersion(10, 1, 3) == DottedVersion(10, 1, 3), isTrue);
    // ignore: unrelated_type_equality_checks
    expect(DottedVersion(10, 1, 3) == "Not a dotted version", isFalse);
  });

  test("hashCode", () {
    var v1 = DottedVersion(10, 1, 3);
    var v2 = DottedVersion(10, 1, 3);
    var v3 = DottedVersion(11, 0, 0);

    expect(v1.hashCode, v2.hashCode);
    expect(v1.hashCode == v3.hashCode, isFalse);
  });

  test("toString", () {
    expect(DottedVersion(10, 1, 3).toString(), "10.1.3");
  });
}
