import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/l10n/l10n.dart';
import 'package:adair_flutter_lib/res/dimen.dart';
import 'package:adair_flutter_lib/res/theme.dart';
import 'package:adair_flutter_lib/widgets/empty_or.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

/// The page shown while initialization futures are completing.
class LandingPage extends StatelessWidget {
  static const _iconSize = 200.0;
  static const _iconHorizontalAlignment = 0.0;
  static const _iconVerticalAlignment = -0.5;

  final bool hasError;

  const LandingPage({required this.hasError});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorApp,
      body: Stack(
        children: [_buildLogo(), _buildInitError(), _buildCompanyName()],
      ),
    );
  }

  Widget _buildLogo() {
    return Align(
      alignment: Alignment(_iconHorizontalAlignment, _iconVerticalAlignment),
      child: Icon(AppConfig.get.appIcon, size: _iconSize, color: Colors.white),
    );
  }

  Widget _buildInitError() {
    return EmptyOr(
      isShowing: hasError,
      builder: (context) => Align(
        alignment: Alignment.center,
        child: Padding(
          padding: insetsDefault,
          child: Text(
            L10n.get.lib.landingPageInitError(AppConfig.get.appName()),
            style: context.styleError,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyName() {
    final name = AppConfig.get.companyName?.call();

    return EmptyOr(
      isShowing: isNotEmpty(name),
      builder: (context) => SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: insetsDefault,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(L10n.get.lib.by, style: context.styleOnAppSecondary),
                Text(name!, style: context.styleOnApp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
