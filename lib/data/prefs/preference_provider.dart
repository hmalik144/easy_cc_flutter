import 'package:shared_preferences/shared_preferences.dart';

import 'currency_pair.dart';

const String currencyOne = "conversion_one";
const String currencyTwo = "conversion_two";
class PreferenceProvider {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveConversionPair(String s1, String s2) async {
    await _prefs.setString(currencyOne, s1);
    await _prefs.setString(currencyTwo, s2);
  }

  CurrencyPair getConversionPair() {
    String? s1 = _prefs.getString(currencyOne);
    String? s2 = _prefs.getString(currencyTwo);

    return CurrencyPair(s1, s2);
  }
}