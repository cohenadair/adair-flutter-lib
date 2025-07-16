import 'package:adair_flutter_lib/app_config.dart';
import 'package:adair_flutter_lib/pages/scroll_page.dart';
import 'package:adair_flutter_lib/widgets/app_color_icon.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../l10n/l10n.dart';
import '../managers/subscription_manager.dart';
import '../res/anim.dart';
import '../res/dimen.dart';
import '../res/style.dart';
import '../utils/dialog.dart';
import '../utils/widget.dart';
import '../widgets/empty.dart';
import '../widgets/horizontal_space.dart';
import '../widgets/loading.dart';
import '../widgets/question_answer_link.dart';
import '../widgets/title_text.dart';
import '../widgets/vertical_space.dart';
import '../widgets/work_result.dart';
import '../wrappers/io_wrapper.dart';

class ProPage extends StatefulWidget {
  final List<ProPageFeatureRow> features;
  final Widget? footnote;
  final bool embedInScrollPage;
  final EdgeInsets logoPadding;

  const ProPage({
    this.features = const [],
    this.footnote,
    this.embedInScrollPage = true,
    this.logoPadding = insetsVerticalDefault,
  });

  @override
  ProPageState createState() => ProPageState();
}

class ProPageState extends State<ProPage> {
  static const _logoHeight = 150.0;
  static const _maxButtonsContainerWidth = 350.0;

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
      Padding(
        padding: widget.logoPadding,
        child: Icon(
          AppConfig.get.appIcon,
          size: _logoHeight,
          color: AppConfig.get.colorAppTheme,
        ),
      ),
      Text(
        L10n.get.lib.proPageUpgradeTitle(AppConfig.get.appName()),
        style: styleTitle2(context),
        textAlign: TextAlign.center,
      ),
      const VerticalSpace(paddingSmall),
      TitleText.style1(L10n.get.lib.proPageProTitle),
      const VerticalSpace(paddingSmall),
      const AppColorIcon(Icons.stars),
      const VerticalSpace(paddingXL),
      Column(spacing: paddingDefault, children: widget.features),
      const VerticalSpace(paddingXL),
      _buildSubscriptionState(),
      _buildFootnote(),
    ];

    if (widget.embedInScrollPage) {
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
        description: L10n.get.lib.proPageUpgradeSuccess,
      );
    } else {
      child = FutureBuilder<Subscriptions?>(
        future: _subscriptionsFuture,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: animDurationDefault,
            child: snapshot.connectionState != ConnectionState.done
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
      return WorkResult.error(description: L10n.get.lib.proPageFetchError);
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
                priceCallback: L10n.get.lib.proPageYearlyTitle,
                trialCallback: L10n.get.lib.proPageYearlyTrial,
                billingFrequencyText: L10n.get.lib.proPageYearlySubtext,
              ),
              const HorizontalSpace(paddingDefault),
              _buildSubscriptionButton(
                sub: subscriptions.monthly,
                priceCallback: L10n.get.lib.proPageMonthlyTitle,
                trialCallback: L10n.get.lib.proPageMonthlyTrial,
                billingFrequencyText: L10n.get.lib.proPageMonthlySubtext,
              ),
            ],
          ),
        ),
        const VerticalSpace(paddingDefault),
        QuestionAnswerLink(
          textAlign: TextAlign.center,
          question: L10n.get.lib.proPageRestoreQuestion,
          actionText: L10n.get.lib.proPageRestoreAction,
          action: _restoreSubscription,
        ),
        const VerticalSpace(paddingDefault),
        Text(
          IoWrapper.get.isAndroid
              ? L10n.get.lib.proPageDisclosureAndroid
              : L10n.get.lib.proPageDisclosureApple,
          style: styleSubtext,
        ),
      ],
    );
  }

  Widget _buildSubscriptionButton({
    required Subscription sub,
    required String Function(String) priceCallback,
    required String Function(int) trialCallback,
    required String billingFrequencyText,
  }) {
    assert(isNotEmpty(billingFrequencyText));

    Widget trialLengthWidget = const Empty();
    var trialLength = sub.trialLengthDays;
    if (trialLength != null) {
      trialLengthWidget = Padding(
        padding: insetsBottomTiny,
        child: Text(trialCallback(trialLength)),
      );
    }

    return Expanded(
      child: ElevatedButton(
        child: Padding(
          padding: insetsVerticalSmall,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                priceCallback(sub.price),
                style: stylePrimary(
                  context,
                ).copyWith(fontWeight: fontWeightBold),
              ),
              const VerticalSpace(paddingTiny),
              trialLengthWidget,
              Text(
                billingFrequencyText,
                style: styleSubtext,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        onPressed: () => _purchaseSubscription(sub),
      ),
    );
  }

  Widget _buildFootnote() {
    if (widget.footnote == null) {
      return const Empty();
    }
    return Padding(padding: insetsTopDefault, child: widget.footnote);
  }

  Future<void> _restoreSubscription() async {
    _setIsPendingTransaction(true);
    var result = await SubscriptionManager.get.restoreSubscription();

    _setIsPendingTransaction(false);

    String? dialogMessage;
    switch (result) {
      case RestoreSubscriptionResult.noSubscriptionsFound:
        dialogMessage = IoWrapper.get.isAndroid
            ? L10n.get.lib.proPageRestoreNoneFoundGooglePlay
            : L10n.get.lib.proPageRestoreNoneFoundAppStore;
        break;
      case RestoreSubscriptionResult.error:
        dialogMessage = L10n.get.lib.proPageRestoreError;
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
        () => showErrorDialog(
          context: context,
          description: Text(dialogMessage!),
        ),
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
