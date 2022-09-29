class Currency {
  String? from;
  String? to;
  double? rate;

  Currency(this.from, this.to, this.rate);
}

/// Mapper class to convert any object to [Currency]
abstract class CurrencyMapper {
  Currency convert();
}