import 'package:easy_cc_flutter/base_viewmodel.dart';
import 'package:easy_cc_flutter/Utils/selection_type.dart';

import 'Utils/constants.dart';
import 'data/prefs/currency_pair.dart';
import 'data/repository/repository.dart';
import 'data/repository/repository_impl.dart';
import 'locator.dart';

class MainViewModel extends BaseViewmodel {
  final Repository _repository = locator<RepositoryImpl>();

  double conversionRate = 1.0;

  String getConversionPair(SelectionType type) {
    CurrencyPair pair = _repository.getConversionPair();

    switch (type) {
      case SelectionType.conversionFrom:
        return pair.currencyOne != null
            ? pair.currencyOne!
            : listOfCurrencies[0];
      case SelectionType.conversionTo:
        return pair.currencyTwo != null
            ? pair.currencyTwo!
            : listOfCurrencies[0];
      default:
        throw NullThrownError();
    }
  }

  void setConversionPair(String fromCurrency, String toCurrency) {
    _repository.setConversionPair(fromCurrency, toCurrency);
    setCurrencyRate(fromCurrency, toCurrency);
  }

  void setCurrencyRate(String fromCurrency, String toCurrency) {
    onStart();
    _repository.getConversationRateFromApi(fromCurrency, toCurrency).then(
        (value) {
          conversionRate = value.rate != null ? value.rate! : 0.00;
          onSuccess(value);
    }, onError: (exception, _) {
          onError(exception.message);
    });
  }

  String convertInput(String? input, SelectionType type) {
    if (input == null || input.isEmpty) {
      return "";
    }
    double convertedInput = double.parse(input);

    switch (type) {
      case SelectionType.conversionFrom:
        return (convertedInput * conversionRate).toStringAsFixed(2);
      case SelectionType.conversionTo:
        return (convertedInput / conversionRate).toStringAsFixed(2);
    }
  }
}
