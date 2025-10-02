
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// The default locale is English
const Locale defaultLocale = Locale('en', '');
const Locale arabicLocale = Locale('ar', '');

@singleton
class LocaleCubit extends Cubit<Locale> {
  // Initialize with the default locale
  LocaleCubit() : super(defaultLocale);

  // Method to toggle the language
  void toggleLocale() {
    final newLocale = state == defaultLocale ? arabicLocale : defaultLocale;
    emit(newLocale);
  }
}