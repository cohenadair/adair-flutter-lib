import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/l10n/l10n.dart';
import 'package:adair_flutter_lib/res/dimen.dart';
import 'package:adair_flutter_lib/res/theme.dart';
import 'package:adair_flutter_lib/widgets/empty_or.dart';
import 'package:adair_flutter_lib/widgets/error_text.dart';
import 'package:adair_flutter_lib/widgets/tinted_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

// TODO: Move to a "plain" (single colour matching home page) landing/splash
//  page. Convert this to an "error page" to be used exclusively for startup
//  errors.

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
      body: Stack(
        children: [_buildLogo(), _buildInitError(), _buildCompanyName()],
      ),
    );
  }

  Widget _buildLogo() {
    return Align(
      alignment: Alignment(_iconHorizontalAlignment, _iconVerticalAlignment),
      child: TintedSvgPicture(AppConfig.get.landingLogo, maxHeight: _iconSize),
    );
  }

  Widget _buildInitError() {
    return EmptyOr(
      isShowing: hasError,
      builder: (context) => Align(
        alignment: Alignment.center,
        child: Padding(
          padding: insetsDefault,
          child: ErrorText(
            error: L10n.get.lib.landingPageInitError(AppConfig.get.appName()),
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
                Text(
                  L10n.get.lib.by,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.colorSecondaryText,
                  ),
                ),
                Text(
                  name!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: context.colorText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
