import 'package:dio/dio.dart';
import 'package:easy_cc_flutter/MainViewModel.dart';
import 'package:easy_cc_flutter/data/network/backupCurrencyApi.dart';
import 'package:easy_cc_flutter/data/network/currencyApi.dart';
import 'package:easy_cc_flutter/data/repository/RepositoryImpl.dart';
import 'package:get_it/get_it.dart';

import 'data/prefs/PreferenceProvider.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => PreferenceProvider());
  locator.registerLazySingleton(() => CurrencyApi.create());
  locator.registerLazySingleton(() => BackupCurrencyApi.create());
  locator.registerLazySingleton(() => RepositoryImpl());
  locator.registerFactory(() => MainViewModel());
}