import 'package:adair_flutter_lib/managers/manager.dart';
import 'package:adair_flutter_lib/widgets/safe_future_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../app_config.dart';
import '../l10n/gen/adair_flutter_lib_localizations.dart';
import '../pages/sign_in_page.dart';
import '../utils/root.dart';
import '../wrappers/firebase_auth_wrapper.dart';

class AdairFlutterLibApp extends StatefulWidget {
  /// A list of managers that need to be initialized before the app starts.
  /// While these managers initialize, a loading page is shown before either
  /// the [SignInPage] or [homeBuilder].
  final List<Manager> managers;

  /// True if user authentication using Firebase is required; false otherwise.
  final bool requiresAuth;

  /// See [MaterialApp.theme].
  final ThemeData? theme;

  /// See [MaterialApp.darkTheme].
  final ThemeData? darkTheme;

  /// See [MaterialApp.themeMode].
  final ThemeMode? themeMode;

  /// The home page of the app. If [requiresAuth] is true, this page is rendered
  /// only if the user is signed in.
  final WidgetBuilder homeBuilder;

  /// See [MaterialApp.localizationsDelegates]. [AdairFlutterLibLocalizations],
  /// [GlobalMaterialLocalizations], [GlobalWidgetsLocalizations], and
  /// [GlobalCupertinoLocalizations] are included automatically.
  final Iterable<LocalizationsDelegate> localizationsDelegates;

  /// See [MaterialApp.supportedLocales]. US and Canadian English are included
  /// automatically.
  final Iterable<Locale> supportedLocales;

  const AdairFlutterLibApp({
    this.managers = const [],
    this.requiresAuth = false,
    this.theme,
    this.darkTheme,
    this.themeMode,
    required this.homeBuilder,
    this.localizationsDelegates = const [],
    this.supportedLocales = const [],
  });

  @override
  State<AdairFlutterLibApp> createState() => _AdairFlutterLibAppState();
}

class _AdairFlutterLibAppState extends State<AdairFlutterLibApp> {
  late final Future<void> _initAppFuture;
  late final Stream<User?> _authStateStream;

  @override
  void initState() {
    super.initState();
    _initAppFuture = _initApp();
    _authStateStream = FirebaseAuthWrapper.get.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) {
        Root.get.buildContext = context;
        return AppConfig.get.appName();
      },
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      themeMode: widget.themeMode,
      home: SafeFutureBuilder(
        future: _initAppFuture,
        errorReason: "Initializing app",
        loadingBuilder: _buildLoadingPage,
        builder: (context, _) => _buildStartPage(context),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AdairFlutterLibLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ...widget.localizationsDelegates,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('en', 'CA'),
        ...widget.supportedLocales,
      ],
    );
  }

  Widget _buildLoadingPage(BuildContext context) {
    // TODO: Replace with LandingPage + error handling from Anglers'
    //  Log/SafeFutureBuilder.
    return Scaffold(backgroundColor: Theme.of(context).colorScheme.surface);
  }

  Widget _buildStartPage(BuildContext context) {
    if (!widget.requiresAuth) {
      return widget.homeBuilder(context);
    }

    return StreamBuilder<User?>(
      stream: _authStateStream,
      builder: (_, snapshot) {
        // TODO: Pass to LandingPage.
        if (snapshot.hasError) {
          return Text("Something went wrong on sign in: ${snapshot.error}");
        }

        // TODO: Pass to LandingPage.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        if (!snapshot.hasData) {
          return const SignInPage();
        }

        return widget.homeBuilder(context);
      },
    );
  }

  Future<void> _initApp() async {
    for (var manager in widget.managers) {
      await manager.init();
    }
  }
}
