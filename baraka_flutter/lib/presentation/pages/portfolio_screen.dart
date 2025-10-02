// UI: Portfolio Screen
import 'package:baraka_flutter_assignment/data/models/portfolio_model.dart';
import 'package:baraka_flutter_assignment/domain/entities/postition.dart';
import 'package:baraka_flutter_assignment/l10n/app_localizations.dart';
import 'package:baraka_flutter_assignment/presentation/bloc/locale_cubit.dart';
import 'package:baraka_flutter_assignment/presentation/bloc/portfolio_bloc.dart';
import 'package:baraka_flutter_assignment/presentation/bloc/portfolio_event.dart';
import 'package:baraka_flutter_assignment/presentation/bloc/portfolio_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Helper for formatting numbers
String formatCurrency(double value, {String currency = 'USD'}) {
  final sign = value >= 0 ? '' : '-';
  final formattedValue = (value.abs()).toStringAsFixed(2);
  return '$currency $sign$formattedValue';
}

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch data when the screen is first built
    context.read<PortfolioBloc>().add(PortfolioLoaded());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Hello', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              context.read<LocaleCubit>().toggleLocale();
            },
            child: const Text('EN/AR', style: TextStyle(color: Colors.green)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) {
          if (state is PortfolioLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PortfolioError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is PortfolioLoadedState) {
            return RefreshIndicator(
              onRefresh: () async => context.read<PortfolioBloc>().add(PortfolioLoaded()),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildBalanceCard(context, state.balance),
                  const SizedBox(height: 16),
                  ...state.positions.map((p) => PositionListTile(position: p)).toList(),
                ],
              ),
            );
          }
          return const Center(child: Text('Press refresh to load portfolio.'));
        },
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, Balance balance) {
    final l10n = AppLocalizations.of(context)!;

    final pnlColor = balance.pnl >= 0 ? Colors.green.shade700 : Colors.red.shade700;
    final pnlSign = balance.pnl >= 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    balance.netValue.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(l10n.netValue, style: const TextStyle(color: Colors.grey)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$pnlSign${balance.pnl.toStringAsFixed(2)} (${pnlSign}${balance.pnlPercentage.toStringAsFixed(2)}%)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: pnlColor),
                  ),
                  Text(l10n.pnlPercentage, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget for a single Position item
class PositionListTile extends StatelessWidget {
  final Position position;

  const PositionListTile({super.key, required this.position});

  @override
  Widget build(BuildContext context) {

    final pnlColor = position.pnl >= 0 ? Colors.green.shade700 : Colors.red.shade700;
    final pnlSign = position.pnl >= 0 ? '+' : '';

    // Ticker and Currency/Price row
    Widget _buildHeader() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            position.ticker,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '$pnlSign${position.pnl.toStringAsFixed(2)} (${pnlSign}${position.pnlPercentage.toStringAsFixed(2)}%)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: pnlColor),
          ),
        ],
      );
    }

    Widget _buildDetails() {
      final costText = '${position.quantity.toStringAsFixed(0)} x ${position.averagePrice.toStringAsFixed(2)} = ${position.cost.toStringAsFixed(2)}';

      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatCurrency(position.lastTradedPrice, currency: position.currency), // Currency and Last Traded Price
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                Text(
                  '${position.name} - ${position.exchange}', // Name and Exchange
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  costText, // Position: Quantity x Average Price = Cost
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 20),
                Text(
                  position.marketValue.toStringAsFixed(2), // Position: Market Value 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          _buildHeader(),
          _buildDetails(),
          const Divider(),
        ],
      ),
    );
  }
}