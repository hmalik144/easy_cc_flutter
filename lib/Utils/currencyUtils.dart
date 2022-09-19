extension CurrencyExtension on String {

  String getCurrencyCode(){
    return substring(0,3);
  }
}