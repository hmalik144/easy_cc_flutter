import '../prefs/CurrencyPair.dart';

abstract class Repository {
  CurrencyPair getConversionPair();
  Future<void> setConversionPair(String fromCurrency, String toCurrency);
}