import 'dart:async';

/// Returns a list of all logs printed to the console.
Future<List<String>> capturePrintStatements(
  FutureOr<void> Function() work,
) async {
  final result = <String>[];

  // Run the code in a custom Zone that intercepts print.
  await runZoned<FutureOr<void>>(
    work,
    zoneSpecification: ZoneSpecification(
      print: (_, __, ___, line) => result.add(line),
    ),
  );

  return result;
}
