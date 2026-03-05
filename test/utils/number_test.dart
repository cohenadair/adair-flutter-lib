import 'package:adair_flutter_lib/utils/number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("tryParse", () {
    // Empty input.
    expect(tryParseDouble(null), null);
    expect(tryParseDouble(""), null);

    // Invalid input.
    expect(tryParseDouble("Not a double"), null);

    // Valid input with dot.
    expect(tryParseDouble("10.5"), 10.5);

    // Valid input with comma.
    expect(tryParseDouble("10,5"), 10.5);

    // Other formats.
    expect(tryParseDouble("1,005,300.5"), 1005300.5);
    expect(tryParseDouble("1 005 300,5"), 1005300.5);
    expect(tryParseDouble("1.005.300,5"), 1005300.5);
    expect(tryParseDouble("1,005,300.543"), 1005300.543);
    expect(tryParseDouble("1 005 300,543"), 1005300.543);
    expect(tryParseDouble("1.005.300,543"), 1005300.543);
  });
}
