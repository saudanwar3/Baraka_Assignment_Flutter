// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/datasources/portfolio_remote_data_source.dart' as _i5;
import '../../domain/repositories/portfolio_repository.dart' as _i6;
import '../../domain/repositories/portfolio_repository_impl.dart' as _i7;
import '../../presentation/bloc/locale_cubit.dart' as _i4;
import '../../presentation/bloc/portfolio_bloc.dart' as _i8;
import 'register_module.dart' as _i9;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i3.Dio>(() => registerModule.dio);
    gh.singleton<_i4.LocaleCubit>(() => _i4.LocaleCubit());
    gh.factory<_i5.PortfolioRemoteDataSource>(
        () => _i5.PortfolioRemoteDataSourceImpl(gh<_i3.Dio>()));
    gh.factory<_i6.PortfolioRepository>(
        () => _i7.PortfolioRepositoryImpl(gh<_i5.PortfolioRemoteDataSource>()));
    gh.factory<_i8.PortfolioBloc>(
        () => _i8.PortfolioBloc(gh<_i6.PortfolioRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i9.RegisterModule {}
