
import 'dart:async';
import 'package:baraka_flutter_assignment/core/error/failures.dart';
import 'package:baraka_flutter_assignment/data/datasources/portfolio_remote_data_source.dart';
import 'package:baraka_flutter_assignment/data/models/portfolio_model.dart';
import 'package:baraka_flutter_assignment/domain/entities/postition.dart';
import 'package:baraka_flutter_assignment/domain/repositories/portfolio_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Binds the implementation to the abstract interface.
@Injectable(as: PortfolioRepository)
class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioRemoteDataSource remoteDataSource;

  // Internal list to hold the current state of positions (needed for live updates)
  List<Position> _currentPositions = [];

  // 2. Dependency Injection: GetIt injects the registered remoteDataSource here.
  PortfolioRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PortfolioModel>> getInitialPortfolio() async {
    try {
      final portfolio = await remoteDataSource.fetchInitialPortfolio();
      // Store the initial positions for the live stream service
      _currentPositions = portfolio.positions;
      return Right(portfolio);
    } on ServerException {
      // Map the data layer exception (ServerException) to the domain failure (ServerFailure)
      return Left(ServerFailure());
    }
  }

  @override
  Stream<Position> getLivePriceUpdates() {
    // Delegate the live stream logic to the data source, passing the known positions.
    return remoteDataSource.getPriceStream(_currentPositions);
  }
}