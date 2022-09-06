import 'package:easy_cc_flutter/data/prefs/CurrencyPair.dart';
import 'package:easy_cc_flutter/data/prefs/PreferenceProvider.dart';

import '../../locator.dart';
import 'Repository.dart';

class RepositoryImpl extends Repository {
  final PreferenceProvider _prefs = locator<PreferenceProvider>();

  @override
  CurrencyPair getConversionPair() {
    return _prefs.getConversionPair();
  }

  @override
  Future<void> setConversionPair(String fromCurrency, String toCurrency) {
    return _prefs.saveConversionPair(fromCurrency, toCurrency);
  }

}