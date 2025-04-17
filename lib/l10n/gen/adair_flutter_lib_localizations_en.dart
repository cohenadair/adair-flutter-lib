// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'adair_flutter_lib_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AdairFlutterLibLocalizationsEn extends AdairFlutterLibLocalizations {
  AdairFlutterLibLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get ok => 'Ok';

  @override
  String get error => 'Error';

  @override
  String get warning => 'Warning';

  @override
  String get continueString => 'Continue';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String yearsFormat(int numOfYears) {
    return '${numOfYears}y';
  }

  @override
  String daysFormat(int numOfDays) {
    return '${numOfDays}d';
  }

  @override
  String hoursFormat(int numOfHours) {
    return '${numOfHours}h';
  }

  @override
  String minutesFormat(int numOfMinutes) {
    return '${numOfMinutes}m';
  }

  @override
  String secondsFormat(int numOfSeconds) {
    return '${numOfSeconds}s';
  }

  @override
  String dateTimeFormat(String date, String time) {
    return '$date at $time';
  }

  @override
  String dateRangeFormat(String from, String to) {
    return '$from to $to';
  }

  @override
  String get now => 'Now';

  @override
  String get durationAllDates => 'All dates';

  @override
  String get durationToday => 'Today';

  @override
  String get durationYesterday => 'Yesterday';

  @override
  String get durationThisWeek => 'This week';

  @override
  String get durationThisMonth => 'This month';

  @override
  String get durationThisYear => 'This year';

  @override
  String get durationLastWeek => 'Last week';

  @override
  String get durationLastMonth => 'Last month';

  @override
  String get durationLastYear => 'Last year';

  @override
  String get durationLast7Days => 'Last 7 days';

  @override
  String get durationLast14Days => 'Last 14 days';

  @override
  String get durationLast30Days => 'Last 30 days';

  @override
  String get durationLast60Days => 'Last 60 days';

  @override
  String get durationLast12Months => 'Last 12 months';

  @override
  String get durationCustom => 'Custom';

  @override
  String proPageUpgradeTitle(String appName) {
    return 'Upgrade to $appName Pro';
  }

  @override
  String get proPageProTitle => 'Pro';

  @override
  String proPageYearlyTitle(String price) {
    return '$price/year';
  }

  @override
  String proPageYearlyTrial(int numOfDays) {
    return '+$numOfDays days free';
  }

  @override
  String get proPageYearlySubtext => 'Billed annually';

  @override
  String proPageMonthlyTitle(String price) {
    return '$price/month';
  }

  @override
  String proPageMonthlyTrial(int numOfDays) {
    return '+$numOfDays days free';
  }

  @override
  String get proPageMonthlySubtext => 'Billed monthly';

  @override
  String get proPageFetchError =>
      'Unable to fetch subscription options. Please ensure your device is connected to the internet and try again.';

  @override
  String get proPageUpgradeSuccess =>
      'Congratulations, you are now a Pro user!';

  @override
  String get proPageRestoreQuestion => 'Subscribed to Pro on another device?';

  @override
  String get proPageRestoreAction => 'Restore.';

  @override
  String get proPageRestoreNoneFoundAppStore =>
      'There were no previous purchases found. Please ensure you are signed in to the same Apple ID with which you made the original purchase.';

  @override
  String get proPageRestoreNoneFoundGooglePlay =>
      'There were no previous purchases found. Please ensure you are signed in to the same Google account with which you made the original purchase.';

  @override
  String get proPageRestoreError =>
      'Unexpected error occurred. Please ensure your device is connected to the internet and try again.';

  @override
  String get proPageDisclosureApple =>
      'Cancel anytime. Billing starts after the free trial period ends. The free trial period is only valid for new subscribers. Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current subscription period. All subscriptions can be managed through the App Store. Any unused portion of the free trial will be forfeited when a subscription is purchased.';

  @override
  String get proPageDisclosureAndroid =>
      'Cancel anytime. Billing starts after the free trial period ends. The free trial period is only valid for new subscribers. Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current subscription period. All subscriptions can be managed through the Google Play Store. Any unused portion of the free trial will be forfeited when a subscription is purchased.';
}

/// The translations for English, as used in the United States (`en_US`).
class AdairFlutterLibLocalizationsEnUs extends AdairFlutterLibLocalizationsEn {
  AdairFlutterLibLocalizationsEnUs() : super('en_US');

  @override
  String get proPageDisclosureApple =>
      'Cancel anytime. Billing starts after the free trial period ends. The free trial period is only valid for new subscribers. Subscriptions automatically renew unless canceled at least 24 hours before the end of the current subscription period. All subscriptions can be managed through the App Store. Any unused portion of the free trial will be forfeited when a subscription is purchased.';

  @override
  String get proPageDisclosureAndroid =>
      'Cancel anytime. Billing starts after the free trial period ends. The free trial period is only valid for new subscribers. Subscriptions automatically renew unless canceled at least 24 hours before the end of the current subscription period. All subscriptions can be managed through the Google Play Store. Any unused portion of the free trial will be forfeited when a subscription is purchased.';
}
