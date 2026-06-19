import 'package:adair_flutter_lib/l10n/l10n.dart';
import 'package:adair_flutter_lib/managers/subscription_manager.dart';
import 'package:adair_flutter_lib/res/theme.dart';
import 'package:adair_flutter_lib/widgets/chip_button.dart';
import 'package:flutter/material.dart';

import '../utils/page.dart';

/// A badge or button that displays "Pro" if the user is a free user. This is
/// meant to convey that the current page includes some Pro functionality that
/// isn't explicitly triggered by a button or other user action. When this
/// button is tapped, the given pro page widget is shown.
class ProChipButton extends StatelessWidget {
  final Widget proPage;
  final bool isOnAppColor;

  const ProChipButton(this.proPage, {this.isOnAppColor = false});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: SubscriptionManager.get.stream,
      builder: (context, _) {
        if (SubscriptionManager.get.isPro) {
          return const SizedBox();
        }

        return ChipButton(
          label: L10n.get.lib.proChipButtonLabel,
          icon: Icons.stars,
          backgroundColor: isOnAppColor ? context.colorOnApp : null,
          textColor: isOnAppColor ? context.colorApp : Colors.white,
          onPressed: () => present(context, proPage),
        );
      },
    );
  }
}
