import 'package:adair_flutter_lib/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    AppConfig.reset();
  });

  test("appName is set", () {
    AppConfig.get.init(appName: () => "Test App");
    expect(AppConfig.get.appName(), "Test App");
  });

  test("companyName is null when not provided", () {
    AppConfig.get.init(appName: () => "Test App");
    expect(AppConfig.get.companyName, isNull);
  });

  test("companyName is set when provided", () {
    AppConfig.get.init(
      appName: () => "Test App",
      companyName: () => "Test Corp",
    );
    expect(AppConfig.get.companyName!(), "Test Corp");
  });

  test("appIcon defaults to Icons.not_interested when not provided", () {
    AppConfig.get.init(appName: () => "Test App");
    expect(AppConfig.get.appIcon, Icons.not_interested);
  });

  test("appIcon is set when provided", () {
    AppConfig.get.init(appName: () => "Test App", appIcon: Icons.home);
    expect(AppConfig.get.appIcon, Icons.home);
  });

  test("colorAppTheme defaults to Colors.pink when not provided", () {
    AppConfig.get.init(appName: () => "Test App");
    // ignore: deprecated_member_use
    expect(AppConfig.get.colorAppTheme, Colors.pink);
  });

  test("colorAppTheme is set when provided", () {
    AppConfig.get.init(
      appName: () => "Test App",
      // ignore: deprecated_member_use
      colorAppTheme: Colors.blue,
    );
    // ignore: deprecated_member_use
    expect(AppConfig.get.colorAppTheme, Colors.blue);
  });

  test("colorAppBarContent defaults to white when not provided", () {
    AppConfig.get.init(appName: () => "Test App");
    expect(AppConfig.get.colorAppBarContent(true), Colors.white);
    expect(AppConfig.get.colorAppBarContent(false), Colors.white);
  });

  test("colorAppBarContent is set when provided", () {
    AppConfig.get.init(
      appName: () => "Test App",
      colorAppBarContent: (isDark) => isDark ? Colors.black : Colors.white,
    );
    expect(AppConfig.get.colorAppBarContent(true), Colors.black);
    expect(AppConfig.get.colorAppBarContent(false), Colors.white);
  });

  test("themeMode defaults to ThemeMode.system when not provided", () {
    AppConfig.get.init(appName: () => "Test App");
    expect(AppConfig.get.themeMode(), ThemeMode.system);
  });

  test("themeMode is set when provided", () {
    AppConfig.get.init(
      appName: () => "Test App",
      themeMode: () => ThemeMode.dark,
    );
    expect(AppConfig.get.themeMode(), ThemeMode.dark);
  });
}
