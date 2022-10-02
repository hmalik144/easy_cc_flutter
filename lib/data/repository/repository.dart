import '../model/currency.dart';
import '../prefs/currency_pair.dart';

abstract class Repository {
  CurrencyPair getConversionPair();
  Future<void> setConversionPair(String fromCurrency, String toCurrency);
  Future<Currency> getConversationRateFromApi(String fromCurrency, String toCurrency);
}