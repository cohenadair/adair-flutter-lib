import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'adair_flutter_lib_localizations_en.dart';
import 'adair_flutter_lib_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AdairFlutterLibLocalizations
/// returned by `AdairFlutterLibLocalizations.of(context)`.
///
/// Applications need to include `AdairFlutterLibLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/adair_flutter_lib_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AdairFlutterLibLocalizations.localizationsDelegates,
///   supportedLocales: AdairFlutterLibLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AdairFlutterLibLocalizations.supportedLocales
/// property.
abstract class AdairFlutterLibLocalizations {
  AdairFlutterLibLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AdairFlutterLibLocalizations of(BuildContext context) {
    return Localizations.of<AdairFlutterLibLocalizations>(
      context,
      AdairFlutterLibLocalizations,
    )!;
  }

  static const LocalizationsDelegate<AdairFlutterLibLocalizations> delegate =
      _AdairFlutterLibLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'US'),
    Locale('es'),
  ];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @continueString.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueString;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @yearsFormat.
  ///
  /// In en, this message translates to:
  /// **'{numOfYears}y'**
  String yearsFormat(int numOfYears);

  /// No description provided for @daysFormat.
  ///
  /// In en, this message translates to:
  /// **'{numOfDays}d'**
  String daysFormat(int numOfDays);

  /// No description provided for @hoursFormat.
  ///
  /// In en, this message translates to:
  /// **'{numOfHours}h'**
  String hoursFormat(int numOfHours);

  /// No description provided for @minutesFormat.
  ///
  /// In en, this message translates to:
  /// **'{numOfMinutes}m'**
  String minutesFormat(int numOfMinutes);

  /// No description provided for @secondsFormat.
  ///
  /// In en, this message translates to:
  /// **'{numOfSeconds}s'**
  String secondsFormat(int numOfSeconds);

  /// No description provided for @dateTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String dateTimeFormat(String date, String time);

  /// No description provided for @dateRangeFormat.
  ///
  /// In en, this message translates to:
  /// **'{from} to {to}'**
  String dateRangeFormat(String from, String to);

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @durationAllDates.
  ///
  /// In en, this message translates to:
  /// **'All dates'**
  String get durationAllDates;

  /// No description provided for @durationToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get durationToday;

  /// No description provided for @durationYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get durationYesterday;

  /// No description provided for @durationThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get durationThisWeek;

  /// No description provided for @durationThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get durationThisMonth;

  /// No description provided for @durationThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get durationThisYear;

  /// No description provided for @durationLastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get durationLastWeek;

  /// No description provided for @durationLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get durationLastMonth;

  /// No description provided for @durationLastYear.
  ///
  /// In en, this message translates to:
  /// **'Last year'**
  String get durationLastYear;

  /// No description provided for @durationLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get durationLast7Days;

  /// No description provided for @durationLast14Days.
  ///
  /// In en, this message translates to:
  /// **'Last 14 days'**
  String get durationLast14Days;

  /// No description provided for @durationLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get durationLast30Days;

  /// No description provided for @durationLast60Days.
  ///
  /// In en, this message translates to:
  /// **'Last 60 days'**
  String get durationLast60Days;

  /// No description provided for @durationLast12Months.
  ///
  /// In en, this message translates to:
  /// **'Last 12 months'**
  String get durationLast12Months;

  /// No description provided for @durationCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get durationCustom;

  /// No description provided for @proPageUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to {appName}'**
  String proPageUpgradeTitle(String appName);

  /// No description provided for @proPageProTitle.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get proPageProTitle;

  /// No description provided for @proPageYearlyTitle.
  ///
  /// In en, this message translates to:
  /// **'{price}/year'**
  String proPageYearlyTitle(String price);

  /// No description provided for @proPageYearlyTrial.
  ///
  /// In en, this message translates to:
  /// **'+{numOfDays} days free'**
  String proPageYearlyTrial(int numOfDays);

  /// No description provided for @proPageYearlySubtext.
  ///
  /// In en, this message translates to:
  /// **'Billed annually'**
  String get proPageYearlySubtext;

  /// No description provided for @proPageMonthlyTitle.
  ///
  /// In en, this message translates to:
  /// **'{price}/month'**
  String proPageMonthlyTitle(String price);

  /// No description provided for @proPageMonthlyTrial.
  ///
  /// In en, this message translates to:
  /// **'+{numOfDays} days free'**
  String proPageMonthlyTrial(int numOfDays);

  /// No description provided for @proPageMonthlySubtext.
  ///
  /// In en, this message translates to:
  /// **'Billed monthly'**
  String get proPageMonthlySubtext;

  /// No description provided for @proPageFetchError.
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch subscription options. Please ensure your device is connected to the internet and try again.'**
  String get proPageFetchError;

  /// No description provided for @proPageUpgradeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Congratulations, you are a Pro user!'**
  String get proPageUpgradeSuccess;

  /// No description provided for @proPageRestoreQuestion.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to Pro on another device?'**
  String get proPageRestoreQuestion;

  /// No description provided for @proPageRestoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore.'**
  String get proPageRestoreAction;

  /// No description provided for @proPageRestoreNoneFoundAppStore.
  ///
  /// In en, this message translates to:
  /// **'There were no previous purchases found. Please ensure you are signed in to the same Apple ID with which you made the original purchase.'**
  String get proPageRestoreNoneFoundAppStore;

  /// No description provided for @proPageRestoreNoneFoundGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'There were no previous purchases found. Please ensure you are signed in to the same Google account with which you made the original purchase.'**
  String get proPageRestoreNoneFoundGooglePlay;

  /// No description provided for @proPageRestoreError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred. Please ensure your device is connected to the internet and try again.'**
  String get proPageRestoreError;

  /// No description provided for @proPageDisclosureApple.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime. Billing starts after the free trial period ends. The free trial period is only valid for new subscribers. Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current subscription period. All subscriptions can be managed through the App Store. Any unused portion of the free trial will be forfeited when a subscription is purchased.'**
  String get proPageDisclosureApple;

  /// No description provided for @proPageDisclosureAndroid.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime. Billing starts after the free trial period ends. The free trial period is only valid for new subscribers. Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current subscription period. All subscriptions can be managed through the Google Play Store. Any unused portion of the free trial will be forfeited when a subscription is purchased.'**
  String get proPageDisclosureAndroid;

  /// No description provided for @dateFormatMonth.
  ///
  /// In en, this message translates to:
  /// **'MMM'**
  String get dateFormatMonth;

  /// No description provided for @dateFormatMonthDay.
  ///
  /// In en, this message translates to:
  /// **'MMM d'**
  String get dateFormatMonthDay;

  /// No description provided for @dateFormatMonthDayYear.
  ///
  /// In en, this message translates to:
  /// **'MMM d, yyyy'**
  String get dateFormatMonthDayYear;

  /// No description provided for @dateFormatMonthDayYearFull.
  ///
  /// In en, this message translates to:
  /// **'MMMM d, yyyy'**
  String get dateFormatMonthDayYearFull;

  /// No description provided for @dateFormatMonthFull.
  ///
  /// In en, this message translates to:
  /// **'MMMM'**
  String get dateFormatMonthFull;

  /// No description provided for @dateFormatMonthYearFull.
  ///
  /// In en, this message translates to:
  /// **'MMMM yyyy'**
  String get dateFormatMonthYearFull;

  /// No description provided for @dateFormatWeekDay.
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get dateFormatWeekDay;

  /// No description provided for @dateFormatWeekDayFull.
  ///
  /// In en, this message translates to:
  /// **'EEEE'**
  String get dateFormatWeekDayFull;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @proChipButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get proChipButtonLabel;

  /// No description provided for @notificationPermissionPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Notify'**
  String get notificationPermissionPageTitle;

  /// No description provided for @setPermissionButton.
  ///
  /// In en, this message translates to:
  /// **'Set Permission'**
  String get setPermissionButton;

  /// No description provided for @signInPageEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signInPageEmailLabel;

  /// No description provided for @signInPagePasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signInPagePasswordLabel;

  /// No description provided for @signInPageSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInPageSignInButton;

  /// No description provided for @signInPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInPageTitle;

  /// No description provided for @landingPageInitError.
  ///
  /// In en, this message translates to:
  /// **'Uh oh! Something went wrong during initialization. The {appName} team has been notified, and we apologize for the inconvenience.'**
  String landingPageInitError(Object appName);

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get by;
}

class _AdairFlutterLibLocalizationsDelegate
    extends LocalizationsDelegate<AdairFlutterLibLocalizations> {
  const _AdairFlutterLibLocalizationsDelegate();

  @override
  Future<AdairFlutterLibLocalizations> load(Locale locale) {
    return SynchronousFuture<AdairFlutterLibLocalizations>(
      lookupAdairFlutterLibLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AdairFlutterLibLocalizationsDelegate old) => false;
}

AdairFlutterLibLocalizations lookupAdairFlutterLibLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'US':
            return AdairFlutterLibLocalizationsEnUs();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AdairFlutterLibLocalizationsEn();
    case 'es':
      return AdairFlutterLibLocalizationsEs();
  }

  throw FlutterError(
    'AdairFlutterLibLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
