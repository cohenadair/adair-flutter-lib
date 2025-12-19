import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/l10n/l10n.dart';
import 'package:adair_flutter_lib/pages/scroll_page.dart';
import 'package:adair_flutter_lib/res/anim.dart';
import 'package:adair_flutter_lib/res/dimen.dart';
import 'package:adair_flutter_lib/widgets/loading.dart';
import 'package:adair_flutter_lib/wrappers/permission_handler_wrapper.dart';
import 'package:flutter/material.dart';

import '../res/style.dart';
import '../widgets/button.dart';
import '../widgets/transparent_app_bar.dart';
import '../widgets/watermark_logo.dart';

/// A page to be used to request notification permission from the user. It's a
/// simple page that includes a description of why the app is requesting
/// permission, and a button that actually performs the request.
///
/// When finished, pops from [Navigator] with a result of true if the
/// notification permission has been granted; false otherwise.
class NotificationPermissionPage extends StatefulWidget {
  final String description;

  const NotificationPermissionPage(this.description);

  @override
  State<NotificationPermissionPage> createState() =>
      _NotificationPermissionPageState();
}

class _NotificationPermissionPageState
    extends State<NotificationPermissionPage> {
  var _isPendingPermission = false;

  @override
  Widget build(BuildContext context) {
    return ScrollPage(
      appBar: TransparentAppBar(
        context,
        leading: CloseButton(
          color: AppConfig.get.colorAppTheme,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      children: [
        Container(height: paddingDefault),
        WatermarkLogo(
          icon: Icons.notifications,
          title: L10n.get.lib.notificationPermissionPageTitle,
        ),
        Container(height: paddingDefault),
        Padding(
          padding: insetsHorizontalDefault,
          child: Text(
            widget.description,
            textAlign: TextAlign.center,
            style: stylePrimary(context),
          ),
        ),
        Container(height: paddingDefault),
        AnimatedSwitcher(
          duration: animDurationDefault,
          child: _isPendingPermission
              ? const Loading(padding: insetsTopDefault)
              : _buildSetPermissionButton(),
        ),
        Container(height: paddingDefault),
      ],
    );
  }

  Widget _buildSetPermissionButton() {
    return Button(
      text: L10n.get.lib.setPermissionButton,
      onPressed: () async {
        setState(() => _isPendingPermission = true);
        var isGranted = await PermissionHandlerWrapper.get
            .requestNotification();
        setState(() => _isPendingPermission = false);

        if (mounted) {
          Navigator.pop(context, isGranted);
        }
      },
    );
  }
}
