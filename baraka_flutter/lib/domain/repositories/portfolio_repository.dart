// Domain Layer: Defines the contract for fetching data.
import 'package:baraka_flutter_assignment/core/error/failures.dart';
import 'package:baraka_flutter_assignment/data/models/portfolio_model.dart';
import 'package:baraka_flutter_assignment/domain/entities/postition.dart';
import 'package:dartz/dartz.dart';

abstract class PortfolioRepository {
  // Returns the portfolio data or a failure
  Future<Either<Failure, PortfolioModel>> getInitialPortfolio();

  // Stream for live price updates (Bonus Task)
  Stream<Position> getLivePriceUpdates();
}