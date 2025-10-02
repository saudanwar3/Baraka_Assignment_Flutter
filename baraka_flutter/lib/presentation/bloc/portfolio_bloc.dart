// Bloc: Handles business logic and state transitions
import 'dart:async';
import 'package:baraka_flutter_assignment/data/models/portfolio_model.dart';
import 'package:baraka_flutter_assignment/domain/entities/postition.dart';
import 'package:baraka_flutter_assignment/domain/repositories/portfolio_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

@injectable
class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final PortfolioRepository repository;
  StreamSubscription? _priceSubscription;
  List<Position> _currentPositions = [];
  Balance _currentBalance = Balance(netValue: 0, pnl: 0, pnlPercentage: 0);

  PortfolioBloc(this.repository) : super(PortfolioInitial()) {
    on<PortfolioLoaded>(_onPortfolioLoaded);
    on<PortfolioPriceUpdated>(_onPortfolioPriceUpdated);
  }

  Future<void> _onPortfolioLoaded(
      PortfolioLoaded event,
      Emitter<PortfolioState> emit,
      ) async {
    emit(PortfolioLoading());
    final result = await repository.getInitialPortfolio();

    await result.fold(
          (failure) async => emit(PortfolioError('Failed to load portfolio')),
          (portfolioModel) async {
        _currentPositions = portfolioModel.positions;
        _currentBalance = portfolioModel.balance;

        // Start the live price stream
        _priceSubscription?.cancel();
        _priceSubscription = repository.getLivePriceUpdates().listen(
              (updatedPosition) {
            add(PortfolioPriceUpdated(updatedPosition));
          },
          onError: (e) {
                print(e);
          },
        );

        emit(_calculateAndEmitState());
      },
    );
  }

  void _onPortfolioPriceUpdated(
      PortfolioPriceUpdated event,
      Emitter<PortfolioState> emit,
      ) {
    // Find and replace the old position with the newly calculated one
    final index = _currentPositions.indexWhere((p) => p.ticker == event.updatedPosition.ticker);
    if (index != -1) {
      _currentPositions[index] = event.updatedPosition;
      emit(_calculateAndEmitState());
    }
  }

  PortfolioLoadedState _calculateAndEmitState() {
    //  Calculate Balance values based on updated positions
    final totalMarketValue = _currentPositions.fold(0.0, (sum, p) => sum + p.marketValue);
    final totalPnl = _currentPositions.fold(0.0, (sum, p) => sum + p.pnl);
    final totalCost = _currentPositions.fold(0.0, (sum, p) => sum + p.cost);

    final newPnlPercentage = (totalPnl * 100) / (totalCost == 0 ? 1 : totalCost);

    _currentBalance = _currentBalance.copyWith(
      netValue: totalMarketValue,
      pnl: totalPnl,
      pnlPercentage: newPnlPercentage,
    );

    //  Emit the new state with the updated Balance and Positions
    return PortfolioLoadedState(
      balance: _currentBalance,
      positions: List.of(_currentPositions),
    );
  }

  // Mandatory override to clean up the stream when the Bloc is closed
  @override
  Future<void> close() {
    _priceSubscription?.cancel();
    return super.close();
  }
}