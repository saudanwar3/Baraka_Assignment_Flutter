import 'app_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'محفظة بركة';

  @override
  String get netValue => 'صافي القيمة';

  @override
  String get pnlPercentage => 'الربح/الخسارة (النسبة المئوية)';

  @override
  String get positionTicker => 'الأداة: الرمز';

  @override
  String get positionPnl => 'المركز: ر/خ (٪ ر/خ)';

  @override
  String get positionMarketValue => 'المركز: القيمة السوقية';
}
