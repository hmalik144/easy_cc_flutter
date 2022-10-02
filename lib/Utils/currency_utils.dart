extension CurrencyExtension on String {
  /// Convert currency string into currency code
  /// eg. "AUD - Australian Dollar" to "AUD"
  String getCurrencyCode(){
    return substring(0,3);
  }
}