import 'package:shared_preferences/shared_preferences.dart';

import 'CurrencyPair.dart';

const String CURRENCY_ONE = "conversion_one";
const String CURRENCY_TWO = "conversion_two";
class PreferenceProvider {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveConversionPair(String s1, String s2) async {
    await _prefs.setString(CURRENCY_ONE, s1);
    await _prefs.setString(CURRENCY_TWO, s2);
  }

  CurrencyPair getConversionPair() {
    String? s1 = _prefs.getString(CURRENCY_ONE);
    String? s2 = _prefs.getString(CURRENCY_TWO);

    return CurrencyPair(s1, s2);
  }
}