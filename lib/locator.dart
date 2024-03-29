import 'package:easy_cc_flutter/data/network/backup_currency_api.dart';
import 'package:easy_cc_flutter/data/network/currency_api.dart';
import 'package:easy_cc_flutter/data/repository/repository_impl.dart';
import 'package:easy_cc_flutter/main_view_model.dart';
import 'package:get_it/get_it.dart';

import 'data/prefs/preference_provider.dart';
import 'data/repository/repository.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => PreferenceProvider());
  locator.registerLazySingleton(() => CurrencyApi.create());
  locator.registerLazySingleton(() => BackupCurrencyApi.create());
  locator.registerLazySingleton<Repository>(() => RepositoryImpl(locator<PreferenceProvider>(), locator<CurrencyApi>(),locator<BackupCurrencyApi>()));
  locator.registerFactory(() => MainViewModel(locator<Repository>()));
}