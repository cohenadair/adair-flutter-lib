import 'dart:io';

import 'package:adair_flutter_lib/utils/io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  setUp(() async {
    managers = await StubbedManagers.create();
  });

  test("isConnected returns true when example.com resolves", () async {
    when(
      managers.ioWrapper.lookup("example.com"),
    ).thenAnswer((_) async => [InternetAddress("93.184.216.34")]);
    expect(await isConnected(), isTrue);
  });

  test("isConnected returns true when only google.com resolves", () async {
    when(managers.ioWrapper.lookup("example.com")).thenAnswer((_) async => []);
    when(
      managers.ioWrapper.lookup("google.com"),
    ).thenAnswer((_) async => [InternetAddress("142.250.80.46")]);
    expect(await isConnected(), isTrue);
  });

  test("isConnected returns false when both lookups return empty", () async {
    when(managers.ioWrapper.lookup("example.com")).thenAnswer((_) async => []);
    when(managers.ioWrapper.lookup("google.com")).thenAnswer((_) async => []);
    expect(await isConnected(), isFalse);
  });
}
