import 'dart:io';

import 'package:easy_cc_flutter/Utils/currency_utils.dart';
import 'package:easy_cc_flutter/data/model/currency.dart';
import 'package:easy_cc_flutter/data/prefs/currency_pair.dart';

import '../../main.dart';
import '../network/backup_currency_api.dart';
import '../network/currency_api.dart';
import '../network/safe_api_call.dart';
import '../prefs/preference_provider.dart';
import 'repository.dart';

class RepositoryImpl extends Repository with SafeApiCall {
  final PreferenceProvider _prefs;
  final CurrencyApi _api;
  final BackupCurrencyApi _backupApi;

  RepositoryImpl(this._prefs, this._api, this._backupApi);

  @override
  CurrencyPair getConversionPair() {
    return _prefs.getConversionPair();
  }

  @override
  Future<void> setConversionPair(String fromCurrency, String toCurrency) {
    return _prefs.saveConversionPair(fromCurrency, toCurrency);
  }

  @override
  Future<Currency> getConversationRateFromApi(String fromCurrency, String toCurrency) async {
    String from = fromCurrency.getCurrencyCode();
    String to = toCurrency.getCurrencyCode();

    try {
      ResponseObject responseObject = await getDataFromApiCall(_api.getConversion(from, to));
      return responseObject.convert();
    } on HttpException catch(error) {
      logger.e(error);
      CurrencyResponse responseObject = await getDataFromApiCall(_backupApi.getCurrencyRate(from, to));
      return responseObject.convert();
    }
  }
}