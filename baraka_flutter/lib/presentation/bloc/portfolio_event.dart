// Events: What can happen in the UI or from the data layer

import 'package:baraka_flutter_assignment/domain/entities/postition.dart';

abstract class PortfolioEvent {}

class PortfolioLoaded extends PortfolioEvent {}

class PortfolioPriceUpdated extends PortfolioEvent {
  final Position updatedPosition;

  PortfolioPriceUpdated(this.updatedPosition);
}