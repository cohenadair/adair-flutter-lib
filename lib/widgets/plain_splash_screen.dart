import 'package:flutter/material.dart';

/// A fullscreen widget that matches the native splash screen — plain scaffold
/// background color and no app bar. Used while the app is initializing or when
/// it is in the background.
///
/// The native launch/splash screens should be generated using
/// flutter_native_splash (see activity-log/mobile/pubspec.yaml for an example).
class PlainSplashScreen extends StatelessWidget {
  const PlainSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const SizedBox.expand(),
    );
  }
}
