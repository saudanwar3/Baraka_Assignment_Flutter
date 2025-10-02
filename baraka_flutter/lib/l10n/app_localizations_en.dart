import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Baraka Portfolio';

  @override
  String get netValue => 'Net Value';

  @override
  String get pnlPercentage => 'PnL (PnL %)';

  @override
  String get positionTicker => 'Instrument: Ticker';

  @override
  String get positionPnl => 'Position: PnL (PnL %)';

  @override
  String get positionMarketValue => 'Position: Market Value';
}
