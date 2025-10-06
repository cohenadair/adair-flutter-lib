import 'dart:async';

/// Returns a list of all logs printed to the console.
List<String> capturePrintStatements(void Function() work) {
  final result = <String>[];

  // Run the code in a custom Zone that intercepts print.
  runZoned(
    work,
    zoneSpecification: ZoneSpecification(
      print: (_, __, ___, line) => result.add(line),
    ),
  );

  return result;
}
