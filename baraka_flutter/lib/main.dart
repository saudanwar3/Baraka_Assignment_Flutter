// lib/main.dart

import 'package:baraka_flutter_assignment/l10n/app_localizations.dart';
import 'package:baraka_flutter_assignment/presentation/bloc/portfolio_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'presentation/bloc/locale_cubit.dart';
import 'presentation/bloc/portfolio_bloc.dart';
import 'presentation/pages/portfolio_screen.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PortfolioBloc>()..add(PortfolioLoaded()),
        ),
        // 1. PROVIDE THE NEW LOCALE CUBIT
        BlocProvider(
          create: (context) => getIt<LocaleCubit>(),
        ),
      ],
      // 2. USE BlocBuilder TO LISTEN TO THE LOCALE CUBIT STATE
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, localeState) {
          return MaterialApp(
            title: 'Baraka Portfolio',
            debugShowCheckedModeBanner: false,
            // 3. APPLY THE LOCALE FROM THE CUBIT STATE
            locale: localeState,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              useMaterial3: true,
            ),
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const PortfolioScreen(),
          );
        },
      ),
    );
  }
}