import 'package:adair_flutter_lib/l10n/l10n.dart';
import 'package:adair_flutter_lib/res/theme.dart';
import 'package:adair_flutter_lib/widgets/async_builder.dart';
import 'package:adair_flutter_lib/wrappers/package_info_wrapper.dart';
import 'package:flutter/material.dart';

class AppVersion extends StatelessWidget {
  /// When true, wraps the version string in a [ListTile] with a "Version"
  /// title.
  final bool inListTile;

  /// Style applied to the version text. Defaults to
  /// [BuildContext.styleLabelMediumSecondary].
  final TextStyle? style;

  const AppVersion({super.key, this.inListTile = false, this.style});

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder.future(
      future: PackageInfoWrapper.get.fromPlatform(),
      errorReason: "Failed to load package info",
      builder: (context, packageInfo) {
        final version = "${packageInfo.version} (${packageInfo.buildNumber})";
        return inListTile
            ? _buildListTile(context, version)
            : _buildVersionText(context, version);
      },
    );
  }

  Widget _buildVersionText(BuildContext context, String version) {
    return Text(version, style: style ?? context.styleLabelMediumSecondary);
  }

  Widget _buildListTile(BuildContext context, String version) {
    return ListTile(
      title: Text(L10n.get.lib.version),
      trailing: _buildVersionText(context, version),
    );
  }
}
