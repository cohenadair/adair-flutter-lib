import 'package:adair_flutter_lib/l10n/l10n.dart';
import 'package:adair_flutter_lib/res/theme.dart';
import 'package:adair_flutter_lib/widgets/async_builder.dart';
import 'package:adair_flutter_lib/wrappers/package_info_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion extends StatefulWidget {
  /// When true, wraps the version string in a [ListTile] with a "Version"
  /// title.
  final bool inListTile;

  /// Style applied to the version text. Defaults to
  /// [BuildContext.styleLabelMediumSecondary].
  final TextStyle? style;

  const AppVersion({super.key, this.inListTile = false, this.style});

  @override
  State<AppVersion> createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersion> {
  // The package info never changes while the app is running, but an
  // ancestor can rebuild this widget many times (e.g. via setState). Fetch
  // it once per State instance so repeated builds don't cause the version
  // to flicker while AsyncBuilder awaits a fresh future.
  late final Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfoWrapper.get.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder.future(
      future: _packageInfoFuture,
      errorReason: "Failed to load package info",
      builder: (context, packageInfo) {
        final version = "${packageInfo.version} (${packageInfo.buildNumber})";
        return widget.inListTile
            ? _buildListTile(version)
            : _buildVersionText(version);
      },
    );
  }

  Widget _buildVersionText(String version) {
    return Text(
      version,
      style: widget.style ?? context.styleLabelMediumSecondary,
    );
  }

  Widget _buildListTile(String version) {
    return ListTile(
      title: Text(L10n.get.lib.version),
      trailing: _buildVersionText(version),
    );
  }
}
