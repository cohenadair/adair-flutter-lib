import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/pages/scroll_page.dart';
import 'package:adair_flutter_lib/widgets/app_color_icon.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../managers/subscription_manager.dart';
import '../res/anim.dart';
import '../res/dimen.dart';
import '../res/style.dart';
import '../src/strings.dart';
import '../utils/dialog.dart';
import '../utils/widget.dart';
import '../widgets/horizontal_space.dart';
import '../widgets/loading.dart';
import '../widgets/question_answer_link.dart';
import '../widgets/title_text.dart';
import '../widgets/vertical_space.dart';
import '../widgets/work_result.dart';
import '../wrappers/io_wrapper.dart';

class ProPage extends StatefulWidget {
  final List<ProPageFeatureRow> features;
  final VoidCallback? onCloseOverride;
  final bool isEmbeddedInScrollPage;

  const ProPage({
    this.features = const [],
    this.onCloseOverride,
    this.isEmbeddedInScrollPage = true,
  });

  @override
  ProPageState createState() => ProPageState();
}

class ProPageState extends State<ProPage> {
  static const _logoHeight = 150.0;
  static const _maxButtonsContainerWidth = 325.0;

  late Future<Subscriptions?> _subscriptionsFuture;
  var _isPendingTransaction = false;

  @override
  void initState() {
    super.initState();
    _subscriptionsFuture = SubscriptionManager.get.subscriptions();
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      const VerticalSpace(paddingDefault),
      Icon(
        AppConfig.get.appIcon,
        size: _logoHeight,
        color: AppConfig.get.colorAppTheme,
      ),
      Text(
        Strings.of(context).proPageUpgradeTitle(AppConfig.get.appName(context)),
        style: styleTitle2(context),
      ),
      const VerticalSpace(paddingSmall),
      TitleText.style1(Strings.of(context).proPageProTitle),
      const VerticalSpace(paddingSmall),
      const AppColorIcon(Icons.stars),
      const VerticalSpace(paddingXL),
      ...widget.features,
      const VerticalSpace(paddingXL),
      _buildSubscriptionState(),
    ];

    if (widget.isEmbeddedInScrollPage) {
      return ScrollPage(
        children: [
          Stack(
            children: [
              Padding(
                padding: insetsTiny,
                child: CloseButton(
                  onPressed: () => Navigator.of(context).pop(),
                  color: AppConfig.get.colorAppTheme,
                ),
              ),
              Padding(
                padding: insetsHorizontalDefaultBottomDefault,
                child: Column(children: children),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(children: children);
    }
  }

  Widget _buildSubscriptionState() {
    Widget child;

    if (_isPendingTransaction) {
      child = const Loading();
    } else if (SubscriptionManager.get.isPro) {
      child = WorkResult.success(
        description: Strings.of(context).proPageUpgradeSuccess,
      );
    } else {
      child = FutureBuilder<Subscriptions?>(
        future: _subscriptionsFuture,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: animDurationDefault,
            child:
                snapshot.connectionState != ConnectionState.done
                    ? const Loading()
                    : _buildSubscriptionOptions(snapshot.data),
          );
        },
      );
    }

    return AnimatedSwitcher(duration: animDurationDefault, child: child);
  }

  Widget _buildSubscriptionOptions(Subscriptions? subscriptions) {
    if (subscriptions == null) {
      return WorkResult.error(
        description: Strings.of(context).proPageFetchError,
      );
    }

    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: _maxButtonsContainerWidth,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSubscriptionButton(
                sub: subscriptions.yearly,
                priceText: Strings.of(context).proPageYearlyTitle,
                trialText: Strings.of(context).proPageYearlyTrial,
                billingFrequencyText: Strings.of(context).proPageYearlySubtext,
              ),
              const HorizontalSpace(paddingDefault),
              _buildSubscriptionButton(
                sub: subscriptions.monthly,
                priceText: Strings.of(context).proPageMonthlyTitle,
                trialText: Strings.of(context).proPageMonthlyTrial,
                billingFrequencyText: Strings.of(context).proPageMonthlySubtext,
              ),
            ],
          ),
        ),
        const VerticalSpace(paddingDefault),
        QuestionAnswerLink(
          question: Strings.of(context).proPageRestoreQuestion,
          actionText: Strings.of(context).proPageRestoreAction,
          action: _restoreSubscription,
        ),
        const VerticalSpace(paddingDefault),
        Text(
          IoWrapper.get.isAndroid
              ? Strings.of(context).proPageDisclosureAndroid
              : Strings.of(context).proPageDisclosureApple,
          style: styleSubtext,
        ),
      ],
    );
  }

  Widget _buildSubscriptionButton({
    required Subscription sub,
    required String Function(String) priceText,
    required String Function(int) trialText,
    required String billingFrequencyText,
  }) {
    assert(isNotEmpty(billingFrequencyText));

    return Expanded(
      child: ElevatedButton(
        child: Padding(
          padding: insetsVerticalSmall,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                priceText(sub.price),
                style: stylePrimary(
                  context,
                ).copyWith(fontWeight: fontWeightBold),
              ),
              const VerticalSpace(paddingTiny),
              Text(trialText(sub.trialLengthDays)),
              const VerticalSpace(paddingTiny),
              Text(billingFrequencyText, style: styleSubtext),
            ],
          ),
        ),
        onPressed: () => _purchaseSubscription(sub),
      ),
    );
  }

  Future<void> _restoreSubscription() async {
    _setIsPendingTransaction(true);

    var strings = Strings.of(context);
    var result = await SubscriptionManager.get.restoreSubscription();

    _setIsPendingTransaction(false);

    String? dialogMessage;
    switch (result) {
      case RestoreSubscriptionResult.noSubscriptionsFound:
        dialogMessage =
            IoWrapper.get.isAndroid
                ? strings.proPageRestoreNoneFoundGooglePlay
                : strings.proPageRestoreNoneFoundAppStore;
        break;
      case RestoreSubscriptionResult.error:
        dialogMessage = strings.proPageRestoreError;
        break;
      case RestoreSubscriptionResult.success:
        // Nothing to do.
        break;
    }

    // Something went wrong, tell the user to make sure they're signed in to
    // the correct storefront account.
    if (isNotEmpty(dialogMessage)) {
      safeUseContext(
        this,
        () => showErrorDialog(context: context, description: dialogMessage!),
      );
    }
  }

  void _purchaseSubscription(Subscription sub) {
    _setIsPendingTransaction(true);
    SubscriptionManager.get
        .purchaseSubscription(sub)
        .then((_) => _setIsPendingTransaction(false));
  }

  void _setIsPendingTransaction(bool pending) {
    // ProPage can be dismissed before purchaseSubscription has completed,
    // requiring safeUseContext here.
    safeUseContext(this, () => setState(() => _isPendingTransaction = pending));
  }
}

class ProPageFeatureRow extends StatelessWidget {
  final String description;

  const ProPageFeatureRow(this.description);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            description,
            style: stylePrimary(context),
            overflow: TextOverflow.visible,
          ),
        ),
        const HorizontalSpace(paddingDefault),
        const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: iconSizeLarge,
        ),
      ],
    );
  }
}
