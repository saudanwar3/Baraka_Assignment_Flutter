// Data Layer: Implements the actual data fetching logic.
import 'dart:async';
import 'dart:math';
import 'package:baraka_flutter_assignment/data/models/portfolio_model.dart';
import 'package:baraka_flutter_assignment/domain/entities/postition.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class PortfolioRemoteDataSource {
  Future<PortfolioModel> fetchInitialPortfolio();
  Stream<Position> getPriceStream(List<Position> initialPositions);
}

@Injectable(as: PortfolioRemoteDataSource)
class PortfolioRemoteDataSourceImpl implements PortfolioRemoteDataSource {
  final Dio client;
  final String _apiPath = 'https://dummyjson.com/c/60b7-70a6-4ee3-bae8';

  PortfolioRemoteDataSourceImpl(this.client);

  @override
  Future<PortfolioModel> fetchInitialPortfolio() async {
    try {
      final response = await client.get(_apiPath);
      return PortfolioModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      // Throw a custom exception that will be caught by the Repository
      throw ServerException();
    }
  }

  // --- Live Price Simulation ---
  @override
  Stream<Position> getPriceStream(List<Position> initialPositions) {
    final controller = StreamController<Position>();
    final random = Random();

    // Broadcasts an update for a random instrument every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (controller.isClosed) {
        timer.cancel();
        return;
      }

      // Select a random position to update
      final index = random.nextInt(initialPositions.length);
      final positionToUpdate = initialPositions[index];

      // Generate a new price: 10% more or less than the original lastTradedPrice
      // We'll use the original averagePrice as a base for simplicity.
      final basePrice = positionToUpdate.averagePrice;
      final maxChange = basePrice * 0.10; // 10% of the base price

      // Generate a random number between -maxChange and +maxChange
      final priceChange = random.nextDouble() * (2 * maxChange) - maxChange;

      final newPrice = basePrice + priceChange;

      // Update calculations for the position
      final newMarketValue = positionToUpdate.quantity * newPrice;
      final newPnl = newMarketValue - positionToUpdate.cost;
      final newPnlPercentage = (newPnl * 100) / positionToUpdate.cost;

      final updatedPosition = positionToUpdate.copyWith(
        lastTradedPrice: newPrice,
        marketValue: newMarketValue,
        pnl: newPnl,
        pnlPercentage: newPnlPercentage,
      );

      // In a real app, this should update the internal list of positions in the repository/bloc
      controller.sink.add(updatedPosition);
    });

    return controller.stream;
  }
}

// Custom Exception for error handling
class ServerException implements Exception {}