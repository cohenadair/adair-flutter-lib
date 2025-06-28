// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'adair_flutter_lib_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AdairFlutterLibLocalizationsEs extends AdairFlutterLibLocalizations {
  AdairFlutterLibLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get ok => 'Está bien';

  @override
  String get error => 'Error';

  @override
  String get warning => 'Advertencia';

  @override
  String get continueString => 'Continuar';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String yearsFormat(int numOfYears) {
    return '${numOfYears}a';
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
    return '${numOfMinutes}min';
  }

  @override
  String secondsFormat(int numOfSeconds) {
    return '${numOfSeconds}s';
  }

  @override
  String dateTimeFormat(String date, String time) {
    return '$date a las $time';
  }

  @override
  String dateRangeFormat(String from, String to) {
    return '$from a $to';
  }

  @override
  String get now => 'Now';

  @override
  String get durationAllDates => 'Todas las fechas';

  @override
  String get durationToday => 'Hoy';

  @override
  String get durationYesterday => 'Ayer';

  @override
  String get durationThisWeek => 'Esta semana';

  @override
  String get durationThisMonth => 'Este mes';

  @override
  String get durationThisYear => 'Este año';

  @override
  String get durationLastWeek => 'Última semana';

  @override
  String get durationLastMonth => 'Último mes';

  @override
  String get durationLastYear => 'Último año';

  @override
  String get durationLast7Days => 'Últimos 7 días';

  @override
  String get durationLast14Days => 'Últimos 14 días';

  @override
  String get durationLast30Days => 'Últimos 30 días';

  @override
  String get durationLast60Days => 'Últimos 60 días';

  @override
  String get durationLast12Months => 'Últimos 12 meses';

  @override
  String get durationCustom => 'Personalizado';

  @override
  String proPageUpgradeTitle(String appName) {
    return 'Actualiza a $appName';
  }

  @override
  String get proPageProTitle => 'Pro';

  @override
  String proPageYearlyTitle(String price) {
    return '$price / año';
  }

  @override
  String proPageYearlyTrial(int numOfDays) {
    return '+$numOfDays días gratis';
  }

  @override
  String get proPageYearlySubtext => 'Facturado anualmente';

  @override
  String proPageMonthlyTitle(String price) {
    return '$price al mes';
  }

  @override
  String proPageMonthlyTrial(int numOfDays) {
    return '+$numOfDays días gratis';
  }

  @override
  String get proPageMonthlySubtext => 'Facturado mensualmente';

  @override
  String get proPageFetchError =>
      'No se pueden obtener las opciones de suscripción. Asegúrate de que tu dispositivo esté conectado a Internet y vuelve a intentarlo.';

  @override
  String get proPageUpgradeSuccess =>
      '¡Felicidades, eres un usuario Pro de Anglers\' Log!';

  @override
  String get proPageRestoreQuestion => '¿Compraste Pro en otro dispositivo?';

  @override
  String get proPageRestoreAction => 'Restaurar.';

  @override
  String get proPageRestoreNoneFoundAppStore =>
      'No se encontraron compras anteriores. Asegúrate de haber iniciado sesión con el mismo ID de Apple con el que realizaste la compra original.';

  @override
  String get proPageRestoreNoneFoundGooglePlay =>
      'No se encontraron compras anteriores. Asegúrate de haber iniciado sesión con la misma cuenta de Google con la que realizaste la compra original.';

  @override
  String get proPageRestoreError =>
      'Ocurrió un error inesperado. Asegúrate de que tu dispositivo esté conectado a Internet y vuelve a intentarlo.';

  @override
  String get proPageDisclosureApple =>
      'Cancela en cualquier momento. La facturación comienza después de que finalice el período de prueba gratuito. El período de prueba gratuito solo es válido para nuevos suscriptores. Las suscripciones se renuevan automáticamente a menos que se cancelen al menos 24 horas antes del final del período de suscripción actual. Todas las suscripciones se pueden gestionar a través de la App Store. Cualquier parte no utilizada del período de prueba gratuito se perderá cuando se compre una suscripción.';

  @override
  String get proPageDisclosureAndroid =>
      'Cancela en cualquier momento. La facturación comienza después de que finalice el período de prueba gratuito. El período de prueba gratuito es válido solo para nuevos suscriptores. Las suscripciones se renuevan automáticamente a menos que se cancelen al menos 24 horas antes del final del período de suscripción actual. Todas las suscripciones se pueden gestionar a través de Google Play Store. Cualquier parte no utilizada del período de prueba gratuito se perderá cuando se compre una suscripción.';
}
