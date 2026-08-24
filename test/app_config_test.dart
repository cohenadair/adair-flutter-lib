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

  test("signInLogo throws when not provided", () {
    AppConfig.get.init(appName: () => "Test App");
    expect(() => AppConfig.get.signInLogo, throwsA(isA<AssertionError>()));
  });

  test("signInLogo is set when provided", () {
    AppConfig.get.init(
      appName: () => "Test App",
      signInLogo: "assets/sign_in.svg",
    );
    expect(AppConfig.get.signInLogo, "assets/sign_in.svg");
  });

  test("landingLogo throws when not provided", () {
    AppConfig.get.init(appName: () => "Test App");
    expect(() => AppConfig.get.landingLogo, throwsA(isA<AssertionError>()));
  });

  test("landingLogo is set when provided", () {
    AppConfig.get.init(
      appName: () => "Test App",
      landingLogo: "assets/landing.svg",
    );
    expect(AppConfig.get.landingLogo, "assets/landing.svg");
  });

  test("proLogo throws when not provided", () {
    AppConfig.get.init(appName: () => "Test App");
    expect(() => AppConfig.get.proLogo, throwsA(isA<AssertionError>()));
  });

  test("proLogo is set when provided", () {
    AppConfig.get.init(appName: () => "Test App", proLogo: "assets/pro.svg");
    expect(AppConfig.get.proLogo, "assets/pro.svg");
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
