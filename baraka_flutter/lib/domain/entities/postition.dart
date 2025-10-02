// Part of the Domain Layer: Core Business Entity
// Represents a single investment holding.

import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final String ticker;
  final String name;
  final String exchange;
  final String currency;
  double lastTradedPrice; // Needs to be updated by the live service
  final double quantity;
  final double averagePrice;
  final double cost;
  double marketValue;      // Calculated: quantity * lastTradedPrice
  double pnl;              // Calculated: marketValue - cost
  double pnlPercentage;    // Calculated: (pnl * 100) / cost

  Position({
    required this.ticker,
    required this.name,
    required this.exchange,
    required this.currency,
    required this.lastTradedPrice,
    required this.quantity,
    required this.averagePrice,
    required this.cost,
    required this.marketValue,
    required this.pnl,
    required this.pnlPercentage,
  });

  // Method to create a new Position with updated prices/calculations
  Position copyWith({
    double? lastTradedPrice,
    double? marketValue,
    double? pnl,
    double? pnlPercentage,
  }) {
    return Position(
      ticker: ticker,
      name: name,
      exchange: exchange,
      currency: currency,
      lastTradedPrice: lastTradedPrice ?? this.lastTradedPrice,
      quantity: quantity,
      averagePrice: averagePrice,
      cost: cost,
      marketValue: marketValue ?? this.marketValue,
      pnl: pnl ?? this.pnl,
      pnlPercentage: pnlPercentage ?? this.pnlPercentage,
    );
  }

  @override
  List<Object?> get props => [
    ticker,
    lastTradedPrice,
    marketValue,
    pnl,
    pnlPercentage,
  ];
}