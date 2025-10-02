// States: Represents the UI status

import 'package:baraka_flutter_assignment/data/models/portfolio_model.dart';
import 'package:baraka_flutter_assignment/domain/entities/postition.dart';

abstract class PortfolioState {}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoadedState extends PortfolioState {
  final Balance balance;
  final List<Position> positions;

  PortfolioLoadedState({required this.balance, required this.positions});
}

class PortfolioError extends PortfolioState {
  final String message;

  PortfolioError(this.message);
}