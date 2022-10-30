extension CurrencyExtension on String {
  /// Convert currency string into currency code
  /// eg. "AUD - Australian Dollar" to "AUD"
  String getCurrencyCode(){
    if (length == 3) {
      return this;
    }
    return substring(0,3);
  }
}