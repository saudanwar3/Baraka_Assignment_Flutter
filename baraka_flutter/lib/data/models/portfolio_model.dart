// Data Layer: Model for parsing the remote JSON data

import 'package:baraka_flutter_assignment/domain/entities/postition.dart';

class PortfolioModel {
  final Balance balance;
  final List<Position> positions;

  PortfolioModel({
    required this.balance,
    required this.positions,
  });

  // Factory method to parse the JSON structure
  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    final portfolioData = json['portfolio'] as Map<String, dynamic>;
    final balanceJson = portfolioData['balance'] as Map<String, dynamic>;
    final positionsJson = portfolioData['positions'] as List<dynamic>;


    final List<Position> positions = positionsJson.map((p) {
      final instrument = p['instrument'] as Map<String, dynamic>;
      // Mapping the JSON to the Position entity.
      return Position(
        ticker: instrument['ticker'] ?? '',
        name: instrument['name'] ?? '',
        exchange: instrument['exchange'] ?? '',
        currency: instrument['currency'] ?? 'USD',
        lastTradedPrice: instrument['lastTradedPrice']?.toDouble() ?? 0.0,
        quantity: p['quantity']?.toDouble() ?? 0.0,
        averagePrice: p['averagePrice']?.toDouble() ?? 0.0,
        cost: p['cost']?.toDouble() ?? 0.0,
        marketValue: p['marketValue']?.toDouble() ?? 0.0,
        pnl: p['pnl']?.toDouble() ?? 0.0,
        pnlPercentage: p['pnlPercentage']?.toDouble() ?? 0.0,
      );
    }).toList();

    // Mapping the JSON to the Balance entity.
    final Balance balance = Balance(
      netValue: balanceJson['netValue']?.toDouble() ?? 0.0,
      pnl: balanceJson['pnl']?.toDouble() ?? 0.0,
      pnlPercentage: balanceJson['pnlPercentage']?.toDouble() ?? 0.0,
    );

    return PortfolioModel(
      balance: balance,
      positions: positions,
    );
  }
}

// For simplicity, Balance is also defined as an entity
class Balance {
  double netValue;
  double pnl;
  double pnlPercentage;

  Balance({
    required this.netValue,
    required this.pnl,
    required this.pnlPercentage,
  });

  Balance copyWith({
    double? netValue,
    double? pnl,
    double? pnlPercentage,
  }) {
    return Balance(
      netValue: netValue ?? this.netValue,
      pnl: pnl ?? this.pnl,
      pnlPercentage: pnlPercentage ?? this.pnlPercentage,
    );
  }
}